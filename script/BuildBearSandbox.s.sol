// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Script} from "forge-std/Script.sol";
import {DaiV2} from "src/DaiV2.sol";
import {Dai} from "src/Dai.sol";
import {console} from "forge-std/console.sol";

contract SetCodeTest is Script {
    string buildbear_eth_mainnet_fork_url = "https://rpc.buildbear.io/mighty-captainamerica-167b8637";
    address constant DAI_ETH_MAINNET_ADDRESS = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    event BuildBearDAIV2Event(string data);
    event Transfer(address indexed src, address indexed dst, uint256 wad);

    /*-------------------------------------------

    @>>>> Use the api link below to get code for DAI
    https://api.etherscan.io/v2/api
    ?chainid=1
    &module=contract
    &action=getsourcecode
    &address=CONTRACT_ADDRESS
    &apikey=API_TOKEN 


    @@@ IMPORTANT - get faucet tokens on the address to impersonate for tx to be successful


    @>>>        address to impersonate - 0xf1da173228fcf015f43f3ea15abbb51f0d8f1123
    @>>>        Reference of TX of impersonated address - https://etherscan.io/tx/0x1ec921b0b7f018bd2ce181724928e718d09dcdf89102a6cb60f436a93a4a08db
    
    @>>>        Args for transferFrom from the tx: https://etherscan.io/tx/0x1ec921b0b7f018bd2ce181724928e718d09dcdf89102a6cb60f436a93a4a08db
        @>>>    from : 0xf1da173228fcf015f43f3ea15abbb51f0d8f1123
        @>>>    to : 0x6B175474E89094C44Da98b954EedeAC495271d0F
        @>>>    wad : 2581366963101906549127


    @>>> run the script using - forge script script/
    --------------------------------------------*/

    function run() public {
        address buildbear_sandbox_dai = address(new DaiV2(1));
        console.log(
            "Impersonated address DAI Balance on Buildbear Sandbox before transfer: ",
            Dai(DAI_ETH_MAINNET_ADDRESS).balanceOf(0xf1dA173228fcf015F43f3eA15aBBB51f0d8f1123)
        );
        console.log(
            "Receiver address DAI Balance on Buildbear Sandbox before transfer: ",
            Dai(DAI_ETH_MAINNET_ADDRESS).balanceOf(0x6B175474E89094C44Da98b954EedeAC495271d0F)
        );
        vm.startBroadcast(address(0xf1dA173228fcf015F43f3eA15aBBB51f0d8f1123));
        Dai(DAI_ETH_MAINNET_ADDRESS).approve(0x6B175474E89094C44Da98b954EedeAC495271d0F, 2581366963101906549127);
        DaiV2(DAI_ETH_MAINNET_ADDRESS).transferFrom(
            0xf1dA173228fcf015F43f3eA15aBBB51f0d8f1123, // address to impersonate
            0x6B175474E89094C44Da98b954EedeAC495271d0F, // receiver
            2581366963101906549127 // value
        );

        console.log(
            "Impersonated address DAI Balance on Buildbear Sandbox after transfer: ",
            Dai(DAI_ETH_MAINNET_ADDRESS).balanceOf(0xf1dA173228fcf015F43f3eA15aBBB51f0d8f1123)
        );
        console.log(
            "Receiver address DAI Balance on Buildbear Sandbox after transfer: ",
            Dai(DAI_ETH_MAINNET_ADDRESS).balanceOf(0x6B175474E89094C44Da98b954EedeAC495271d0F)
        );
    }
}
