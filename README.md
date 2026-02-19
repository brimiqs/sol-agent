# sol-agent

# Install dependencies and build
npm install
npm run build

# Install the CLI globally
npm install -g .

# Run the setup wizard (creates ~/.sol-agent/ and generates a Solana keypair)
sol-agent --setup

# Start the agent
sol-agent --run

Command,Description
sol-agent --run,Start the agent (triggers setup wizard on first run)
sol-agent --setup,Re-run the interactive setup wizard
sol-agent --init,Initialize Solana wallet and config directory
sol-agent --status,Show current agent status
sol-agent --version,Show version
sol-agent --help,Show help

Variable,Description
SOLANA_RPC_URL,Solana RPC URL (overrides config)
ANTHROPIC_API_KEY,Anthropic API key (overrides config)
OPENAI_API_KEY,OpenAI API key (overrides config)
INFERENCE_MODEL,"Primary inference model (overrides config, e.g. claude-opus-4-6)"
LOW_COMPUTE_MODEL,Model used in low-compute / critical survival mode
DOCKER_IMAGE,Docker image for child containers
