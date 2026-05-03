// scripts/deploy.js
const hre = require("hardhat");

async function main() {
    console.log("Deploying Web3bridge...");
    
    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying with account:", deployer.address);
    
    const balance = await hre.ethers.provider.getBalance(deployer.address);
    console.log("Account balance:", hre.ethers.formatEther(balance), "ETH");
    
    const Contract = await hre.ethers.getContractFactory("Web3bridge");
    const contract = await Contract.deploy();
    
    await contract.waitForDeployment();
    
    const address = await contract.getAddress();
    console.log("Web3bridge deployed to:", address);
    
    // Verify on Etherscan (if not localhost)
    if (hre.network.name !== "localhost" && hre.network.name !== "hardhat") {
        console.log("Waiting for block confirmations...");
        await contract.deploymentTransaction().wait(5);
        
        console.log("Verifying contract on Etherscan...");
        try {
            await hre.run("verify:verify", {
                address: address,
                constructorArguments: [],
            });
            console.log("Contract verified!");
        } catch (error) {
            console.log("Verification failed:", error.message);-
        }
    }
    
    return address;
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
