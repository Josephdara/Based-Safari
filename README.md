


# Coffee Shop on Base


## Overview

CoffeeShopToken is a custom ERC20 smart contract designed to enable token-based payments and a loyalty rewards program in a coffee shop setting. The contract is built using Solidity and leverages OpenZeppelin’s ERC20 implementation. It features a robust loyalty system that rewards customers based on their spending, alongside administrative controls for minting, burning, and managing the contract.

## Features

- **ERC20 Token Standard**: Implements the ERC20 standard, ensuring compatibility with a wide range of wallets and exchanges.
- **Loyalty Program**: Five loyalty levels—Esteemed, Bronze, Silver, Gold, Diamond—each offering increasing discounts.
- **Shop Payments**: Supports payments with and without discounts, with the ability to track customer spending.
- **Administrative Controls**:
  - Minting and burning of tokens.
  - Setting the shop's treasury address.
  - Updating minimum spend requirements and loyalty discounts.
- **Secure Ownership**: Utilizes OpenZeppelin's `Ownable2Step` for secure contract ownership transfers.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Contract Details](#contract-details)
- [Loyalty Program](#loyalty-program)
- [Deployment](#deployment)
- [Testing](#testing)
- [References](#references)

## Installation

To get started with the CoffeeShopToken project, follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Josephdara/Based-Safari.git
   cd Based-Safari
   ```

2. **Install Foundry** (if not already installed):
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

3. **Install dependencies**:
   ```bash
   forge install OpenZeppelin/openzeppelin-contracts
   ```

## Usage

### Compiling the Contract

To compile the smart contract, run:
```bash
forge build
```

### Testing the Contract

To run the test suite and ensure everything works as expected:
```bash
forge test
```

### Deploying the Contract

To deploy the CoffeeShopToken contract to a blockchain network (e.g., Ethereum, Base), follow the steps outlined in the [Deployment](#deployment) section.

## Contract Details

### Constructor

The `CoffeeShopToken` contract is initialized with the following parameters:

- `uint256 initialSupply`: The total supply of tokens minted at deployment.
- `address shopTreasury`: The address where payment tokens are sent.
- `uint256 initialMinimumSpend`: The minimum amount of tokens required to make a purchase.

### Core Functions

- **`shopPay(uint256 amount)`**: Allows users to make a payment with tokens. The function applies a discount based on the user's loyalty level and updates their loyalty status accordingly.

- **`shopPayNoDiscount(uint256 amount)`**: Allows users to make a payment without applying any discounts. This function does not increment the user's order count.

- **`mint(address to, uint256 amount)`**: Allows the owner to mint new tokens.

- **`burn(uint256 amount)`**: Allows the owner to burn tokens from the owner's balance.

### Administrative Functions

- **`setShopTreasury(address newTreasury)`**: Updates the shop's treasury address.
- **`setLoyaltyDiscount(Loyalty loyaltyLevel, uint32 discount)`**: Sets the discount percentage for a specific loyalty level.
- **`setMinimumSpend(uint256 newMinimumSpend)`**: Updates the minimum spend requirement for making a purchase.

## Loyalty Program

The loyalty program is a key feature of the CoffeeShopToken contract. Users are rewarded with discounts based on their spending, with five loyalty levels:

1. **Esteemed**: 0% discount (default level).
2. **Bronze**: 5% discount.
3. **Silver**: 10% discount.
4. **Gold**: 15% discount.
5. **Diamond**: 20% discount.

Users progress through the loyalty levels based on the number of purchases they make, with higher levels offering greater discounts.

## Deployment

### Deployment to Base Network

1. **Prepare the deployment script**:
   - Ensure the `DeployCoffeeShopToken.s.sol` script has the correct parameters for `initialSupply`, `shopTreasury`, and `minimumSpend`.

2. **Deploy and verify the contract**:
```bash
  forge script script/DeployCoffeeShopToken.s.sol:DeployCoffeeShopToken --rpc-url ["ENTER YOUR RPC"] --private-key ["ENTER YOUR Private Key"] --broadcast --verify  --etherscan-api-key ["ENTER YOUR Basescan api key"] -vvvv
```
RPC urls for base sepolia can be gotten from [Alchemy](https://www.alchemy.com/) or any other source listed in the base docs
Base API Keys can be created at [BaseScan](https://basescan.org/), create an account, login, and create a key
 
## Testing

The project includes a comprehensive suite of tests to ensure the contract functions as expected. Tests are written using Foundry and include:

- **Initial setup verification**: Ensures the contract is initialized correctly.
- **Loyalty progression**: Tests how users progress through loyalty levels based on their spending.
- **Shop payments**: Verifies payments with and without discounts.
- **Minting and burning tokens**: Ensures that only the owner can mint and burn tokens, and that balances are updated correctly.

Run the tests with:
```bash
forge test
```

 

## References

- **OpenZeppelin Documentation**: [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/5.x/)
- **Solidity Documentation**: [Solidity Language](https://docs.soliditylang.org/)
- **Foundry Documentation**: [Foundry Book](https://book.getfoundry.sh/)
- **Base Network**: [Base](https://base.org/) - Learn more about the Base Layer 2 scaling solution.
- **Ethereum Documentation**: [Ethereum Docs](https://ethereum.org/en/developers/docs/)
- **ERC20 Standard**: [EIP-20: Token Standard](https://eips.ethereum.org/EIPS/eip-20)
 

# BASE
[Base](https://docs.base.org/) is a secure, low-cost, builder-friendly Ethereum L2 built on the OP stack.  It provides the same security as Ethereum with minimal differences in [Opcodes](https://docs.optimism.io/stack/differences)

Multiple developer tools are available to easy development, deployment and management on the Base Network. All of these are lsited here: https://docs.base.org/docs/

 