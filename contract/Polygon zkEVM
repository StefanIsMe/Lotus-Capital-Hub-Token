// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PolygonWrapperToken is ERC20 {
    using SafeMath for uint256;

    // Address of the BNB token on BNB Chain Testnet
    address public bnbTokenAddress;

    // Mapping to store the deposited token amounts
    mapping(address => uint256) public depositedTokens;

    // Events
    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);

    address public bridgeContractAddress;
    address public owner;

    constructor(
        string memory _name,
        string memory _symbol,
        address _bnbTokenAddress
    ) ERC20(_name, _symbol) {
        require(_bnbTokenAddress != address(0), "Invalid BNB token address");
        bnbTokenAddress = _bnbTokenAddress;
        owner = 0x5D6aad0dA0a387Eb7B8E3Cb8fA84Fc9D2059D8bA;
    }

    // Function to deposit tokens from BNB Chain Testnet
    function depositTokens(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");

        // Transfer tokens from the user to this contract
        IERC20 bnbToken = IERC20(bnbTokenAddress);
        require(bnbToken.transferFrom(msg.sender, address(this), amount), "Token transfer failed");

        // Mint wrapped tokens
        _mint(msg.sender, amount);

        // Update deposited token amount for the user
        depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amount);

        emit Deposit(msg.sender, amount);
    }

    // Function to withdraw tokens to BNB Chain Testnet
    function withdrawTokens(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(depositedTokens[msg.sender] >= amount, "Insufficient deposited tokens");

        // Burn wrapped tokens from the user's balance
        _burn(msg.sender, amount);

        // Update deposited token amount for the user
        depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amount);

        // Transfer tokens from this contract to the user on BNB Chain Testnet
        IERC20 bnbToken = IERC20(bnbTokenAddress);
        require(bnbToken.transfer(msg.sender, amount), "Token transfer failed");

        emit Withdrawal(msg.sender, amount);
    }

    // Modifier to allow only the bridge contract to call a function
    modifier onlyBridge() {
        require(msg.sender == bridgeContractAddress, "Caller is not the bridge contract");
        _;
    }

    // Modifier to check if the caller is the owner of the contract
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // Function to set the bridge contract address
    function setBridgeContract(address _bridgeContractAddress) external onlyOwner {
        require(_bridgeContractAddress != address(0), "Invalid bridge contract address");
        bridgeContractAddress = _bridgeContractAddress;
    }

    // Function to set the BNB token address
    function setBNBTokenAddress(address _bnbTokenAddress) external onlyOwner {
        require(_bnbTokenAddress != address(0), "Invalid BNB token address");
        bnbTokenAddress = _bnbTokenAddress;
    }

    // Function to transfer ownership of the contract
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");
        owner = newOwner;
    }

    // Function to renounce ownership of the contract
    function renounceOwnership() external onlyOwner {
        owner = address(0);
    }

    // Function to estimate gas cost for a transfer
    function estimateGasCost(address to, uint256 amount) public view returns (uint256) {
        uint256 gasCost = gasleft();
        _transfer(msg.sender, to, amount);
        gasCost = gasCost - gasleft();
        return gasCost;
    }

    // Function to transfer tokens with reduced gas cost using EIP-2930
    function transferWithReducedGas(address to, uint256 amount, bytes calldata data, uint256 gasLimit) external returns (bool) {
        require(gasleft() >= gasLimit.add(21000), "Insufficient gas limit");
        uint256 gasCost = estimateGasCost(to, amount);
        require(gasCost <= gasLimit.sub(21000), "Gas cost exceeds the gas limit");

        _transfer(msg.sender, to, amount);

        // Calculate the remaining gas after the token transfer
        uint256 gasLeftAfterTransfer = gasleft();

        // Calculate the gas limit for the external call
        uint256 externalCallGasLimit = gasLimit.sub(gasCost).sub(21000);

        // Ensure that the gas limit for the external call is sufficient
        require(gasLeftAfterTransfer >= externalCallGasLimit, "Insufficient gas limit for external call");

        // Make the external call with the remaining gas
        (bool success, ) = to.call{gas: externalCallGasLimit}(data);
        return success;
    }
}
