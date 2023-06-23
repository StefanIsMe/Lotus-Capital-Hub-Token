// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract LotusCapitalPolygon is IERC20, ReentrancyGuard, Ownable, Pausable {
    using SafeMath for uint256;

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    uint256 public gasLimit;
    address public bnbTokenAddress;
    mapping(address => uint256) public depositedTokens;
    mapping(address => mapping(address => uint256)) public allowances;

    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);
    event TokenReclaimApproved(address indexed reclaimAddress, uint256 amount);
    event TokenReclaimCompleted(address indexed reclaimAddress, uint256 amount);

    address public bridgeContractAddress;

    mapping(address => uint256) public tokenReclaimApprovals;

    constructor(
        string memory _name,
        string memory _symbol,
        address _bnbTokenAddress,
        uint256 _initialSupply
    ) {
        require(_bnbTokenAddress != address(0), "Invalid BNB token address");
        bnbTokenAddress = _bnbTokenAddress;
        name = "Lotus Capital";
        symbol = LC;
        decimals = 18;
        totalSupply = 1000000;
        depositedTokens[owner()] = totalSupply; // Mint all tokens to the owner
        gasLimit = 100000; // Set an initial gas limit (adjust as needed)
    }

    function depositTokens(uint256 amount) external nonReentrant whenNotPaused {
        require(amount > 0, "Amount must be greater than 0");
        IERC20 bnbToken = IERC20(bnbTokenAddress);
        require(bnbToken.transferFrom(msg.sender, address(this), amount), "Token transfer failed");
        depositedTokens[msg.sender] = depositedTokens[msg.sender].add(amount);
        emit Deposit(msg.sender, amount);
    }

    function withdrawTokens(uint256 amount) external nonReentrant whenNotPaused {
        require(amount > 0, "Amount must be greater than 0");
        require(depositedTokens[msg.sender] >= amount, "Insufficient deposited tokens");
        depositedTokens[msg.sender] = depositedTokens[msg.sender].sub(amount);
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
    }

    function setBNBTokenAddress(address _bnbTokenAddress) external onlyOwner {
        require(_bnbTokenAddress != address(0), "Invalid BNB token address");
        bnbTokenAddress = _bnbTokenAddress;
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

    function reclaimTokens(address from, uint256 amount) external onlyOwner nonReentrant {
        require(from != address(0), "Invalid address");
        require(amount > 0, "Amount must be greater than 0");
        require(depositedTokens[from] >= amount, "Insufficient deposited tokens");

        // Update the deposited token amount for 'from'
        depositedTokens[from] = depositedTokens[from].sub(amount);

        // Transfer the tokens to the owner
        _transfer(from, owner(), amount);

        emit TokenReclaimCompleted(from, amount);
    }

    function transfer(address to, uint256 amount) public override notContract whenNotPaused returns (bool) {
        // Call transferWithReducedGas internally
        return transferWithReducedGas(to, amount, "", gasLimit);
    }

    function transferWithReducedGas(
        address to,
        uint256 amount,
        bytes calldata data,
        uint256 _gasLimit
    ) public nonReentrant whenNotPaused returns (bool) {
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

    function estimateGasCost(address to, uint256 amount) public view returns (uint256) {
        uint256 gasCost = gasleft();
        _transfer(msg.sender, to, amount);
        gasCost = gasCost - gasleft();
        return gasCost;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return depositedTokens[account];
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        allowances[msg.sender][spender] = allowances[msg.sender][spender].add(addedValue);
        emit Approval(msg.sender, spender, allowances[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        allowances[msg.sender][spender] = allowances[msg.sender][spender].sub(subtractedValue);
        emit Approval(msg.sender, spender, allowances[msg.sender][spender]);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public override notContract whenNotPaused returns (bool) {
        // Call transferWithReducedGas internally
        return transferWithReducedGas(to, amount, "", gasLimit);
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "Invalid from address");
        require(to != address(0), "Invalid to address");
        require(amount > 0, "Amount must be greater than 0");
        
        depositedTokens[from] = depositedTokens[from].sub(amount);
        depositedTokens[to] = depositedTokens[to].add(amount);

        emit Transfer(from, to, amount);
    }

    // Reject any ether transfers
    fallback() external payable {
        revert("This contract does not accept ether");
    }
}
