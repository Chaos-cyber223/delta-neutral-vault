// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/DeltaNeutralVault.sol";

/**
 * @title Deploy
 * @notice Deployment script for DeltaNeutralVault
 */
contract Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        DeltaNeutralVault vault = new DeltaNeutralVault();
        
        console.log("DeltaNeutralVault deployed at:", address(vault));
        
        vm.stopBroadcast();
    }
}
