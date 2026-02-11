# Delta-Neutral Vault

> **⚠️ This is a Proof-of-Concept for technical demonstration purposes only. Not production-ready.**

## What is Delta-Neutral?

A delta-neutral strategy aims to eliminate directional price risk by balancing long and short positions.

**This vault:**
1. Deposits user funds (USDC) into Aave to earn lending yield
2. Provides liquidity on Uniswap V3 (ETH/USDC) to earn trading fees
3. Borrows ETH from Aave to hedge against ETH price movements
4. Automatically rebalances when price deviates beyond threshold

## Architecture

```
User USDC → Vault
    ├─→ Aave: Supply USDC (earn interest)
    ├─→ Aave: Borrow ETH (short exposure)
    └─→ Uniswap V3: LP position (ETH/USDC, earn fees)
```

**Key Components:**
- `DeltaNeutralVault.sol` - Main vault contract
- `RebalanceLogic.sol` - Core rebalancing algorithm
- `interfaces/` - Aave & Uniswap integrations

## Why Rebalance?

When ETH price moves significantly:
- LP position becomes imbalanced
- Borrowed ETH value changes
- Delta exposure drifts from neutral

Rebalancing restores the hedge by adjusting positions.

## Testing Strategy

Built with Foundry, focusing on:
- ✅ Price volatility scenarios
- ✅ Rebalance trigger logic
- ✅ Overflow/underflow protection
- ✅ Reentrancy guards
- ✅ Fuzz testing for edge cases

## Setup

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install dependencies
forge install

# Run tests
forge test

# Run with gas report
forge test --gas-report

# Fuzz testing
forge test --match-test testFuzz
```

## Project Status

**Implemented (60-70%):**
- Core vault structure
- Rebalance logic
- Comprehensive test suite

**Not Implemented (intentionally):**
- Production-grade access control
- Emergency pause mechanisms
- Fee optimization
- Multi-asset support

This project demonstrates understanding of:
- DeFi composability (Aave + Uniswap)
- Risk management (delta-neutral hedging)
- Smart contract testing best practices

## License

MIT
