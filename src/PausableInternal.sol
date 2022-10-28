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
        return PausableStorage.layout().paused == uint256(1);
    }

    function _pause() internal virtual whenNotPaused {
        PausableStorage.layout().paused ^= uint256(1);
        emit Paused(msg.sender);
    }

    function _unpause() internal virtual whenPaused {
        PausableStorage.layout().paused ^= uint256(1);
        emit Unpaused(msg.sender);
    }

    /** ***** ***** ***** ***** *****
     * Partial Pausable
     ***** ***** ***** ***** ***** */
    modifier whenNotPartiallyPaused(uint256 mask) {
        if (_partiallyPaused(mask)) revert Pausable__Paused();
        _;
    }

    modifier whenPartiallyPaused(uint256 mask) {
        if (!_partiallyPaused(mask)) revert Pausable__NotPaused();
        _;
    }

    /**
     * @notice query the contracts paused state.
     * @return true if paused, false if unpaused.
     */
    function _partiallyPaused(uint256 mask)
        internal
        view
        virtual
        returns (bool)
    {
        return PausableStorage.layout().paused & mask != 0;
    }

    function _partiallyPause(uint256 mask)
        internal
        virtual
        whenNotPartiallyPaused(mask)
    {
        PausableStorage.layout().paused ^= mask;
        emit Paused(msg.sender);
    }

    function _partiallyUnpause(uint256 mask)
        internal
        virtual
        whenPartiallyPaused(mask)
    {
        PausableStorage.layout().paused ^= mask;
        emit Unpaused(msg.sender);
    }
}
