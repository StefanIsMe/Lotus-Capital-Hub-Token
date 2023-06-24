# MyWrappedToken

MyWrappedToken is a smart contract that serves as a wrapper token for BNB on Polygon zkEVM. It inherits from ERC20, Ownable, and Pausable contracts.

## Imports

The contract imports the following libraries and contracts:

- `ERC20` from `@openzeppelin/contracts/token/ERC20/ERC20.sol`: Provides a basic implementation of the ERC20 token standard.
- `Ownable` from `@openzeppelin/contracts/access/Ownable.sol`: Provides basic access control functionality, allowing contract ownership.
- `Pausable` from `@openzeppelin/contracts/security/Pausable.sol`: Provides functionality to pause and unpause contract operations.

## Usage

The contract provides the following functions and features:

- `setBridgeContract(address _bridgeContract) external onlyOwner`: Sets the address of the bridge contract.
- `mint(address to, uint256 amount) external`: Mints tokens to the specified address. Only the bridge contract can call this function.
- `burn(address from, uint256 amount) external`: Burns tokens from the specified address. Only the bridge contract can call this function.
- `pause() external onlyOwner`: Pauses contract operations. Only the contract owner can call this function.
- `unpause() external onlyOwner`: Unpauses contract operations. Only the contract owner can call this function.

Additionally, the contract overrides the `_beforeTokenTransfer` function from the ERC20 contract to include pausing functionality.
