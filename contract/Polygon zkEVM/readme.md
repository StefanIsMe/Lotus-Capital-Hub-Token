# LotusCapitalTestToken

LotusCapitalTestToken is a smart contract that serves as a wrapper token for BNB on Polygon zkEVM. It inherits from ERC20, Ownable, and Pausable contracts.

## Imports

The contract imports the following dependencies:

```solidity
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
```

## Variables

The contract defines the following variables:

- `bridgeContract`: The address of the bridge contract used for minting and burning tokens.

## Modifiers

The contract defines the following modifiers:

- `checkGasLimit()`: Checks if the remaining gas is sufficient.
- `onlyBridgeContract()`: Restricts access to the bridge contract.

## Deployment to Polygon zkEVM Testnet

This contract has been deployed to the Polygon zkEVM testnet. The deployed contract address is [0xf423c8fafD0Aa3ee911AfBC44f4D8eA713f7C9Dd](https://testnet-zkevm.polygonscan.com/token/0xf423c8fafD0Aa3ee911AfBC44f4D8eA713f7C9Dd). You can access the contract details and transactions on [PolygonScan](https://testnet-zkevm.polygonscan.com/token/0xf423c8fafD0Aa3ee911AfBC44f4D8eA713f7C9Dd).

## Usage

The contract provides the following functions and features:

- `setBridgeContract(address _bridgeContract) external onlyOwner`: Sets the address of the bridge contract.
- `mint(address to, uint256 amount) external onlyBridgeContract checkGasLimit`: Mints tokens to the specified address. Only the bridge contract can call this function, and it checks the gas limit.
- `burn(address from, uint256 amount) external onlyBridgeContract checkGasLimit`: Burns tokens from the specified address. Only the bridge contract can call this function, and it checks the gas limit.
- `pause() external onlyOwner checkGasLimit`: Pauses contract operations. Only the contract owner can call this function, and it checks the gas limit.
- `unpause() external onlyOwner checkGasLimit`: Unpauses contract operations. Only the contract owner can call this function, and it checks the gas limit.

Additionally, the contract overrides the `_beforeTokenTransfer` function from the ERC20 contract to include pausing functionality.

## Contact

If you find a bug or security issue in this code, please contact info@lotuscapitalhub.com.

---

This documentation provides an overview of the LotusCapitalTestToken contract and its functions, including the imported dependencies, defined variables, and modifiers. It also includes information about the contract's deployment to the Polygon zkEVM testnet, with the contract address [0xf423c8fafD0Aa3ee911AfBC44f4D8eA713f7C9Dd](https://testnet-zkevm.polygonscan.com/token/0xf423c8fafD0Aa3ee911AfBC44f4D8eA713f7C9Dd) accessible on [PolygonScan](https://testnet-zkevm.polygonscan.com/token/0xf423c8fafD0Aa3ee911AfBC44f4D8e

A713f7C9Dd).

Refer to the Solidity code for more implementation details and additional comments. If you encounter any bugs or security issues in this code, please contact info@lotuscapitalhub.com.
