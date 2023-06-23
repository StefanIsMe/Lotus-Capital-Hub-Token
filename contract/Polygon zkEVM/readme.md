# PolygonWrapperToken

PolygonWrapperToken is a smart contract that implements an ERC20 token that can be bridged between BNB Chain and Polygon zkEVM using a custom bridge contract. It also has some features to reduce gas costs and allow token reclaim by the owner.

## Installation

To install the dependencies, run:

```
npm install
```

To compile the contract, run:

```
npx hardhat compile
```

To deploy the contract, run:

```
npx hardhat run scripts/deploy.js --network <network>
```

Replace `<network>` with the name of the network you want to deploy to, such as mainnet, testnet, or localhost.

## Usage

The contract has the following functions:

- `depositTokens(uint256 amount)`: Allows users to deposit BNB tokens and receive wrapped tokens on zkEVM.
- `withdrawTokens(uint256 amount)`: Allows users to withdraw wrapped tokens and receive BNB tokens on BNB Chain.
- `setBridgeContract(address _bridgeContractAddress)`: Allows the owner to set the address of the bridge contract.
- `setGasLimit(uint256 _gasLimit)`: Allows the owner to set the gas limit for external calls.
- `approveTokenReclaim(address reclaimAddress, uint256 amount)`: Allows the owner to approve a token reclaim request from a specific address and amount.
- `reclaimTokens(address from, uint256 amount)`: Allows the owner to reclaim tokens from a specific address and amount.
- `transfer(address to, uint256 amount)`: Allows users to transfer tokens to another address with reduced gas costs.
- `transferWithReducedGas(address to, uint256 amount, bytes calldata data, uint256 _gasLimit)`: Allows users to transfer tokens to another address with reduced gas costs and make an external call with a custom gas limit.
- `approve(address spender, uint256 amount, int256 delta)`: Allows users to approve another address to spend their tokens with an optional delta parameter to increase or decrease the allowance.
- `mint(address to, uint256 amount)`: Allows the bridge contract to mint tokens on zkEVM when tokens are transferred from BNB Chain.
- `burn(address from, uint256 amount)`: Allows the bridge contract to burn tokens on zkEVM when tokens are transferred to BNB Chain.
- `receiveFromBridge(address from, uint256 amount)`: Allows the bridge contract to transfer tokens from itself to another address on zkEVM.

## Testing

To run the unit tests, run:

```
npx hardhat test
```

## License

MIT
