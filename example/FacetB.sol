// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "../src/Pausable.sol";

contract FacetB is Pausable {
    event Trigger();

    /**
     * @dev bitmap[1] -> 2^1 -> uint256(2)
     */
    function _mask() internal pure override returns (uint256) {
        return 1 << 1;
    }

    function mask() external pure returns (uint256) {
        return _mask();
    }

    function trigger() external whenNotPaused(_mask()) {
        emit Trigger();
    }

    function pause() external {
        _pause(_mask());
    }

    function unpause() external {
        _unpause(_mask());
    }
}
