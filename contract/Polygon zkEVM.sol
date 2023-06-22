// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PolygonWrapperToken is ERC20 {
    using SafeMath for uint256;

    uint256 public gasLimit;
    address public bnbTokenAddress;
    mapping(address => uint256) public depositedTokens;

    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);
    event TokenReclaimApproved(address indexed reclaimAddress, uint256 amount);
    event TokenReclaimCompleted(address indexed reclaimAddress, uint256 amount);

    address public bridgeContractAddress;
    address public owner;

    mapping(address => uint256) public tokenReclaimApprovals;

    constructor(
        string memory _name,
        string memory _symbol,
        address _bnbTokenAddress
    ) ERC20(_name, _symbol) {
        require(_bnbTokenAddress != address(0), "Invalid BNB token address");
        bnbTokenAddress = _bnbTokenAddress;
        owner = 0x5D6aad0dA0a387Eb7B8E3Cb8fA84Fc9D2059D8bA;
        gasLimit = 100000; // Set an initial gas limit (adjust as needed)
    }

    function transferWithReducedGas(
        address to,
        uint256 amount,
        bytes calldata data,
        uint256 _gasLimit
    ) external returns (bool) {
        require(gasleft() >= _gasLimit.add(21000), "Insufficient gas limit");
        uint256 gasCost = estimateGasCost(to, amount);
        require(gasCost <= _gasLimit.sub(21000), "Gas cost exceeds the gas limit");
        _transfer(msg.sender, to, amount);
        uint256 gasLeftAfterTransfer = gasleft();
        uint256 externalCallGasLimit = _gasLimit.sub(gasCost).sub(21000);
        require(gasLeftAfterTransfer >= externalCallGasLimit, "Insufficient gas limit for external call");
        (bool success, ) = to.call{gas: externalCallGasLimit}(data);
        return success;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        // Call transferWithReducedGas internally
        return transferWithReducedGas(to, amount, "", gasLimit);
    }

    function depositTokens(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        IERC20 bnbToken = IERC20(bnbTokenAddress);
        require(bnbToken.transferFrom(msg.sender, address(this), amount), "Token transfer failed");
        _mint(msg.sender, amount);
        depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amount);
        emit Deposit(msg.sender, amount);
    }

    function withdrawTokens(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(depositedTokens[msg.sender] >= amount, "Insufficient deposited tokens");
        _burn(msg.sender, amount);
        depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amount);
        IERC20 bnbToken = IERC20(bnbTokenAddress);
        require(bnbToken.transfer(msg.sender, amount), "Token transfer failed");
        emit Withdrawal(msg.sender, amount);
    }

    modifier onlyBridge() {
        require(msg.sender == bridgeContractAddress, "Caller is not the bridge contract");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function setBridgeContract(address _bridgeContractAddress) external onlyOwner {
        require(_bridgeContractAddress != address(0), "Invalid bridge contract address");
        bridgeContractAddress = _bridgeContractAddress;
    }

    function setBNBTokenAddress(address _bnbTokenAddress) external onlyOwner {
        require(_bnbTokenAddress != address(0), "Invalid BNB token address");
        bnbTokenAddress = _bnbTokenAddress;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner address");
        owner = newOwner;
    }

    function renounceOwnership() external onlyOwner {
        owner = address(0);
    }

    function estimateGasCost(address to, uint256 amount) public view returns (uint256) {
        uint256 gasCost = gasleft();
        _transfer(msg.sender, to, amount);
        gasCost = gasCost - gasleft();
        return gasCost;
    }

    function setGasLimit(uint256 _gasLimit) external onlyOwner {
        gasLimit = _gasLimit;
    }

    function approveTokenReclaim(address reclaimAddress, uint256 amount) external onlyOwner {
        require(reclaimAddress != address(0), "Invalid reclaim address");
        require(amount > 0, "Amount must be greater than 0");
        tokenReclaimApprovals[reclaimAddress] = amount;
        emit TokenReclaimApproved(reclaimAddress, amount);
    }

    function reclaimTokens(address from, uint256 amount) external onlyOwner {
        require(from != address(0), "Invalid address");
        require(amount > 0, "Amount must be greater than 0");
        require(depositedTokens[from] >= amount, "Insufficient deposited tokens");

        // Update the deposited token amount for 'from'
        depositedTokens[from] = depositedTokens[from].sub(amount);

        // Burn the tokens from 'from' address
        _burn(from, amount);

        emit TokenReclaimCompleted(from, amount);
    }

}
