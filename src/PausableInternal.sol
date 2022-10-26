// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import {PausableStorage} from "./PausableStorage.sol";

abstract contract PausableInternal {
    using PausableStorage for PausableStorage.Layout;

    error Pausable__Paused();
    error Pausable__NotPaused();

    // gas saving & better query in etherscan
    event Paused(address indexed account);
    event Unpaused(address indexed account);

    modifier whenNotPaused(uint256 mask) {
        if (_paused(mask)) revert Pausable__Paused();
        _;
    }

    modifier whenPaused(uint256 mask) {
        if (!_paused(mask)) revert Pausable__NotPaused();
        _;
    }

    function _paused(uint256 mask) internal view virtual returns (bool) {
        return PausableStorage.layout().paused & mask != 0;
    }

    function _pause(uint256 mask) internal virtual whenNotPaused(mask) {
        PausableStorage.layout().paused ^= mask;
        emit Paused(msg.sender);
    }

    function _unpause(uint256 mask) internal virtual whenPaused(mask) {
        PausableStorage.layout().paused ^= mask;
        emit Unpaused(msg.sender);
    }

    // hint for implementation
    function _mask() internal view virtual returns (uint256);
}
