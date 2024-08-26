// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/CoffeeShopToken.sol";

contract DeployCoffeeShopToken is Script {
    function run() external {
        // Define the parameters for the contract deployment
        uint256 initialSupply = 1000000 * 10 ** 18; // 1,000,000 tokens with 18 decimals
        address shopTreasury = msg.sender; // Replace with your shop treasury address
        uint256 minimumSpend = 10 * 10 ** 18; // Minimum spend set to 100 tokens

        // Start broadcasting transactions to the network
        vm.startBroadcast();

        // Deploy the CoffeeShopToken contract
        CoffeeShopToken token = new CoffeeShopToken(initialSupply, shopTreasury, minimumSpend);

        // End broadcasting transactions
        vm.stopBroadcast();

        // Log the address of the deployed contract
        console.log("CoffeeShopToken deployed at:", address(token));
    }
}
