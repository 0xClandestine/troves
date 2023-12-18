// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./FiatShamir.sol";

contract Trove is FiatShamir {
    error InvalidProof();

    uint256 public immutable pubKey;

    constructor(uint256 n, uint256 g, uint256 y) FiatShamir(n, g) {
        pubKey = y;
    }

    function open(uint256 t, uint256 r) external virtual {
        if (!validate(pubKey, t, uint256(uint160(bytes20(msg.sender))), r)) {
            revert InvalidProof();
        }

        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
