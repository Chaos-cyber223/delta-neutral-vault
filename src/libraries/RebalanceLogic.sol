// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RebalanceLogic
 * @notice Core logic for calculating and executing rebalance operations
 */
library RebalanceLogic {
    struct Position {
        uint256 aaveSupply;      // USDC supplied to Aave
        uint256 aaveBorrow;      // ETH borrowed from Aave
        uint256 uniswapLiquidity; // LP tokens in Uniswap
        uint256 lastRebalancePrice; // ETH price at last rebalance
    }
    
    /**
     * @notice Check if rebalance is needed based on price deviation
     * @param currentPrice Current ETH/USDC price
     * @param lastPrice Price at last rebalance
     * @param threshold Deviation threshold (e.g., 5% = 500 basis points)
     * @return bool True if rebalance needed
     */
    function shouldRebalance(
        uint256 currentPrice,
        uint256 lastPrice,
        uint256 threshold
    ) internal pure returns (bool) {
        // TODO: Implement price deviation check
        // Calculate percentage change
        // Compare against threshold
        return false;
    }
    
    /**
     * @notice Calculate delta exposure of current position
     * @return int256 Delta value (0 = perfectly neutral)
     */
    function calculateDelta(Position memory pos, uint256 ethPrice) 
        internal 
        pure 
        returns (int256) 
    {
        // TODO: Calculate net exposure
        // Long exposure from LP position
        // Short exposure from borrowed ETH
        // Return net delta
        return 0;
    }
}
