## Polygon zkEVM Contracts

- [Introduction](#introduction)
- [Contracts](#contracts)
- [Interactions](#interactions)
- [Getting Started](#getting-started)
- [Versioning](#versioning)
- [Changelog](#changelog)
- [License](#license)

## Introduction
This repository contains smart contracts that facilitate the bridging of tokens between the main chain and the Polygon zkEVM sidechain. The contracts are implemented using Solidity and leverage the OpenZeppelin library.

## Contracts

1. **PolygonZkEVM.sol**
   - Description: This contract represents a child ERC20 token on the Polygon zkEVM sidechain. It allows minting and burning of tokens by the bridge contract, pausing and unpausing token transfers, and implements modifiers to restrict access to certain functions.

2. **SideBridge.sol**
   - Description: This contract acts as the bridge between the main chain and the sidechain on Polygon zkEVM. It initializes the bridge, manages the bridging and returning of tokens, and enforces access control through modifiers.

3. **IERC20Child.sol**
   - Description: This interface defines the functions that the child ERC20 token contract on the sidechain must implement. It extends the `IERC20` interface from the OpenZeppelin library.

## Token Deployment

A new version of the token has been deployed for testing purposes. The token contract address is `0x889a20ea66c0e4b9069aFd2C50bAdD24493a9473` on the Polygon zkEVM testnet. You can view the contract details by clicking [here](https://testnet-zkevm.polygonscan.com/address/0x889a20ea66c0e4b9069aFd2C50bAdD24493a9473).

Please note that this deployment is for testing purposes only and may not represent the final production version of the token.

## SideBridge Contract Deployment

A new version of the SideBridge contract has been deployed for testing purposes. The contract address is `0xBcEF7A514e68B235e5Ad3c096B375FDe642bEAeF` on the Polygon zkEVM testnet. You can view the contract details by clicking [here](https://testnet-zkevm.polygonscan.com/address/0xBcEF7A514e68B235e5Ad3c096B375FDe642bEAeF).

Please note that this deployment is for testing purposes only and may not represent the final production version of the SideBridge contract.

## Interactions

1. The `PolygonZkEVM` contract represents the child token on the sidechain and can be deployed on the Polygon zkEVM sidechain.

2. The `SideBridge` contract is deployed on the main chain and acts as the bridge contract responsible for transferring tokens between the main chain and the sidechain.

3. The `SideBridge` contract initializes the bridge by setting the child token contract address and manages the bridging and returning of tokens between the main chain and the sidechain.

4. The bridge contract interacts with the child token contract through the `IERC20Child` interface to perform token minting and burning.

5. Access control is enforced to ensure that only the designated gateway contract can execute bridging and returning functions.

## Getting Started

To deploy and interact with these contracts, follow the steps below:

1. Deploy the `PolygonZkEVM` contract on the Polygon zkEVM sidechain.

2. Deploy the `SideBridge` contract on the main chain and provide the address of the child token contract on the sidechain when initializing the bridge.

3. Use the bridge contract to bridge tokens between the main chain and the sidechain by calling the appropriate functions.

4. Ensure that the bridge contract is secured and only accessible by the designated gateway contract.

For more details on the contract functionalities and usage, refer to the individual contract files in this repository.

## Versioning

The current release is an alpha release.

## Changelog

### [Alpha Release] - 2023-06-26

### [Alpha Release] - 2023-06-25

- Initial release of the Polygon zkEVM contracts.
- Includes `PolygonZkEVM.sol`, `SideBridge.sol`, and `IERC20Child.sol`.
- Enables bridging of tokens between the main chain and the Polygon zkEVM sidechain.
- Implements token minting, burning, pausing, and unpausing functionality.
- Provides access control and validation mechanisms.
- Supports interaction between the child token contract and the bridge contract.

### [Previous Changes]

- [2023-06-25] Added `SideBridge.sol` contract for bridging tokens between the main chain and the Polygon zkEVM sidechain.
- [2023-06-25] Created `IERC20Child.sol` interface for the child ERC20 token used on sidechains and L2 networks.
- [2023-06-25] Renamed `TokenChild.sol` to `PolygonZkEVM.sol` for better clarity and conformity.
- [2023-06-25] Refactored and optimized code for better gas efficiency and readability.
- [2023-06-25] Improved access control and validation mechanisms for secure token operations.

## License

This project is licensed under the [MIT License](LICENSE).
