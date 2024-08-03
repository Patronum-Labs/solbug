// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BugDelegateCallStorage {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function unsafeDelegatecall(
        address _externalContract,
        bytes memory _data
    ) external {
        (bool success, ) = _externalContract.delegatecall(_data);
        require(success, "Delegatecall failed");
    }
}

contract UnsafeContract {
    address public owner;

    function setOwner(address _newOwner) external {
        owner = _newOwner;
    }
}
