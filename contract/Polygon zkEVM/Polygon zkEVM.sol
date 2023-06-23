// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Wrapper.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract PolygonWrapperToken is ERC20Wrapper, ReentrancyGuard, Ownable, Pausable {

    uint256 public gasLimit;

    event TokenReclaimApproved(address indexed reclaimAddress, uint256 amount);
    event TokenReclaimCompleted(address indexed reclaimAddress, uint256 amount);

    address public bridgeContractAddress;

    mapping(address => uint256) public tokenReclaimApprovals;

    constructor(address _originalTokenAddress) ERC20Wrapper(IERC20(_originalTokenAddress)) {
        gasLimit = 100000; // Set an initial gas limit (adjust as needed)
    }

    modifier onlyBridge() {
        require(msg.sender == bridgeContractAddress, "Caller is not the bridge contract");
        _;
    }

    function setBridgeContract(address _bridgeContractAddress) external onlyOwner {
        require(_bridgeContractAddress != address(0), "Invalid bridge contract address");
        bridgeContractAddress = _bridgeContractAddress;
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
        require(balanceOf(from) >= amount, "Insufficient balance");

        // Update the balance for 'from'
        _burn(from, amount);

        // Transfer the tokens to the owner
        _transfer(from, owner(), amount);

        emit TokenReclaimCompleted(from, amount);
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

    // Reject any ether transfers
    fallback() external payable {
        revert("This contract does not accept ether");
    }
}
