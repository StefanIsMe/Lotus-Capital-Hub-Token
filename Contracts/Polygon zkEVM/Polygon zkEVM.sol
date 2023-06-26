// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LotusCapitalTestToken is ERC20, ERC20Burnable, Pausable, Ownable {

    address private bridge;

    constructor() ERC20("Lotus Capital", "LC") {
        bridge = msg.sender; // Set the bridge address to the contract deployer
    }

    function setBridge(address _bridge) external onlyOwner {
        require(_bridge != address(0), "Bridge address cannot be zero");
        bridge = _bridge;
        emit BridgeChanged(_bridge);
    }

    function mint(address recipient, uint256 amount) public virtual onlyBridge whenNotPaused {
        _mint(recipient, amount);
        emit Mint(recipient, amount);
    }

    function burn(uint256 amount) public override(ERC20Burnable) virtual onlyBridge whenNotPaused {
        super.burn(amount);
        emit Burn(msg.sender, amount);
    }

    function burnFrom(address account, uint256 amount) public override(ERC20Burnable) virtual onlyBridge whenNotPaused {
        super.burnFrom(account, amount);
        emit Burn(account, amount);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    modifier onlyBridge() {
        require(msg.sender == bridge, "Only the bridge contract can call this function");
        _;
    }

    event Mint(address indexed recipient, uint256 amount);
    event Burn(address indexed account, uint256 amount);
    event BridgeChanged(address newBridge);
}
