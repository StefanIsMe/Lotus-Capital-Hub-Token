# LotusCapitalTestToken

LotusCapitalTestToken is a smart contract that serves as a wrapper token for BNB on Polygon zkEVM. It inherits from ERC20, ERC20Burnable, Pausable, and Ownable contracts.

## Imports

The contract imports the following dependencies:

```solidity
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
```

## Variables

The contract defines the following variables:

- `bridge`: The address of the bridge contract used for minting and burning tokens.

## Modifiers

The contract defines the following modifier:

- `onlyBridge()`: Restricts access to the bridge contract.

## Version Number (Alpha Release): 1.0.0

## Changelog

The following changes have been made between the previous version and the current version:

- Upgraded the contract to use `ERC20Burnable` from OpenZeppelin to add burning functionality.
- Updated the `mint` function to use `virtual` and `override` keywords.
- Updated the `burn` function to use `virtual` and `override` keywords.
- Added the `burnFrom` function to allow burning tokens from a specified account.
- Removed the `checkGasLimit` modifier.
- Updated the `pause` function to use the `onlyOwner` modifier.
- Updated the `unpause` function to use the `onlyOwner` modifier.
- Renamed the `BridgeContractSet` event to `Mint` and added the `Burn` event to emit token burning events.
- Renamed the `pause` event to `Paused` and added the `Unpaused` event to emit pause/unpause events.

## Deployment to Polygon zkEVM Testnet

This contract has been deployed to the Polygon zkEVM testnet. The deployed contract address is [0xf423c8fafD0Aa3ee911AfBC44f4D8eA713f7C9Dd](https://testnet-zkevm.polygonscan.com/token/0xf423c8fafD0Aa3ee911AfBC44f4D8eA713f7C9Dd). You can access the contract details and transactions on [PolygonScan](https://testnet-zkevm.polygonscan.com/token/0xf423c8fafD0Aa3ee911AfBC44f4D8eA713f7C9Dd).

## Usage

The contract provides the following functions and features:

- `mint(address recipient, uint256 amount) public virtual onlyBridge whenNotPaused`: Mints tokens to the specified recipient. Only the bridge contract can call this function, and it can only be called when the contract is not paused.
- `burn(uint256 amount) public override(ERC20Burnable) virtual onlyBridge whenNotPaused`: Burns tokens from the caller's balance. Only the bridge contract can call this function, and it can only be called when the contract is not paused.
- `burnFrom(address account, uint256 amount) public override(ERC20Burnable) virtual onlyBridge whenNotPaused`: Burns tokens from the specified account. Only the bridge contract can call this function, and it can only be called when the contract is not paused.
- `pause() public onlyOwner`: Pauses contract operations. Only the contract

 owner can call this function.
- `unpause() public onlyOwner`: Unpauses contract operations. Only the contract owner can call this function.
