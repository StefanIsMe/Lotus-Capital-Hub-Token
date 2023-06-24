// SPDX-License-Identifier: MIT
/// @title PolygonWrapperToken 
/// @notice This contract is a wrapper token for BNB on Polygon zkEVM 
/// @dev This contract inherits from ERC20, ReentrancyGuard, Ownable, and Pausable 
/// @dev If you find a bug or security issue in this code, please contact info@lotuscapitalhub.com

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract MyWrappedToken is ERC20, Ownable, Pausable {
    address public bnbToken;
    address public bridgeContract;

    event BridgeContractSet(address indexed bridgeContract);
    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);

    constructor(address _bnbToken) ERC20("Lotus Capital", "LC") {
        bnbToken = _bnbToken;
    }

    function setBridgeContract(address _bridgeContract) external onlyOwner {
        require(_bridgeContract != address(0), "Invalid bridge contract address");
        bridgeContract = _bridgeContract;
        emit BridgeContractSet(_bridgeContract);
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == bridgeContract, "Caller is not the bridge contract");
        require(to != address(0), "Invalid address");
        require(amount > 0, "Amount must be greater than 0");
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    function burn(address from, uint256 amount) external {
        require(msg.sender == bridgeContract, "Caller is not the bridge contract");
        require(from != address(0), "Invalid address");
        require(amount > 0, "Amount must be greater than 0");
        _burn(from, amount);
        emit TokensBurned(from, amount);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal whenNotPaused override {
        super._beforeTokenTransfer(from, to, amount);
    }
}
