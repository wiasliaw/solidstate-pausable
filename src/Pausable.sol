// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import { PausableInternal } from './PausableInternal.sol';

abstract contract Pausable is PausableInternal {
    function paused() external view virtual returns (bool) {
        return _paused();
    }
}
