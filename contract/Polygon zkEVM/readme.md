# PolygonWrapperToken Documentation

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Welcome to the PolygonWrapperToken documentation! This documentation provides an overview and explanation of the PolygonWrapperToken contract, its functions, and modifiers.

## Overview

The PolygonWrapperToken contract is a wrapper token contract that facilitates the seamless transfer of tokens between the Binance Smart Chain (BSC) and the Polygon network. It allows users to deposit tokens from the BSC network to the Polygon network and withdraw tokens from the Polygon network to the BSC network. Additionally, it provides functionality for estimating gas costs, transferring tokens with reduced gas, and approving token reclaims.

## Contract Details

- SPDX-License-Identifier: MIT: This line specifies the license under which the contract is released. In this case, it is released under the MIT license.
- Pragma Directive: The `pragma solidity ^0.8.0;` statement specifies the version of Solidity the contract is written in. The caret symbol (^) indicates that any compatible version greater than or equal to 0.8.0 can be used.
- Imports: The contract imports two libraries from the OpenZeppelin library: ERC20 and SafeMath. These libraries provide standard ERC20 functionality and safe mathematical operations, respectively.

## Contract Variables

- `gasLimit`: A public variable that represents the gas limit for token transfers. It specifies the maximum amount of gas that can be used in a transaction. The initial value is set to 100,000.
- `bnbTokenAddress`: An address variable that stores the address of the BNB (Binance Coin) token on the BSC Testnet.
- `depositedTokens`: A mapping that keeps track of the deposited token amounts for each user.
- `bridgeContractAddress`: An address variable that stores the address of the bridge contract. Only the bridge contract is allowed to call certain functions.
- `owner`: An address variable that represents the owner of the contract.
- `tokenReclaimApprovals`: A mapping that keeps track of approved token reclaim amounts for specific addresses.

## Events

The contract defines several events:

- `Deposit`: This event is emitted when a user deposits tokens from the BSC network to the Polygon network. It includes the depositor's address and the deposited amount.
- `Withdrawal`: This event is emitted when a user withdraws tokens from the Polygon network to the BSC network. It includes the recipient's address and the withdrawn amount.
- `TokenReclaimApproved`: This event is emitted when the owner approves a token reclaim for a specific address. It includes the approved address and the approved amount.
- `TokenReclaimCompleted`: This event is emitted when the owner completes a token reclaim for a specific address. It includes the address and the amount of tokens reclaimed.

## Constructor

The constructor function is called when the contract is deployed and initialized. It takes three parameters:

- `_name`: The name of the wrapper token.
- `_symbol`: The symbol of the wrapper token.
- `_bnbTokenAddress`: The address of the BNB token on the BSC Testnet.

The constructor sets the `bnbTokenAddress` variable with the provided address, initializes the `owner` variable, and sets the initial `gasLimit` value to 100,000.

## Deposit and Withdrawal Functions

The contract provides two functions for depositing and withdrawing tokens:

- `depositTokens`: This function allows users to deposit tokens from the BSC network to the Polygon network. It takes the amount of tokens to be deposited as a parameter. The function transfers the tokens from the user to the contract, updates the deposited token amount for the user, and emits a `Deposit` event.
- `withdrawTokens`: This function allows users to withdraw tokens from the Polygon network to the BSC network. It takes the amount of tokens to be withdrawn as a parameter. The function updates the deposited token amount for the user, burns the tokens from the user's balance, and transfers the tokens from the contract to the user on the BSC Testnet. It emits a `Withdrawal` event.

## Modifiers

The contract defines two modifiers:

- `onlyBridge`: This modifier restricts the execution of a function to only the bridge contract address. It ensures that only the bridge contract can call certain functions.
- `onlyOwner`: This modifier restricts the execution of a function to only the owner of the contract. It ensures that only the owner can call certain functions.

## Owner Management Functions

The contract provides functions to manage the ownership of the contract:

- `setBridgeContract`: This function allows the owner to set the address of the bridge contract.
- `setBNBTokenAddress`: This function allows the owner to set the address of the BNB token on the BSC Testnet.
- `transferOwnership`: This function allows the current owner to transfer ownership of the contract to a new address.
- `renounceOwnership`: This function allows the current owner to renounce ownership of the contract.

## Gas Estimation and Transfer Functions

The contract provides functions related to gas estimation and token transfers:

- `estimateGasCost`: This function estimates the gas cost for a transfer by calculating the difference in gas before and after the transfer.
- `transferWithReducedGas`: This function allows users to transfer tokens with a reduced gas cost using EIP-2930. It checks if the gas limit is sufficient for the transfer and external call, calculates the gas cost, and performs the token transfer and external call.

## Gas Limit Management

The contract provides a function to set the gas limit:

- `setGasLimit`: This function allows the owner to set the gas limit for token transfers.

## Token Reclaim

The contract provides functionality for approving and completing token reclaims:

- `approveTokenReclaim`: This function allows the owner to approve a token reclaim for a specific address and amount.
- `reclaimTokens`: This function allows the owner to reclaim tokens from a specific address. It updates the deposited token amount, burns the tokens, and emits a `TokenReclaimCompleted` event.

## Total Supply

Note: The PolygonWrapperToken contract does not include a total supply variable or functionality. This is because it is designed as a wrapper token rather than a standalone token with its own supply. The contract focuses on facilitating the deposit and withdrawal of tokens between networks, rather than tracking a separate supply.

## License

This project is licensed under the [MIT License](LICENSE).
