// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

/// @title CAPTCHA
/// @author transmissions11 <t11s@paradigm.xyz>
/// @notice Completely Automated Public Turing Test to Tell Contracts and Humans Apart.
contract CAPTCHA {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event Verified(address indexed user);

    /*//////////////////////////////////////////////////////////////
                          VERIFICATION STORAGE
    //////////////////////////////////////////////////////////////*/

    mapping(address => bool) public hasPassedCAPTCHA;

    /*//////////////////////////////////////////////////////////////
                             EIP-712 STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 internal immutable INITIAL_CHAIN_ID;

    bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() {
        INITIAL_CHAIN_ID = block.chainid;
        INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
    }

    /*//////////////////////////////////////////////////////////////
                           VERIFICATION LOGIC
    //////////////////////////////////////////////////////////////*/

    function verify(uint8 v, bytes32 r, bytes32 s) public virtual {
        address recoveredAddress = ecrecover(
            keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR(), keccak256(abi.encode(keccak256("CAPTCHA()"))))),
            v,
            r,
            s
        );

        require(recoveredAddress == msg.sender, "INVALID_SIGNER");

        hasPassedCAPTCHA[msg.sender] = true;

        emit Verified(msg.sender);
    }

    /*//////////////////////////////////////////////////////////////
                              EIP-712 LOGIC
    //////////////////////////////////////////////////////////////*/

    function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
        return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
    }

    function computeDomainSeparator() internal view virtual returns (bytes32) {
        return keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256("CAPTCHA"),
                keccak256("1"),
                block.chainid,
                address(this)
            )
        );
    }
}
