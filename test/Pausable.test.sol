// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "forge-std/Test.sol";

import "./FacetProxy.sol";

import "../example/FacetA.sol";
import "../example/FacetB.sol";
import "../example/FacetC.sol";
import "../example/FacetD.sol";

interface IFacet {
    function mask() external view returns (uint256);

    function trigger() external;

    function pause() external;

    function unpause() external;
}

interface ITest {
    // facet
    event Trigger();
    // pausable
    error Pausable__Paused();
    error Pausable__NotPaused();
    event Paused(address indexed account);
    event Unpaused(address indexed account);
}

contract TestPausable is ITest, Test {
    FacetProxy private _proxy;
    address private _p;
    address private _a;
    address private _b;
    address private _c;
    address private _d;

    function setUp() external {
        _a = address(new FacetA());
        _b = address(new FacetB());
        _c = address(new FacetC());
        _d = address(new FacetD());
        _proxy = new FacetProxy();
        _p = address(_proxy);
    }

    function testMask() external {
        _proxy.setImpl(_a);
        assertEq(IFacet(_p).mask(), 1);

        _proxy.setImpl(_b);
        assertEq(IFacet(_p).mask(), 2);

        _proxy.setImpl(_c);
        assertEq(IFacet(_p).mask(), 2);

        _proxy.setImpl(_d);
        assertEq(IFacet(_p).mask(), 3);
    }

    function testA() external {
        // pause A
        _proxy.setImpl(_a);
        vm.expectEmit(true, true, true, true);
        emit Paused(address(this));
        IFacet(_p).pause();

        // A paused
        vm.expectRevert(Pausable__Paused.selector);
        IFacet(_p).trigger();

        // B not paused
        _proxy.setImpl(_b);
        vm.expectEmit(true, true, true, true);
        emit Trigger();
        IFacet(_p).trigger();

        // C not paused
        _proxy.setImpl(_c);
        vm.expectEmit(true, true, true, true);
        emit Trigger();
        IFacet(_p).trigger();

        // D paused
        _proxy.setImpl(_d);
        vm.expectRevert(Pausable__Paused.selector);
        IFacet(_p).trigger();
    }
}
