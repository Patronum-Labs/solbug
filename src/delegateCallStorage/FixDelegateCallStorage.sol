// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FixDelegateCallStorage {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function safeDelegatecall(
        address _externalContract,
        bytes memory _data
    ) external {
        address originalOwner = owner;

        (bool success, ) = _externalContract.delegatecall(_data);
        require(success, "Delegatecall failed");

        require(owner == originalOwner, "Owner changed, reverting");
    }
}
