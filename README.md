# Delta-Neutral Vault

**A composable DeFi vault implementing market-neutral yield strategies through automated position hedging.**

> **Disclaimer:** This is a technical proof-of-concept demonstrating DeFi protocol integration and risk management primitives. Not audited or production-ready.

---

## Overview

This vault implements a delta-neutral strategy by combining lending yield (Aave V3) with liquidity provision fees (Uniswap V3) while maintaining zero directional exposure to underlying asset price movements.

### Strategy Mechanics

The vault constructs a market-neutral position through three simultaneous operations:

1. **Collateral Supply** — Deposits user capital (USDC) into Aave V3 as collateral, earning supply-side interest
2. **Short Hedge** — Borrows ETH against USDC collateral, creating synthetic short exposure
3. **Liquidity Provision** — Deploys borrowed ETH + remaining USDC into Uniswap V3 ETH/USDC pool, capturing trading fees

**Net Position:**
- Long exposure: Uniswap V3 LP position (50/50 ETH/USDC at current price)
- Short exposure: Aave borrowed ETH
- Delta: ~0 (market-neutral)

### Rebalancing Mechanism

Price movements cause LP positions to drift from 50/50 balance (impermanent loss), breaking delta neutrality. The vault monitors price deviation and triggers rebalancing when:

```
|current_price - last_rebalance_price| / last_rebalance_price > threshold
```

Rebalancing operations:
- Adjust borrowed ETH amount to match LP exposure
- Reposition Uniswap liquidity range if needed
- Restore delta-neutral state

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     DeltaNeutralVault                       │
│                                                             │
│  User Deposits (USDC)                                       │
│         │                                                   │
│         ├──► Aave V3 Pool                                   │
│         │    • Supply USDC (collateral)                     │
│         │    • Borrow ETH (short exposure)                  │
│         │    • Earn supply APY                              │
│         │                                                   │
│         └──► Uniswap V3 Pool (ETH/USDC)                     │
│              • Provide liquidity (concentrated range)       │
│              • Earn trading fees                            │
│              • Long exposure to ETH/USDC                    │
│                                                             │
│  Net Delta ≈ 0 (hedged)                                     │
└─────────────────────────────────────────────────────────────┘
```

### Core Components

| Contract | Purpose |
|----------|---------|
| `DeltaNeutralVault.sol` | Main vault logic, user deposits/withdrawals, position management |
| `RebalanceLogic.sol` | Delta calculation, rebalance trigger conditions, position adjustment math |
| `IAave.sol` | Aave V3 Pool interface (supply, borrow, repay, withdraw) |
| `IUniswapV3.sol` | Uniswap V3 position management (mint, burn, collect fees) |

---

## Risk Considerations

### Mitigated Risks
- **Directional Price Risk** — Hedged through offsetting long/short positions
- **Smart Contract Risk** — Integrates with battle-tested protocols (Aave V3, Uniswap V3)
- **Reentrancy** — Protected via OpenZeppelin ReentrancyGuard

### Residual Risks
- **Impermanent Loss** — Exists between rebalance intervals; minimized through frequent rebalancing
- **Liquidation Risk** — Aave position must maintain healthy collateralization ratio
- **Gas Costs** — Rebalancing operations consume gas; threshold tuning required
- **Oracle Manipulation** — Relies on Uniswap TWAP for price feeds (not implemented in PoC)

---

## Testing Approach

Built with **Foundry** to demonstrate production-grade testing practices:

### Unit Tests (`DeltaNeutralVault.t.sol`)
- Deposit/withdrawal flows
- Position initialization
- Rebalance trigger conditions
- Access control boundaries

### Fuzz Tests (`RebalanceFuzz.t.sol`)
- Price deviation edge cases (extreme volatility)
- Arithmetic overflow/underflow protection
- Invariant testing (delta remains bounded)
- Gas consumption under various conditions

### Key Test Scenarios
```solidity
// Price volatility
testFuzzShouldRebalance(uint256 currentPrice, uint256 lastPrice, uint256 threshold)

// Position math
testFuzzCalculateDelta(uint256 aaveSupply, uint256 aaveBorrow, uint256 uniswapLiquidity)

// Reentrancy protection
testNoReentrancy()
```

---

## Development Setup

### Prerequisites
```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Verify installation
forge --version
```

### Build & Test
```bash
# Clone repository
git clone https://github.com/Chaos-cyber223/delta-neutral-vault.git
cd delta-neutral-vault

# Install dependencies (forge-std, OpenZeppelin)
forge install foundry-rs/forge-std
forge install OpenZeppelin/openzeppelin-contracts

# Compile contracts
forge build

# Run test suite
forge test -vvv

# Gas profiling
forge test --gas-report

# Fuzz testing (10k runs)
forge test --match-test testFuzz --fuzz-runs 10000
```

### Environment Configuration
```bash
cp .env.example .env
# Add RPC URLs and API keys
```

---

## Technical Highlights

This project demonstrates:

1. **DeFi Protocol Composability** — Integrating Aave lending markets with Uniswap AMM liquidity
2. **Financial Engineering** — Implementing delta-neutral hedging strategies on-chain
3. **Risk Management** — Automated rebalancing to maintain target exposure
4. **Testing Rigor** — Fuzz testing, invariant checks, gas optimization
5. **Code Quality** — Modular architecture, clear separation of concerns, comprehensive documentation

**Target Audience:** Institutional DeFi teams, quantitative trading desks, protocol developers

---

## References

- [Aave V3 Documentation](https://docs.aave.com/developers/core-contracts/pool)
- [Uniswap V3 Whitepaper](https://uniswap.org/whitepaper-v3.pdf)
- [Delta-Neutral Strategies in DeFi](https://research.paradigm.xyz/)
- [Foundry Book](https://book.getfoundry.sh/)

---

## License

MIT

---

## About the Author

**Rhea Wang**  
M.S. in Statistics, University of Pennsylvania

Background in statistical modeling, applied machine learning, and cloud-native engineering, with a focus on building reliable on-chain risk systems.

Currently focused on on-chain risk, MEV analysis, and DeFi market behavior.

Open to Web3 / Crypto roles (remote or Singapore-based).

**GitHub:** [Chaos-cyber223](https://github.com/Chaos-cyber223)
