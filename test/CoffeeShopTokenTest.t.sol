// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/CoffeeShopToken.sol";

contract CoffeeShopTokenTest is Test {
    CoffeeShopToken token;
    address owner = address(1);
    address user = address(2);
    address shopTreasury = address(3);

    uint256 initialSupply = 1000000 * 10 ** 18;

    function setUp() public {
        vm.prank(owner);
        token = new CoffeeShopToken(initialSupply, shopTreasury, 100 * 10 ** 18);

        // Transfer tokens to the user
        vm.prank(owner);
        token.transfer(user, 1500 * 10 ** 18);
    }

    function testInitialSetup() public {
        assertEq(token.shopTreasury(), shopTreasury);
        assertEq(token.minimumSpend(), 100 * 10 ** 18);
        assertEq(token.balanceOf(user), 1500 * 10 ** 18);
        assertEq(token.balanceOf(owner), initialSupply - 1500 * 10 ** 18);
    }

    function testLoyaltyLevelProgressionToBronze() public {
        // Set the initial loyalty discount for Bronze level to 5%
        vm.prank(owner);
        token.setLoyaltyDiscount(CoffeeShopToken.Loyalty.Bronze, 500); // 5% discount

        // Ensure the purchase amount is at least equal to the minimum spend
        uint256 purchaseAmount = token.minimumSpend(); // Use the minimum spend amount
        uint256 numberOfPurchases = 10; // Bronze level is reached after 10 purchases
        uint256 expectedBalance = token.balanceOf(user);
        uint256 expectedShopTreasuryBalance = 0;

        for (uint256 i = 0; i < numberOfPurchases; i++) {
                  // Calculate the expected discount and final amount for each purchase
            uint256 discount = (purchaseAmount * token.getDiscount(user)) / token.basisPoints();
            uint256 finalAmount = purchaseAmount - discount;
            expectedBalance -= purchaseAmount;
            expectedShopTreasuryBalance += finalAmount;
            vm.prank(user);
            bool success = token.shopPay(purchaseAmount);
            assertTrue(success);

      
        }

        // Verify the final balance in the shopTreasury
        assertEq(token.balanceOf(shopTreasury), expectedShopTreasuryBalance);
        // Verify the final balance of the user
        assertEq(token.balanceOf(user), expectedBalance);

        // Verify that the user's loyalty level is now Bronze
        assertEq(uint256(token.userLoyalty(user)), uint256(CoffeeShopToken.Loyalty.Bronze));
    }

    function testShopPayNoDiscount() public {
        vm.prank(user);
        bool success = token.shopPayNoDiscount(100 * 10 ** 18);
        assertTrue(success);
        assertEq(token.balanceOf(shopTreasury), 100 * 10 ** 18); // Full amount transferred
        assertEq(token.balanceOf(user), 1400 * 10 ** 18); // 1500 - 100 = 1400
    }

    function testMintTokens() public {
        uint256 mintAmount = 1000 * 10 ** 18;

        vm.prank(owner);
        token.mint(owner, mintAmount);
        assertEq(token.balanceOf(owner), initialSupply - 1500 * 10 ** 18 + mintAmount);
    }

    function testBurnTokens() public {
        uint256 burnAmount = 500 * 10 ** 18;

        vm.prank(owner);
        token.mint(owner, 1000 * 10 ** 18); // Mint additional tokens for burning

        vm.prank(owner);
        token.burn(burnAmount);
        assertEq(token.balanceOf(owner), initialSupply - 1500 * 10 ** 18 + 500 * 10 ** 18); // Balance after burning
    }

    function testSetShopTreasury() public {
        address newTreasury = address(4);

        vm.prank(owner);
        token.setShopTreasury(newTreasury);
        assertEq(token.shopTreasury(), newTreasury);
    }

    function testSetLoyaltyDiscount() public {
        vm.prank(owner);
        token.setLoyaltyDiscount(CoffeeShopToken.Loyalty.Gold, 2500);
        assertEq(token.loyaltyDiscounts(CoffeeShopToken.Loyalty.Gold), 2500);
    }

    function testSetMinimumSpend() public {
        vm.prank(owner);
        token.setMinimumSpend(200 * 10 ** 18);
        assertEq(token.minimumSpend(), 200 * 10 ** 18);
    }
}
