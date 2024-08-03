// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/delegateCallSelfDestruct/BugDelegateCallSelfDestruct.sol";

contract BugDelegateCallSelfDestructTest is Test {
    BugDelegateCallSelfDestruct public bugSelfDestruct;
    UnsafeContract public unsafeContract;
    address public alice = address(0x123);
    address public bob = address(0x234);

    function setUp() public {
        bugSelfDestruct = new BugDelegateCallSelfDestruct();
        unsafeContract = new UnsafeContract();
    }

    function testUnsafeDelegateCallDestroyContract() public {
        // Prepare the calldata for setOwner function
        bytes memory data = abi.encodeWithSignature("destroy()");

        // Check the code length greater than 0
        assertGt(address(bugSelfDestruct).code.length, 0);

        // Perform delegatecall and by traces we confirm that the contract was destructed
        // As in foundry you can't check the code length of the contract after selfdestruct
        // as all the calls happens in 1 transaction and selfdestruct remove the code and storage
        // after all the calls are done
        bugSelfDestruct.unsafeDelegatecall(address(unsafeContract), data);
    }
}
