// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {FiatShamir} from "../src/FiatShamir.sol";
import {Trove} from "../src/Trove.sol";

contract TroveTest is Test {
    Trove trove;

    function setUp() public {
        trove = new Trove(
                212502977571083929229027362384765066261,
                11,
                177699271446882986321388811092882140915
            );
    }

    function test_trove() public {
        vm.deal(address(trove), 1 ether);
        console2.log(address(this));
        trove.open(
            162408314345945760450140602033433427246,
            200886111328366686154387210639188155967
        );
    }

    receive() external payable {
        assertEq(msg.value, 1 ether);
    }
}
