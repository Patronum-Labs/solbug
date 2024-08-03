// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BugDelegateCallSelfDestruct {
    function unsafeDelegatecall(
        address _externalContract,
        bytes memory _data
    ) external {
        (bool success, ) = _externalContract.delegatecall(_data);
        require(success, "Delegatecall failed");
    }
}

contract UnsafeContract {
    function destroy() external {
        selfdestruct(payable(address(0)));
    }
}
