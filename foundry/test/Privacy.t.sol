pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "@src/Privacy.sol";

contract PrivacyTest is Test {
    Privacy privacy;
    bytes32[3] initial_data;

    function setUp() public {
        bytes32 randomValue1 = keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender));
        bytes32 randomValue2 = keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender));
        bytes32 randomValue3 = keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender));
        privacy = new Privacy([randomValue1,randomValue2,randomValue3]);
    }

    function testUnlock() public{
        uint256 slot = 5; // The first element [0] of the array is on slot 3 so the third element [2] is on slot 5
        bytes32 target_data = vm.load(address(privacy),bytes32(slot));
        privacy.unlock(bytes16(target_data)); // The loaded value is a bytes32 so we should cast it to bytes16
        assertTrue(privacy.locked() == false);
    }
}
