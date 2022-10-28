// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import {PausableInternal} from "./PausableInternal.sol";

contract PartialPausableMock is PausableInternal {
    uint256 private constant MASK = 3; // bitmap[1] or bitmap[0]

    function paused() external view returns (bool) {
        return _partiallyPaused(MASK);
    }

    function pause() external {
        _partiallyPause(MASK);
    }

    function unpause() external {
        _partiallyUnpause(MASK);
    }
}
