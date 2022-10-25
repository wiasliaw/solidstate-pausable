// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "../src/Pausable.sol";

contract FacetD is Pausable {
    event Trigger();

    /**
     * @dev bitmap[1] or bitmap[0] -> 2^1 or 2^0 -> uint256(3)
     */
    function _mask() internal pure override returns (uint256) {
        return (1 << 1) | (1 << 0);
    }

    function mask() external pure returns (uint256) {
        return _mask();
    }

    function trigger() external whenNotPaused {
        emit Trigger();
    }
}
