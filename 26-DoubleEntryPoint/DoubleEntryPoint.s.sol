// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../src/DoubleEntryPoint.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

contract DetectionBot is IDetectionBot
{
    address public vault;

    constructor(address _vault)
    {
        vault = _vault;
    }

    function handleTransaction(address user, bytes calldata msgData) external override
    {
        bytes4 funcSig;
        assembly
        {
            funcSig := calldataload(msgData.offset)
        }

        bytes4 delegateTransferSig = 0x9cd1a121;

        if (funcSig == delegateTransferSig)
        {
            (, , address origSender) = abi.decode(msgData[4:], (address, uint256, address));

            if (origSender == vault)
            {
                IForta(msg.sender).raiseAlert(user);
            }
        }
    }
}

contract deploy is Script
{
    function run() external
    {
        vm.startBroadcast();

        address vault; // third contract creation in the get instance transaction
        DetectionBot bot = new DetectionBot(vault);

        vm.stopBroadcast();
    }
}

contract SetBot is Script
{
    function run() external
    {
        vm.startBroadcast();

        Forta forta = Forta(/* second contract creation */);
        forta.setDetectionBot(/* bot address */);

        vm.stopBroadcast();
    }
}