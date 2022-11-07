// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {ERC721} from "solmate/tokens/ERC721.sol";

import {CAPTCHA} from "./CAPTCHA.sol";

/// @title ERC721C
/// @author transmissions11 <t11s@paradigm.xyz>
/// @notice ERC721 that blocks non whitelisted contract interactions.
abstract contract ERC721C is ERC721 {
    /*//////////////////////////////////////////////////////////////
                             CAPTCHA STORAGE
    //////////////////////////////////////////////////////////////*/

    CAPTCHA internal immutable captcha;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(string memory _name, string memory _symbol, CAPTCHA _captcha) ERC721(_name, _symbol) {
        captcha = _captcha;
    }

    /*//////////////////////////////////////////////////////////////
                             WHITELIST LOGIC
    //////////////////////////////////////////////////////////////*/

    function isWhitelisted(address) internal virtual returns (bool);

    /*//////////////////////////////////////////////////////////////
                              CAPTCHA LOGIC
    //////////////////////////////////////////////////////////////*/

    modifier mustPassCAPTCHA(address user) {
        require(captcha.hasPassedCAPTCHA(user) || isWhitelisted(user), "MUST_PASS_CAPTCHA");

        _;
    }

    /*//////////////////////////////////////////////////////////////
                              ERC721 LOGIC
    //////////////////////////////////////////////////////////////*/

    function transferFrom(address from, address to, uint256 id)
        public
        virtual
        override
        mustPassCAPTCHA(msg.sender)
        mustPassCAPTCHA(to)
    {
        super.transferFrom(from, to, id);
    }

    /*//////////////////////////////////////////////////////////////
                          INTERNAL ERC721 LOGIC
    //////////////////////////////////////////////////////////////*/

    function _mint(address to, uint256 id) internal virtual override mustPassCAPTCHA(to) {
        super._mint(to, id);
    }
}
