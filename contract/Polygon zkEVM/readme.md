# MyWrappedToken

MyWrappedToken is a smart contract that serves as a wrapper token for BNB on Polygon zkEVM. It inherits from ERC20, Ownable, and Pausable contracts.

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

## Usage

The contract provides the following functions and features:

- `setBridgeContract(address _bridgeContract) external onlyOwner`: Sets the address of the bridge contract. Make sure to replace the `bridgeContract` address with a valid one.
- `mint(address to, uint256 amount) external`: Mints tokens to the specified address. Only the bridge contract can call this function.
- `burn(address from, uint256 amount) external`: Burns tokens from the specified address. Only the bridge contract can call this function.
- `pause() external onlyOwner`: Pauses contract operations. Only the contract owner can call this function.
- `unpause() external onlyOwner`: Unpauses contract operations. Only the contract owner can call this function.

Additionally, the contract overrides the `_beforeTokenTransfer` function from the ERC20 contract to include pausing functionality.

## Contact

If you find a bug or security issue in this code, please contact info@lotuscapitalhub.com.
