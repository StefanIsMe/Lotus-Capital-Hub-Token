// SPDX-License-Identifier: MIT pragma solidity ^0.8.0;
/// @title PolygonWrapperToken 
/// @notice This contract is a wrapper token for BNB on Polygon zkEVM 
/// @dev This contract inherits from ERC20, ReentrancyGuard, Ownable and Pausable 
/// @dev If you find a bug or security issue in this code, please contact info@lotuscapitalhub.com

import “@openzeppelin/contracts/token/ERC20/ERC20.sol”; import “@openzeppelin/contracts/security/ReentrancyGuard.sol”; import “@openzeppelin/contracts/access/Ownable.sol”; import “@openzeppelin/contracts/security/Pausable.sol”;

contract PolygonWrapperToken is ERC20, ReentrancyGuard, Ownable, Pausable { uint256 public gasLimit; address public immutable bnbTokenAddress;

event Deposit(address indexed depositor, uint256 amount);
event Withdrawal(address indexed recipient, uint256 amount);
event BridgeContractChanged(address indexed newBridgeContractAddress); 
event GasLimitChanged(uint256 indexed newGasLimit); 
event Paused(address account); 
event Unpaused(address account); 

address public bridgeContractAddress;

constructor(
    string memory _name,
    string memory _symbol,
    address _bnbTokenAddress,
    uint256 _initialSupply
) ERC20(_name, _symbol) {
    require(_bnbTokenAddress != address(0), "Invalid BNB token address");
    bnbTokenAddress = _bnbTokenAddress;
    _mint(owner(), _initialSupply); // Mint all tokens to the owner
    gasLimit = 100000; // Set an initial gas limit (adjust as needed)
}

function depositTokens(uint256 amount) external nonReentrant whenNotPaused {
    require(amount > 0, "Amount must be greater than 0");
    IERC20 bnbToken = IERC20(bnbTokenAddress);
    require(bnbToken.transferFrom(msg.sender, address(this), amount), "Token transfer failed");
    _mint(msg.sender, amount);
    emit Deposit(msg.sender, amount);
}

function withdrawTokens(uint256 amount) external nonReentrant whenNotPaused {
    require(amount > 0, "Amount must be greater than 0");
    _burn(msg.sender, amount);
    IERC20 bnbToken = IERC20(bnbTokenAddress);
    require(bnbToken.transfer(msg.sender, amount), "Token transfer failed");
    emit Withdrawal(msg.sender, amount);
}

modifier onlyBridge() {
    require(msg.sender == bridgeContractAddress, "Caller is not the bridge contract");
    _;
}

function setBridgeContract(address _bridgeContractAddress) external onlyOwner {
    require(_bridgeContractAddress != address(0), "Invalid bridge contract address");
    bridgeContractAddress = _bridgeContractAddress;
    emit BridgeContractChanged(_bridgeContractAddress); 
}

function setGasLimit(uint256 _gasLimit) external onlyOwner {
    gasLimit = _gasLimit;
    emit GasLimitChanged(_gasLimit); 
}

 function transferWithReducedGas(
     address to,
     uint256 amount,
     bytes calldata data,
     uint256 _gasLimit
 ) public nonReentrant returns (bool) {
     require(gasleft() >= _gasLimit.add(21000), "Insufficient gas limit");
     
      // Transfer the tokens internally
      super._transfer(msg.sender, to, amount);

      // Estimate the gas cost of the internal transfer
      uint256 gasCost = gasleft();

      // Check if the gas cost exceeds the gas limit
      require(gasCost <= _gasLimit.sub(21000), "Gas cost exceeds the gas limit");

      // Calculate the gas limit for the external call
      uint256 externalCallGasLimit = _gasLimit.sub(gasCost).sub(21000);

      // Check if there is enough gas left for the external call
      require(gasleft() >= externalCallGasLimit, "Insufficient gas limit for external call");

      // Make the external call
      (bool success, ) = to.call{gas: externalCallGasLimit}(data);

      return success;
 }

 // Add a function to mint tokens on zkEVM when tokens are transferred from BNB Chain
 function mint(address to, uint256 amount) external onlyBridge whenNotPaused {
     require(to != address(0), "Invalid address");
     require(amount > 0, "Amount must be greater than 0");
     
     // Mint the tokens to the recipient
     _mint(to, amount);
 }

 // Add a function to burn tokens on zkEVM when tokens are transferred to BNB Chain
 function burn(address from, uint256 amount) external onlyBridge nonReentrant whenNotPaused {
     require(from != address(0), "Invalid address");
     require(amount > 0, "Amount must be greater than 0");
     
     // Burn the tokens from the sender
     _burn(from, amount);
 }

 // Add a function to handle receiving tokens from a bridge address on Polygon zkEVM
 function receiveFromBridge(address from, uint256 amount) external onlyBridge whenNotPaused {
     require(from != address(0), "Invalid address");
     require(amount > 0, "Amount must be greater than 0");

     // Transfer the tokens from the bridge contract to the recipient
     _transfer(bridgeContractAddress, from, amount);
 }

 // Add functions to pause and unpause the contract by the owner

 function pause() external onlyOwner {
   _pause();
   emit Paused(msg.sender); 
 }

 function unpause() external onlyOwner {
   _unpause();
   emit Unpaused(msg.sender); 
 }
Copy
}
