// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "solady/src/utils/SafeTransferLib.sol";
import "src/FiatShamirLib.sol";

contract Trove {
    /// -----------------------------------------------------------------------
    /// Errors
    /// -----------------------------------------------------------------------

    error InvalidProof();

    /// -----------------------------------------------------------------------
    /// Immutables
    /// -----------------------------------------------------------------------

    uint256 public immutable prime;

    uint256 public immutable generator;

    /// @notice
    uint256 public immutable pubKey;

    constructor(uint256 n, uint256 g, uint256 y) {
        prime = n;
        generator = g;
        pubKey = y;
    }

    /// -----------------------------------------------------------------------
    /// Actions
    /// -----------------------------------------------------------------------

    /**
     * @notice Opens the Trove using the provided proof elements.
     * @param t The first proof element.
     * @param r The second proof element.
     *
     * @dev Phase 0: Peggy creates public key 'y' = g**x % n.
     *      Phase 1: Peggy solves for 't' = g**v % n.
     *      Phase 2: Peggy solves for 'r' = (v - cx) % (n - 1), 'c' = msg.sender.
     */
    function open(uint256 t, uint256 r) external virtual {
        if (
            !FiatShamirLib.isValidProof(
                prime,
                generator,
                pubKey,
                t,
                uint256(uint160(bytes20(msg.sender))),
                r
            )
        ) {
            revert InvalidProof();
        }

        SafeTransferLib.safeTransferAllETH(msg.sender);
    }

    /**
     * @dev Fallback function to receive ETH.
     */
    receive() external payable {}
}
