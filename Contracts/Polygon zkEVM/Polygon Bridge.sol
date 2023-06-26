// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IERC20Child } from "./IERC20Child.sol";

contract SideBridge {
    address private owner;
    address private gateway;
    IERC20Child private sideToken;
    bool private bridgeInitState;

    event BridgeInitialized(uint256 timestamp);
    event TokensBridged(address indexed requester, bytes32 indexed mainDepositHash, uint256 amount, uint256 timestamp);
    event TokensReturned(address indexed requester, bytes32 indexed sideDepositHash, uint256 amount, uint256 timestamp);
    event GatewayAddressChanged(address indexed oldAddress, address indexed newAddress);

    modifier verifyInitialization() {
        require(bridgeInitState, "Bridge has not been initialized");
        _;
    }

    modifier onlyGateway() {
        require(msg.sender == gateway, "Only gateway can execute this function");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function initializeBridge(address _childTokenAddress) external onlyOwner {
        sideToken = IERC20Child(_childTokenAddress);
        bridgeInitState = true;
        emit BridgeInitialized(block.timestamp);
    }

    function setGatewayAddress(address _newGateway) external onlyOwner {
        require(_newGateway != address(0), "Gateway address cannot be zero");
        address oldGateway = gateway;
        gateway = _newGateway;
        emit GatewayAddressChanged(oldGateway, _newGateway);
    }

    function bridgeTokens(address _requester, uint256 _bridgedAmount, bytes32 _mainDepositHash) external verifyInitialization onlyGateway {
        sideToken.mint(_requester, _bridgedAmount);
        emit TokensBridged(_requester, _mainDepositHash, _bridgedAmount, block.timestamp);
    }

    function returnTokens(address _requester, uint256 _bridgedAmount, bytes32 _sideDepositHash) external verifyInitialization onlyGateway {
        sideToken.burn(_bridgedAmount);
        emit TokensReturned(_requester, _sideDepositHash, _bridgedAmount, block.timestamp);
    }

    function getGatewayAddress() external view returns (address) {
        return gateway;
    }

    function getOwnerAddress() external view returns (address) {
        return owner;
    }
}