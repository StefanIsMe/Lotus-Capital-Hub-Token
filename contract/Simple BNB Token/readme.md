# Documentation

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/StefanIsMe/Lotus-Capital-Hub-Token/blob/main/LICENSE)

The `LotusCapital.sol` contract is a basic ERC20 token contract written in Solidity. It represents the Lotus Capital token (LC) on the Ethereum blockchain.

## Contract Details

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

## Folder/File Structure

```
parent directory
..
├── BNB Bridge.sol
│   ├── (File)
│   ├── Create BNB Bridge.sol
│   └── 47 minutes ago
├── Testing BNB Token.sol
│   ├── (File)
│   ├── Update Testing BNB Token.sol
│   └── 2 days ago
└── readme.md
    ├── (File)
    ├── Update readme.md
    └── 2 days ago
```

## Usage

To use the `LotusCapital.sol` contract, you can deploy it to an Ethereum network using tools such as Remix, Truffle, or Hardhat. Once deployed, you can interact with the contract by calling its public functions to perform various operations such as transferring tokens, approving token allowances, and checking token balances.

## License

This project is licensed under the [MIT License](https://github.com/StefanIsMe/Lotus-Capital-Hub-Token/blob/main/LICENSE).
