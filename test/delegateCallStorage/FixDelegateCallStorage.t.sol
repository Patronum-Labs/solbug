// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/delegateCallStorage/BugDelegateCallStorage.sol";
import "../../src/delegateCallStorage/FixDelegateCallStorage.sol";

contract DelegateCallStorageTest is Test {
    BugDelegateCallStorage public bugStorage;
    FixDelegateCallStorage public fixStorage;
    UnsafeContract public unsafeContract;
    address public alice = address(0x1);
    address public bob = address(0x2);

    function setUp() public {
        bugStorage = new BugDelegateCallStorage();
        fixStorage = new FixDelegateCallStorage();
        unsafeContract = new UnsafeContract();
    }

    function testBugDelegateCallChangeOwner() public {
        // Prepare the calldata for setOwner function
        bytes memory data = abi.encodeWithSignature("setOwner(address)", alice);

        // Perform delegatecall on BugDelegateCallStorage
        bugStorage.unsafeDelegatecall(address(unsafeContract), data);

        // Check if the owner has changed
        assertEq(bugStorage.owner(), alice);
    }

    function testFixDelegateCallPreventOwnerChange() public {
        // Prepare the calldata for setOwner function
        bytes memory data = abi.encodeWithSignature("setOwner(address)", alice);

        // Attempt to perform delegatecall on FixDelegateCallStorage
        vm.expectRevert("Owner changed, reverting");
        fixStorage.safeDelegatecall(address(unsafeContract), data);

        // Check that the owner hasn't changed
        assertEq(fixStorage.owner(), address(this));
    }
}
