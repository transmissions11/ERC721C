// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {ERC721} from "solmate/tokens/ERC721.sol";

import {CAPTCHA} from "./CAPTCHA.sol";

abstract contract ERC721C is ERC721 {
    /*//////////////////////////////////////////////////////////////
                            WHITELIST STORAGE
    //////////////////////////////////////////////////////////////*/

    mapping(address => bool) public isWhitelisted;

    /*//////////////////////////////////////////////////////////////
                             CAPTCHA STORAGE
    //////////////////////////////////////////////////////////////*/

    CAPTCHA internal immutable captcha;

    constructor(string memory _name, string memory _symbol, CAPTCHA _captcha) ERC721(_name, _symbol) {
        captcha = _captcha;
    }

    /*//////////////////////////////////////////////////////////////
                              CAPTCHA LOGIC
    //////////////////////////////////////////////////////////////*/

    modifier mustPassCAPTCHA(address user) {
        require(captcha.hasPassedCAPTCHA(user) || isWhitelisted[user], "MUST_PASS_CAPTCHA");

        _;
    }

    /*//////////////////////////////////////////////////////////////
                              ERC721 LOGIC
    //////////////////////////////////////////////////////////////*/

    function approve(address spender, uint256 id) public virtual override mustPassCAPTCHA(msg.sender) {
        super.approve(spender, id);
    }

    function setApprovalForAll(address operator, bool approved) public virtual override mustPassCAPTCHA(msg.sender) {
        super.setApprovalForAll(operator, approved);
    }

    function transferFrom(address from, address to, uint256 id) public virtual override mustPassCAPTCHA(from) {
        super.transferFrom(from, to, id);
    }

    /*//////////////////////////////////////////////////////////////
                          INTERNAL ERC721 LOGIC
    //////////////////////////////////////////////////////////////*/

    function _mint(address to, uint256 id) internal virtual override mustPassCAPTCHA(to) {
        super._mint(to, id);
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL WHITELIST LOGIC
    //////////////////////////////////////////////////////////////*/

    function _whitelist(address user) internal virtual {
        isWhitelisted[user] = true;
    }

    function _blacklist(address user) internal virtual {
        isWhitelisted[user] = false;
    }
}
