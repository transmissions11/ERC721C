// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {ERC721} from "solmate/tokens/ERC721.sol";

import {CAPTCHA} from "./CAPTCHA.sol";

abstract contract ERC721C is ERC721 {
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

    modifier mustPassCAPTCHA() {
        require(captcha.hasPassedCAPTCHA(msg.sender), "MUST_PASS_CAPTCHA");

        _;
    }

    /*//////////////////////////////////////////////////////////////
                              ERC721 LOGIC
    //////////////////////////////////////////////////////////////*/

    function approve(address spender, uint256 id) public virtual override mustPassCAPTCHA {
        super.approve(spender, id);
    }

    function setApprovalForAll(address operator, bool approved) public virtual override mustPassCAPTCHA {
        super.setApprovalForAll(operator, approved);
    }

    function transferFrom(address from, address to, uint256 id) public virtual override mustPassCAPTCHA {
        super.transferFrom(from, to, id);
    }
}
