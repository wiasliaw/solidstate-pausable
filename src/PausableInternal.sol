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

    modifier whenNotPaused() {
        if (_paused()) revert Pausable__Paused();
        _;
    }

    modifier whenPaused() {
        if (!_paused()) revert Pausable__NotPaused();
        _;
    }

    function _paused() internal view virtual returns (bool) {
        return PausableStorage.layout().paused & _mask() != 0;
    }

    function _pause() internal virtual whenNotPaused {
        PausableStorage.layout().paused ^= _mask();
        emit Paused(msg.sender);
    }

    function _unpause() internal virtual whenPaused {
        PausableStorage.layout().paused ^= _mask();
        emit Unpaused(msg.sender);
    }

    /**
     * @dev Need to decide which bit should be set for pauability
     */
    function _mask() internal view virtual returns (uint256);
}
