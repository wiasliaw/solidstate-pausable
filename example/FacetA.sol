// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "../src/Pausable.sol";

contract FacetA is Pausable {
    event Trigger();

    /**
     * @dev bitmap[0] -> 2^0 -> uint256(0)
     */
    function _mask() internal pure override returns (uint256) {
        return 1 << 0;
    }

    function mask() external pure returns (uint256) {
        return _mask();
    }

    function trigger() external whenNotPaused {
        emit Trigger();
    }

    function pause() external {
        _pause();
    }

    function unpause() external {
        _unpause();
    }
}
