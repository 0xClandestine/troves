// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import {Test, console2} from "forge-std/Test.sol";
import {FiatShamirLib} from "src/FiatShamirLib.sol";
import {Trove} from "src/Trove.sol";

contract TroveTest is Test {
    Trove trove;

    function setUp() public {
        trove = new Trove({
            n: 212502977571083929229027362384765066261,
            g: 11,
            y: 177699271446882986321388811092882140915
        });
    }

    function test_trove() public {
        vm.deal(address(trove), 1 ether);
        console2.log(address(this));
        trove.open({
            t: 162408314345945760450140602033433427246,
            r: 200886111328366686154387210639188155967
        });
    }

    receive() external payable {
        assertEq(msg.value, 1 ether);
    }
}
