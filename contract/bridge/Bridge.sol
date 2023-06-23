pragma solidity ^0.8.19;

// Your basic ERC20 token interface
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
}

contract PolygonBridge {
    address public admin;
    IERC20 public token;
    uint256 public nonce;
    mapping(uint256 => bool) public processedNonces;

    event Deposit(
        address indexed sender,
        address indexed _to,
        uint256 _amount,
        uint256 _date
    );

    event Withdraw(
        bytes indexed _senderSignature,
        bytes indexed _receiverSignature,
        uint256 indexed _amount,
        address _to,
        address _receiver,
        uint256 _nonce,
        uint256 _date
    );

    constructor(address _token) {
        admin = msg.sender;
        token = IERC20(_token);
    }

    function deposit(address _to, uint256 _amount) external {
        token.transferFrom(msg.sender, address(this), _amount);
        nonce++;
        emit Deposit(msg.sender, _to, _amount, nonce);
    }

    function withdraw(
        bytes memory _senderSignature,
        bytes memory _receiverSignature,
        uint256 _amount,
        address _to,
        address _receiver,
        uint256 _nonce
    ) public {
        require(!processedNonces[_nonce], "Hey! This nonce is no good; it's already processed.");
        processedNonces[_nonce] = true;

        // Recover sender and receiver's addresses from signatures
        bytes32 message = prefixed(keccak256(abi.encodePacked(_to, _receiver, _amount, _nonce)));
        address sender = recoverSigner(message, _senderSignature);
        address receiver = recoverSigner(message, _receiverSignature);
        require(sender != receiver, "Yo! One must not send tokens to themselves. Ain't that funny? 😜");

        token.transfer(_to, _amount);
        emit Withdraw(_senderSignature, _receiverSignature, _amount, _to, _receiver, _nonce, block.timestamp);
    }

    function recoverSigner(bytes32 _message, bytes memory _sig) public pure returns (address) {
        uint8 v;
        bytes32 r;
        bytes32 s;

        // Do the splitaroo! 🎉
        (v, r, s) = splitSignature(_sig);

        return ecrecover(_message, v, r, s);
    }
    
    // This is our magic prefix y'all! 🎩✨
    function prefixed(bytes32 _hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash));
    }

    function splitSignature(bytes memory _sig)
        public
        pure
        returns (
            uint8,
            bytes32,
            bytes32
        )
    {
        require(_sig.length == 65, "What're you doin'? This ain't a valid signature length!");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            // Load stuff into the magic memory! 🧙‍♂️✨
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }

        return (v, r, s);
    }

    function updateNonce(uint256 _nonce) public {
        require(msg.sender == admin, "Yo, you ain't the boss! Admin access only.😎");
        nonce = _nonce;
    }
}
