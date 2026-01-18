// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/**
 * @title Web3bridge
 * @dev Main contract for Web3Bridge implementation
 * @author draifodil
 */
contract Web3bridge is Ownable, ReentrancyGuard, Pausable {
    
    // State variables
    uint256 public totalOperations;
    uint256 public constant MAX_BATCH_SIZE = 100;
    
    // Mappings
    mapping(address => uint256) public userOperations;
    mapping(bytes32 => DataRecord) public records;
    
    // Structs
    struct DataRecord {
        bytes32 dataHash;
        address creator;
        uint256 timestamp;
        bool isActive;
    }
    
    // Events
    event OperationExecuted(address indexed user, bytes32 indexed recordId, uint256 timestamp);
    event RecordCreated(bytes32 indexed recordId, address indexed creator);
    event RecordUpdated(bytes32 indexed recordId, address indexed updater);
    event RecordDeactivated(bytes32 indexed recordId);
    
    // Errors
    error InvalidInput();
    error RecordNotFound();
    error RecordAlreadyExists();
    error Unauthorized();
    
    constructor() Ownable(msg.sender) {
        totalOperations = 0;
    }
    
    /**
     * @dev Create a new data record
     * @param data The data to store
     * @return recordId The unique identifier for the record
     */
    function createRecord(bytes calldata data) 
        external 
        nonReentrant 
        whenNotPaused 
        returns (bytes32 recordId) 
    {
        if (data.length == 0) revert InvalidInput();
        
        recordId = keccak256(abi.encodePacked(data, msg.sender, block.timestamp));
        
        if (records[recordId].timestamp != 0) revert RecordAlreadyExists();
        
        records[recordId] = DataRecord({
            dataHash: keccak256(data),
            creator: msg.sender,
            timestamp: block.timestamp,
            isActive: true
        });
        
        userOperations[msg.sender]++;
        totalOperations++;
        
        emit RecordCreated(recordId, msg.sender);
        emit OperationExecuted(msg.sender, recordId, block.timestamp);
        
        return recordId;
    }
    
    /**
     * @dev Get a record by ID
     * @param recordId The record identifier
     * @return The data record
     */
    function getRecord(bytes32 recordId) 
        external 
        view 
        returns (DataRecord memory) 
    {
        if (records[recordId].timestamp == 0) revert RecordNotFound();
        return records[recordId];
    }
    
    /**
     * @dev Deactivate a record (only creator or owner)
     * @param recordId The record identifier
     */
    function deactivateRecord(bytes32 recordId) 
        external 
        nonReentrant 
    {
        DataRecord storage record = records[recordId];
        if (record.timestamp == 0) revert RecordNotFound();
        if (record.creator != msg.sender && owner() != msg.sender) revert Unauthorized();
        
        record.isActive = false;
        emit RecordDeactivated(recordId);
    }
    
    /**
     * @dev Batch create records
     * @param dataArray Array of data to store
     * @return recordIds Array of record identifiers
     */
    function batchCreateRecords(bytes[] calldata dataArray) 
        external 
        nonReentrant 
        whenNotPaused 
        returns (bytes32[] memory recordIds) 
    {
        if (dataArray.length == 0 || dataArray.length > MAX_BATCH_SIZE) revert InvalidInput();
        
        recordIds = new bytes32[](dataArray.length);
        
        for (uint256 i = 0; i < dataArray.length; i++) {
            bytes32 recordId = keccak256(abi.encodePacked(dataArray[i], msg.sender, block.timestamp, i));
            
            records[recordId] = DataRecord({
                dataHash: keccak256(dataArray[i]),
                creator: msg.sender,
                timestamp: block.timestamp,
                isActive: true
            });
            
            recordIds[i] = recordId;
            emit RecordCreated(recordId, msg.sender);
        }
        
        userOperations[msg.sender] += dataArray.length;
        totalOperations += dataArray.length;
        
        return recordIds;
    }
    
    /**
     * @dev Pause the contract
     */
    function pause() external onlyOwner {
        _pause();
    }
    
    /**
     * @dev Unpause the contract
     */
    function unpause() external onlyOwner {
        _unpause();
    }
    
    /**
     * @dev Get user statistics
     * @param user The user address
     * @return operations Number of operations by user
     */
    function getUserStats(address user) external view returns (uint256 operations) {
        return userOperations[user];
    }
}
