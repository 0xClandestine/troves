// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract FiatShamir {
    /// -----------------------------------------------------------------------
    /// Immutables
    /// -----------------------------------------------------------------------

    uint256 public immutable PRIME = 212502977571083929229027362384765066261;

    uint256 public immutable GENERATOR = 11;

    constructor(uint256 n, uint256 g) {
        PRIME = n;
        GENERATOR = g;
    }

    /// -----------------------------------------------------------------------
    /// Public
    /// -----------------------------------------------------------------------

    function validate(uint256 y, uint256 t, uint256 c, uint256 r)
        public
        view
        returns (bool)
    {
        return t == (modExp(GENERATOR, r, PRIME) * modExp(y, c, PRIME)) % PRIME;
    }

    /// -----------------------------------------------------------------------
    /// Private
    /// -----------------------------------------------------------------------

    function modExp(uint256 b, uint256 e, uint256 m)
        internal
        view
        returns (uint256 result)
    {
        assembly {
            let pointer := mload(0x40)

            mstore(pointer, 0x20)
            mstore(add(pointer, 0x20), 0x20)
            mstore(add(pointer, 0x40), 0x20)

            mstore(add(pointer, 0x60), b)
            mstore(add(pointer, 0x80), e)
            mstore(add(pointer, 0xa0), m)

            let value := mload(0xc0)

            if iszero(staticcall(not(0), 0x05, pointer, 0xc0, value, 0x20)) {
                revert(0, 0)
            }

            result := mload(value)
        }
    }
}
