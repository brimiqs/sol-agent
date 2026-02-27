♾️ Everclaw — AI Inference You Own, Forever
Powering Your OpenClaw Agents

Open-source first. Everclaw connects your OpenClaw agent to the Morpheus decentralized inference network — putting open-source models like GLM-5 (Opus 4.5-level) front and center as your default, with Claude as a fallback only when needed.

Your agent runs on inference you own: GLM-5, GLM-4.7 Flash, Kimi K2.5, and 30+ models powered by staked MOR tokens that recycle back to you.

No API bills.
No credit limits.
No surprise costs.

MOR is staked — not spent — so you maintain access for as long as you hold your tokens.
🆕 DIY Setup Guide

Want to build an always-on Morpheus-powered agent from scratch on a Mac mini?

Complete walkthrough including:

Identity separation

On-chain guardrails

Three-tier inference fallback

9 documented gotchas

Every step tested on real hardware
📦 Install
From ClawHub
clawhub install everclaw-inference
One-command installer
curl -fsSL https://raw.githubusercontent.com/profbernardoj/everclaw/main/scripts/install-everclaw.sh | bash
Manual clone
git clone https://github.com/profbernardoj/everclaw.git ~/.openclaw/workspace/skills/everclaw

⚠️ Use everclaw-inference — not everclaw.
The bare everclaw slug on ClawHub belongs to a different, unrelated product ("Everclaw Vault"). See CLAWHUB_WARNING.md.

⚙️ Configure Your OpenClaw Agent
Gateway Only (no local proxy needed)
node ~/.openclaw/workspace/skills/everclaw/scripts/setup.mjs --template gateway-only --key YOUR_KEY --apply --test --restart
Full Setup (Local P2P + Gateway)
node ~/.openclaw/workspace/skills/everclaw/scripts/setup.mjs --key YOUR_KEY --apply --test --restart

Get a free API key at app.mor.org.
Run without --apply first to preview changes.

🔗 Optional: Enable Local P2P Inference
Step 1 — Install Morpheus proxy-router
bash ~/.openclaw/workspace/skills/everclaw/scripts/install.sh
Step 2 — Create Wallet (stored in macOS Keychain)
node ~/.openclaw/workspace/skills/everclaw/scripts/everclaw-wallet.mjs setup
Step 3 — Swap ETH → MOR
node ~/.openclaw/workspace/skills/everclaw/scripts/everclaw-wallet.mjs swap eth 0.05
Step 4 — Approve MOR for staking
node ~/.openclaw/workspace/skills/everclaw/scripts/everclaw-wallet.mjs approve
Step 5 — Install proxy + guardian (auto-start on boot)
bash ~/.openclaw/workspace/skills/everclaw/scripts/install-proxy.sh

That’s it. Your agent now has decentralized inference — via API Gateway (instant) or local P2P (stake MOR for persistent access you own).

👤 Who Is This For?

You do not need to be an engineer. If you can copy and paste commands, you can set this up.

Everclaw is built for early adopters who:

Run an OpenClaw agent on a Mac mini, laptop, or VPS and want it online 24/7

Use AI daily for writing, research, analysis, coding, or communication

Own or want to own MOR tokens and want productive utility

Care about decentralization and censorship resistance

Want their agent to handle crypto (DeFi, token management, wallet ops) securely

If your AI assistant has ever gone dark because an API key expired or credits ran out — Everclaw solves that permanently.

🔧 How It Works

Get MOR tokens on Base (swap from ETH or USDC)

Stake MOR to open an inference session (7 days default)

Your agent sends requests through a local proxy

When the session ends, your MOR comes back

Restake and repeat forever

Your Agent
    ↓
Everclaw Proxy (port 8083)
    ↓
Morpheus P2P Network
    ↓
AI Model

The proxy handles sessions, renewals, authentication, and routing.
Your agent talks to a standard OpenAI-compatible API.
