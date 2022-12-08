// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {OwnershipYul} from "./OwnershipYul.sol";

contract Test is OwnershipYul {
    uint256 private number;

    constructor() {
        initOwner();
    }

    function increaseCount() external onlyOwner {
        ++number;
    }

    function getNumber() external view returns (uint256) {
        return number;
    }
}
