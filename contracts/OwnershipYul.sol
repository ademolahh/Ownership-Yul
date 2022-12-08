// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

error ZeroAddressError();

abstract contract OwnershipYul {
    // bytes4(keccak256(bytes("owner.slot")))
    uint256 private constant OWNER_SLOT = 0x95dd53e9;

    // bytes4(keccak256(bytes("notOwner()")))
    uint256 private constant NOT_OWNER_ERROR = 0x251c9d63;

    // keccak256(bytes("OwnershipTransferred(address,address)"))
    uint256 private constant OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE =
        0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0;

    modifier onlyOwner() {
        isOwner();
        _;
    }

    function setOwner(address _owner) internal virtual {
        assembly {
            _owner := shr(0x60, shl(0x60, _owner))
            sstore(OWNER_SLOT, _owner)

            log3(0, 0, OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, 0, _owner)
        }
    }

    /// @notice this function should be called in the constructor of the parent contract
    function initOwner() internal virtual {
        setOwner(msg.sender);
    }

    function transferOwnership(address _newOwner) external virtual onlyOwner {
        if (_newOwner == address(0)) revert ZeroAddressError();
        setOwner(_newOwner);
    }

    function renounceOwnership() external onlyOwner {
        setOwner(address(0));
    }

    function owner() external view returns (address _owner) {
        assembly {
            _owner := sload(OWNER_SLOT)
        }
    }

    function isOwner() internal view virtual {
        assembly {
            let owner := sload(OWNER_SLOT)
            if iszero(eq(caller(), owner)) {
                mstore(0x00, NOT_OWNER_ERROR)
                // since the error NOT_OWNER_ERROR is a bytes4
                // we start after the first 28/0x1c bytes
                revert(0x1c, 0x04)
            }
        }
    }
}
