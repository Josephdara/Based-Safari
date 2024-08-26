// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

contract CoffeeShopToken is ERC20, Ownable2Step {
    enum Loyalty {
        Esteemed,
        Bronze,
        Silver,
        Gold,
        Diamond
    }

    address public shopTreasury;
    uint256 public basisPoints = 10000; // 100% basis points
    uint256 public minimumSpend; // Minimum spend required to make a shopPay transaction

    mapping(address => uint256) public userOrders; // Tracks the number of orders per user
    mapping(address => Loyalty) public userLoyalty; // Maps user to their loyalty level
    mapping(Loyalty => uint32) public loyaltyDiscounts; // Maps loyalty levels to discount rates

    // Events
    event ShopTreasuryUpdated(
        address indexed oldTreasury,
        address indexed newTreasury
    );
    event LoyaltyDiscountUpdated(
        Loyalty indexed loyaltyLevel,
        uint32 oldDiscount,
        uint32 newDiscount
    );
    event ShopPaymentMade(
        address indexed user,
        uint256 amount,
        uint256 finalAmount,
        Loyalty loyaltyLevel
    );
    event ShopPaymentNoDiscountMade(address indexed user, uint256 amount);
    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);
    event MinimumSpendUpdated(uint256 oldMinimumSpend, uint256 newMinimumSpend);

    constructor(
        uint256 initialSupply,
        address initialTreasury,
        uint256 initialMinimumSpend
    ) Ownable(msg.sender) ERC20("CoffeeShopToken", "CST") {
        _mint(msg.sender, initialSupply);
        shopTreasury = initialTreasury;
        minimumSpend = initialMinimumSpend;
        transferOwnership(msg.sender);

        // Set initial discount values in basis points
        loyaltyDiscounts[Loyalty.Esteemed] = 0; // No discount
        loyaltyDiscounts[Loyalty.Bronze] = 500; // 5% discount
        loyaltyDiscounts[Loyalty.Silver] = 1000; // 10% discount
        loyaltyDiscounts[Loyalty.Gold] = 1500; // 15% discount
        loyaltyDiscounts[Loyalty.Diamond] = 2000; // 20% discount
    }

    function setShopTreasury(address newTreasury) external onlyOwner {
        require(newTreasury != address(0), "Invalid address for treasury");
        address oldTreasury = shopTreasury;
        shopTreasury = newTreasury;
        emit ShopTreasuryUpdated(oldTreasury, newTreasury);
    }

    function setLoyaltyDiscount(
        Loyalty loyaltyLevel,
        uint32 discount
    ) external onlyOwner {
        require(discount <= basisPoints, "Discount exceeds 100%");
        uint32 oldDiscount = loyaltyDiscounts[loyaltyLevel];
        loyaltyDiscounts[loyaltyLevel] = discount;
        emit LoyaltyDiscountUpdated(loyaltyLevel, oldDiscount, discount);
    }

    function setMinimumSpend(uint256 newMinimumSpend) external onlyOwner {
        uint256 oldMinimumSpend = minimumSpend;
        minimumSpend = newMinimumSpend;
        emit MinimumSpendUpdated(oldMinimumSpend, newMinimumSpend);
    }

    function shopPay(uint256 amount) external returns (bool) {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        require(shopTreasury != address(0), "Treasury address not set");
        require(
            amount >= minimumSpend,
            "Amount less than minimum spend requirement"
        );

        // Calculate discount based on user's loyalty level
        uint32 discount = loyaltyDiscounts[userLoyalty[msg.sender]];
        uint256 discountAmount = (amount * discount) / basisPoints;
        uint256 finalAmount = amount - discountAmount;

        // Transfer the discounted amount to the shop's treasury
        _transfer(msg.sender, shopTreasury, finalAmount);

        // Increment the user's order count
        userOrders[msg.sender] += 1;

        // Update loyalty level based on order count
        updateLoyaltyLevel(msg.sender);

        emit ShopPaymentMade(
            msg.sender,
            amount,
            finalAmount,
            userLoyalty[msg.sender]
        );

        return true;
    }

    function shopPayNoDiscount(uint256 amount) external returns (bool) {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        require(shopTreasury != address(0), "Treasury address not set");

        // Transfer the full amount to the shop's treasury without any discount
        _transfer(msg.sender, shopTreasury, amount);

        emit ShopPaymentNoDiscountMade(msg.sender, amount);

        return true;
    }

    function getDiscount(address user) public view returns (uint32) {
        return loyaltyDiscounts[userLoyalty[user]];
    }

    function updateLoyaltyLevel(address user) internal {
        uint256 orders = userOrders[user];
        if (orders >= 50) {
            userLoyalty[user] = Loyalty.Diamond;
        } else if (orders >= 30) {
            userLoyalty[user] = Loyalty.Gold;
        } else if (orders >= 20) {
            userLoyalty[user] = Loyalty.Silver;
        } else if (orders >= 10) {
            userLoyalty[user] = Loyalty.Bronze;
        } else {
            userLoyalty[user] = Loyalty.Esteemed;
        }
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    function burn(uint256 amount) external onlyOwner {
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }
}
