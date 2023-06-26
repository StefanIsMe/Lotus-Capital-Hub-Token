// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LCBNBBridge {
    address private mainToken;
    address private gateway;

    event TokensLocked(address indexed requester, bytes32 indexed mainDepositHash, uint amount, uint timestamp);
    event TokensUnlocked(address indexed requester, bytes32 indexed sideDepositHash, uint amount, uint timestamp);
    event GatewayChanged(address indexed previousGateway, address indexed newGateway);

    constructor() {
        mainToken = 0xf423c8fafD0Aa3ee911AfBC44f4D8eA713f7C9Dd;
        gateway = msg.sender;
    }

    function lockTokens(address _requester, uint _bridgedAmount, bytes32 _mainDepositHash) external onlyGateway {
        (bool success, bytes memory data) = mainToken.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", _requester, address(this), _bridgedAmount));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Token transfer failed");
        emit TokensLocked(_requester, _mainDepositHash, _bridgedAmount, block.timestamp);
    }

    function unlockTokens(address _requester, uint _bridgedAmount, bytes32 _sideDepositHash) external onlyGateway {
        (bool success, bytes memory data) = mainToken.call(abi.encodeWithSignature("transfer(address,uint256)", _requester, _bridgedAmount));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Token transfer failed");
        emit TokensUnlocked(_requester, _sideDepositHash, _bridgedAmount, block.timestamp);
    }

    function changeGateway(address newGateway) external {
        require(newGateway != address(0), "Invalid gateway address");
        emit GatewayChanged(gateway, newGateway);
        gateway = newGateway;
    }

    modifier onlyGateway {
        require(msg.sender == gateway, "Only the gateway can execute this function");
        _;
    }
}
