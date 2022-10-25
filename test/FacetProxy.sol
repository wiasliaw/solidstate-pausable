// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "openzeppelin-contracts/contracts/proxy/Proxy.sol";

contract FacetProxy is Proxy {
    address private _impl;

    function setImpl(address _addr) external {
        _impl = _addr;
    }

    function _implementation() internal view override returns (address) {
        return _impl;
    }
}
