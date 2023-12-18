// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "solady/src/utils/SafeTransferLib.sol";
import "src/FiatShamirLib.sol";

/**
 * @title Trove Contract
 * @notice This contract represents a Trove and provides functionality to open it using Fiat-Shamir zero-knowledge proofs.
 */
contract Trove {
    /// -----------------------------------------------------------------------
    /// Errors
    /// -----------------------------------------------------------------------

    error InvalidProof();

    /// -----------------------------------------------------------------------
    /// Immutables
    /// -----------------------------------------------------------------------

    /**
     * @notice The prime number used in the Trove contract.
     */
    uint256 public immutable prime;

    /**
     * @notice The generator used in the Trove contract.
     */
    uint256 public immutable generator;

    /**
     * @notice The public key used in the Trove contract.
     */
    uint256 public immutable pubKey;

    /**
     * @notice Initializes the Trove contract with the specified parameters.
     * @param n The prime number.
     * @param g The generator.
     * @param y The public key.
     */
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
