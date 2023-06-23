# PolygonWrapperToken

PolygonWrapperToken is a smart contract that implements an ERC20 token that can be bridged between BNB Chain and Polygon zkEVM using a custom bridge contract. It also includes features to reduce gas costs and allow token reclaims by the owner.

## Usage

The contract provides the following functions and features:

### Deposit Tokens

```solidity
function depositTokens(uint256 amount) external nonReentrant whenNotPaused
```

Allows users to deposit BNB tokens and receive wrapped tokens on zkEVM.

- `amount`: The amount of BNB tokens to deposit.

Emits a `Deposit` event with the depositor's address and the deposited amount.

### Withdraw Tokens

```solidity
function withdrawTokens(uint256 amount) external nonReentrant whenNotPaused
```

Allows users to withdraw wrapped tokens and receive BNB tokens on BNB Chain.

- `amount`: The amount of wrapped tokens to withdraw.

Emits a `Withdrawal` event with the recipient's address and the withdrawn amount.

### Set Bridge Contract

```solidity
function setBridgeContract(address _bridgeContractAddress) external onlyOwner
```

Allows the owner to set the address of the bridge contract.

- `_bridgeContractAddress`: The address of the bridge contract.

### Set Gas Limit

```solidity
function setGasLimit(uint256 _gasLimit) external onlyOwner
```

Allows the owner to set the gas limit for external calls.

- `_gasLimit`: The gas limit for external calls.

### Approve Token Reclaim

```solidity
function approveTokenReclaim(address reclaimAddress, uint256 amount) external onlyOwner
```

Allows the owner to approve a token reclaim request from a specific address and amount.

- `reclaimAddress`: The address from which tokens can be reclaimed.
- `amount`: The amount of tokens approved for reclaim.

Emits a `TokenReclaimApproved` event with the approved reclaim address and amount.

### Reclaim Tokens

```solidity
function reclaimTokens(address from, uint256 amount) external onlyOwner nonReentrant
```

Allows the owner to reclaim tokens from a specific address and amount.

- `from`: The address from which tokens are reclaimed.
- `amount`: The amount of tokens to reclaim.

Updates the balance of the `from` address and transfers the tokens to the owner's address.

Emits a `TokenReclaimCompleted` event with the reclaimed address and amount.

### Transfer

```solidity
function transfer(address to, uint256 amount) public override returns (bool)
```

Allows users to transfer tokens to another address with reduced gas costs.

- `to`: The address to which the tokens are transferred.
- `amount`: The amount of tokens to transfer.

Calls the `transferWithReducedGas` function internally.

### Transfer With Reduced Gas

```solidity
function transferWithReducedGas(
    address to,
    uint256 amount,
    bytes calldata data,
    uint256 _gasLimit
) public nonReentrant returns (bool)
```

Allows users to transfer tokens to another address with reduced gas costs and make an external call with a custom gas limit.

- `to`: The address to which the tokens are transferred.
- `amount`: The amount of tokens to transfer.
- `data`: Additional data to include in the external call.
- `_gasLimit`: The gas limit for the transfer and the external call combined.

Checks if there is sufficient gas limit for the transfer and the external call, and then performs the transfer and external call.

### Approve

```solidity
function approve(address spender, uint256 amount, int256 delta) public override

 returns (bool)
```

Allows users to approve another address to spend their tokens with an optional delta parameter to increase or decrease the allowance.

- `spender`: The address allowed to spend the tokens.
- `amount`: The new allowance amount.
- `delta`: The delta value to increase or decrease the allowance (optional).

Sets the allowance to the given amount or increases/decreases the allowance by the delta value.

### Mint

```solidity
function mint(address to, uint256 amount) external onlyBridge whenNotPaused
```

Allows the bridge contract to mint tokens on zkEVM when tokens are transferred from BNB Chain.

- `to`: The address to which the tokens are minted.
- `amount`: The amount of tokens to mint.

Mints the specified amount of tokens to the recipient's address.

### Burn

```solidity
function burn(address from, uint256 amount) external onlyBridge nonReentrant whenNotPaused
```

Allows the bridge contract to burn tokens on zkEVM when tokens are transferred to BNB Chain.

- `from`: The address from which the tokens are burned.
- `amount`: The amount of tokens to burn.

Burns the specified amount of tokens from the sender's address.

### Receive From Bridge

```solidity
function receiveFromBridge(address from, uint256 amount) external onlyBridge whenNotPaused
```

Allows the bridge contract to transfer tokens from itself to another address on zkEVM.

- `from`: The address from which the tokens are transferred.
- `amount`: The amount of tokens to transfer.

Transfers the specified amount of tokens from the bridge contract to the recipient's address.

## License

This project is licensed under the MIT License.
