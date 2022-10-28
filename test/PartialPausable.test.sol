// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "forge-std/Test.sol";
import {PartialPausableMock} from "../src/PausableMock.sol";

interface ITest {
    error Pausable__Paused();
    error Pausable__NotPaused();
    event Paused(address indexed account);
    event Unpaused(address indexed account);
}

contract PartialPausable is ITest, Test {
    PartialPausableMock private _instance;

    function setUp() external {
        _instance = new PartialPausableMock();
    }

    function testPause() external {
        // pause
        vm.expectEmit(true, true, true, true);
        emit Paused(address(this));
        _instance.pause();

        // after pause
        assertTrue(_instance.paused());

        // sstore
        bytes32 pauseStorage = vm.load(
            address(_instance),
            keccak256("solidstate.contracts.storage.Pausable")
        );
        assertEq(uint256(pauseStorage), 3);

        // revert when pause
        vm.expectRevert(Pausable__Paused.selector);
        _instance.pause();
    }

    function testUnpause() external {
        // revert when not pause
        vm.expectRevert(Pausable__NotPaused.selector);
        _instance.unpause();

        // before
        _instance.pause();

        // unpause
        vm.expectEmit(true, true, true, true);
        emit Unpaused(address(this));
        _instance.unpause();

        // after unpause
        assertFalse(_instance.paused());

        // sstore
        bytes32 pauseStorage = vm.load(
            address(_instance),
            keccak256("solidstate.contracts.storage.Pausable")
        );
        assertEq(uint256(pauseStorage), 0);
    }
}
