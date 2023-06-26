// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenChild is ERC20, ERC20Burnable, Pausable, Ownable {

    address bridge;

    constructor (address _bridge) ERC20("Lotus Capital", "LC") {
        bridge = _bridge;
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
        emit Paused(msg.sender);
    }

    function unpause() public onlyOwner {
        _unpause();
        emit Unpaused(msg.sender);
    }

    modifier onlyBridge() {
        require(msg.sender == bridge, "Only the bridge contract can call this function");
        _;
    }

    event Mint(address indexed recipient, uint256 amount);
    event Burn(address indexed account, uint256 amount);
    event Paused(address account);
    event Unpaused(address account);
}
