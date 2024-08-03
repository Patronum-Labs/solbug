// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/delegateCallStorage/BugDelegateCallStorage.sol";

contract BugDelegateCallStorageTest is Test {
    BugDelegateCallStorage public bugStorage;
    UnsafeContract public unsafeContract;
    address public alice = address(0x123);
    address public bob = address(0x234);

    function setUp() public {
        bugStorage = new BugDelegateCallStorage();
        unsafeContract = new UnsafeContract();
    }

    function testInitialOwner() public view {
        assertEq(bugStorage.owner(), address(this));
    }

    function testUnsafeDelegateCallChangeOwner() public {
        // Prepare the calldata for setOwner function
        bytes memory data = abi.encodeWithSignature("setOwner(address)", alice);

        // Perform delegatecall
        bugStorage.unsafeDelegatecall(address(unsafeContract), data);

        // Check if the owner has changed
        assertEq(bugStorage.owner(), alice);
    }

    function testUnsafeDelegateCallChangeOwnerTwice() public {
        // Change owner to Alice
        bytes memory data1 = abi.encodeWithSignature(
            "setOwner(address)",
            alice
        );
        bugStorage.unsafeDelegatecall(address(unsafeContract), data1);
        assertEq(bugStorage.owner(), alice);

        // Change owner to Bob
        bytes memory data2 = abi.encodeWithSignature("setOwner(address)", bob);
        bugStorage.unsafeDelegatecall(address(unsafeContract), data2);
        assertEq(bugStorage.owner(), bob);
    }
}
