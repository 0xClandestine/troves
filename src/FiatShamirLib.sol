// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

/**
 * @title Fiat-Shamir Library
 * @notice Library for implementing the Fiat-Shamir zero-knowledge proof system.
 */
library FiatShamirLib {
    /**
     * @notice Validates a Fiat-Shamir zero-knowledge proof.
     * @param n The prime number used in the proof.
     * @param g The generator for the group in which the proof is conducted.
     * @param y The public key used in the proof.
     * @param t The first proof element.
     * @param c The challenge used in the proof.
     * @param r The second proof element.
     * @return result
     */
    function isValidProof(
        uint256 n,
        uint256 g,
        uint256 y,
        uint256 t,
        uint256 c,
        uint256 r
    ) internal view returns (bool) {
        return t == (modExp(g, r, n) * modExp(y, c, n)) % n;
    }

    /**
     * @notice Performs modular exponentiation.
     * @param b The base.
     * @param e The exponent.
     * @param m The modulus.
     * @return result
     */
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
