# Documentation

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/StefanIsMe/Lotus-Capital-Hub-Token/blob/main/LICENSE)

## Table of Contents

- [Introduction](#introduction)
- [Folder/File Structure](#folderfile-structure)
- [Testing BNB Token Contract Details](#testing-bnb-token-contract-details)
- [BNB Bridge.sol Documentation](#bnb-bridgesol-documentation)
  - [Contract Details](#contract-details)
  - [Interactions with Testing BNB Token.sol](#interactions-with-testing-bnb-tokensol)
  - [Usage](#usage)
- [License](#license)

## Introduction

The purpose of this project is to develop a bridge between Binance Smart Chain (BSC) and the Polygon ZK-EVM. The main goal is to enable the seamless transfer of assets between these two blockchains. Due to compliance issues with EIP-170, the original Lotus Capital token (LC), which is a BabyToken clone, cannot be deployed. Therefore, a testing BNB token (TestBNB) has been created to simulate the functionality of the mainnet token during the testing phase. The BNB Bridge contract serves as the lock contract, facilitating the communication and message relay between the Binance Smart Chain and the Polygon ZK-EVM.

## Folder/File Structure

```
parent directory
..
├── BNB Bridge.sol
│   ├── (File)
│   └── Create BNB Bridge.sol
├── Testing BNB Token.sol
│   ├── (File)
│   └── Update Testing BNB Token.sol
└── readme.md
    ├── (File)
    └── Update readme.md
```

## Testing BNB Token Contract Details

The `Testing BNB Token.sol` contract is a basic ERC20 token contract written in Solidity. It represents the testing BNB token (TestBNB) on the Binance Smart Chain.

- SPDX-License-Identifier: MIT: This line specifies the license under which the contract is released. In this case, it is released under the MIT license.
- Pragma Directive: The `pragma solidity ^0.8.9;` statement specifies the version of Solidity the contract is written in. The caret symbol (^) indicates that any compatible version greater than or equal to 0.8.9 can be used.
- Contract Variables:
  - `_name`: A private variable that represents the name of the token.
  - `_symbol`: A private variable that represents the symbol of the token.
  - `_decimals`: A private variable that represents the number of decimal places for the token.
  - `_totalSupply`: A private variable that represents the total supply of the token.
  - `_balances`: A mapping that keeps track of the token balances for each address.
  - `_allowances`: A mapping that keeps track of the approved token allowances between addresses.
- Events:
  - `Transfer`: This event is emitted when tokens are transferred from one address to another.
  - `Approval`: This event is emitted when the approval of token transfer between addresses is made.
- Constructor: The constructor function is called when the contract is deployed and initializes the contract with an initial supply of tokens.
- Public Functions:
  - `name()`: Returns the name of the token.
  - `symbol()`: Returns the symbol of the token.
  - `decimals()`: Returns the number of decimal places for the token.
  - `totalSupply()`: Returns the total supply of the token.
 

 - `balanceOf(address account)`: Returns the token balance of a specific address.
  - `transfer(address recipient, uint256 amount)`: Transfers tokens from the sender's address to the recipient's address.
  - `approve(address spender, uint256 amount)`: Approves a specific amount of tokens to be spent by the designated spender address.
  - `allowance(address owner, address spender)`: Returns the remaining token allowance for a specific spender address.
  - `transferFrom(address sender, address recipient, uint256 amount)`: Transfers tokens from one address to another on behalf of a sender address.

## BNB Bridge.sol Documentation

The `BNB Bridge.sol` contract is a Solidity smart contract that facilitates the bridging of tokens between Binance Smart Chain (BSC) and the Ethereum blockchain. It interacts with the `Testing BNB Token.sol` contract to lock and unlock tokens during the bridging process.

### Contract Details

- SPDX-License-Identifier: MIT: This line specifies the license under which the contract is released. In this case, it is released under the MIT license.
- Pragma Directive: The `pragma solidity ^0.8.0;` statement specifies the version of Solidity the contract is written in. The caret symbol (^) indicates that any compatible version greater than or equal to 0.8.0 can be used.
- External Contract: The contract imports the `IERC20` interface from the OpenZeppelin Contracts library. This interface defines the standard functions for an ERC20 token contract.
- Contract Variables:
  - `mainToken`: A private variable of type `IERC20` that represents the main token contract.
  - `gateway`: An address variable that stores the address of the gateway contract responsible for the bridging process.
- Events:
  - `TokensLocked`: This event is emitted when tokens are locked in the bridge contract, indicating a deposit from the main chain.
  - `TokensUnlocked`: This event is emitted when tokens are unlocked from the bridge contract, indicating a withdrawal to the main chain.
- Constructor: The constructor function is called when the contract is deployed and initializes the contract by setting the main token contract and the gateway address.
- Public Functions:
  - `lockTokens`: This function is used to lock tokens in the bridge contract. It takes parameters such as the requester's address, the bridged amount, and the main deposit hash. Only the gateway contract can execute this function.
  - `unlockTokens`: This function is used to unlock tokens from the bridge contract. It transfers the bridged amount of tokens to the requester's address and emits the `TokensUnlocked` event. Only the gateway contract can execute this function.
- Modifier: 
  - `onlyGateway`: This modifier restricts the execution of certain functions to be only allowed by the gateway contract. It ensures that only the designated gateway contract can call the `lockTokens` and `unlockTokens` functions.

### Interactions with Testing BNB Token.sol

The `BNB Bridge.sol` contract interacts with the `Testing BNB Token.sol` contract in the following way:

1. The `BNB Bridge.sol` contract imports the `IERC20` interface, which provides the necessary functions to interact with ERC20 tokens, including the `transfer` function.
2. In the `unlockTokens` function of `BNB Bridge.sol`, the contract calls the `transfer` function of the `Testing BNB Token.sol` contract to transfer the bridged amount of tokens back to the requester's address on the Binance Smart Chain.
3. This interaction ensures that the unlocked tokens from the bridge contract are transferred to the designated address on the Binance Smart Chain, allowing for seamless token transfers between the two blockchains.

###

 Usage

To use the `BNB Bridge.sol` contract, follow these steps:

1. Deploy the `BNB Bridge.sol` contract to the Ethereum blockchain.
2. Pass the address of the main token contract (such as `Testing BNB Token.sol`) and the gateway contract during deployment.
3. Interact with the contract through the following functions:
   - `lockTokens`: Call this function from the gateway contract to lock tokens in the bridge contract, indicating a deposit from the Binance Smart Chain.
   - `unlockTokens`: Call this function from the gateway contract to unlock tokens from the bridge contract, indicating a withdrawal to the Binance Smart Chain. This function will transfer the unlocked tokens to the designated address on the Binance Smart Chain using the `Testing BNB Token.sol` contract.
4. Ensure proper integration and configuration with the `Testing BNB Token.sol` contract to enable seamless bridging of tokens between Binance Smart Chain and Ethereum.

Please note that the successful bridging of tokens between Binance Smart Chain and Ethereum requires coordination and integration between the `BNB Bridge.sol` contract and the `Testing BNB Token.sol` contract.

## License

This project is licensed under the [MIT License](https://github.com/StefanIsMe/Lotus-Capital-Hub-Token/blob/main/LICENSE).
