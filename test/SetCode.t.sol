// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import {Test} from "forge-std/Test.sol";
import {DaiV2} from "src/DaiV2.sol";
import {Dai} from "src/Dai.sol";

contract SetCodeTest is Test {
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


    @>>>        address to impersonate - 0xf1da173228fcf015f43f3ea15abbb51f0d8f1123
    @>>>        TX of impersonated address - https://etherscan.io/tx/0x1ec921b0b7f018bd2ce181724928e718d09dcdf89102a6cb60f436a93a4a08db
    
    @>>>        Args for transferFrom:
        @>>>    from : 0xf1da173228fcf015f43f3ea15abbb51f0d8f1123
        @>>>    to : 0x6B175474E89094C44Da98b954EedeAC495271d0F
        @>>>    wad : 2581366963101906549127

    --------------------------------------------*/

    function setUp() public {
        uint256 forkID = vm.createFork(buildbear_eth_mainnet_fork_url);
        vm.selectFork(forkID);
    }

    function test_customEventEmission() public {
        // Step 1: Fetch original bytecode
        bytes memory originalCode = DAI_ETH_MAINNET_ADDRESS.code;
        emit log_named_bytes("Original Code", originalCode);

        // Step 2: Deploy modified bytecode
        bytes memory newBytecode = type(DaiV2).runtimeCode; // Replace with your modified contract
        deployCodeTo("DaiV2", abi.encode(uint256(1)), DAI_ETH_MAINNET_ADDRESS);

        // Verify the code was updated
        bytes memory updatedCode = DAI_ETH_MAINNET_ADDRESS.code;
        assertEq(updatedCode, newBytecode, "Bytecode update failed");

        // Step 3: Impersonate an address
        address impersonatedAddress = 0xf1dA173228fcf015F43f3eA15aBBB51f0d8f1123; // Replace with an address to impersonate
        vm.prank(impersonatedAddress);

        // Step 4: Interact with the modified contract
        // Example: Call a function to emit the new/modified event
        DaiV2 modifiedContract = DaiV2(DAI_ETH_MAINNET_ADDRESS);

        // Step 5: Validate event logs and check

        vm.expectEmit(true, true, true, true, address(DAI_ETH_MAINNET_ADDRESS));
        emit Transfer(
            0xf1dA173228fcf015F43f3eA15aBBB51f0d8f1123,
            0x6B175474E89094C44Da98b954EedeAC495271d0F,
            2581366963101906549127
        );
        vm.expectEmit(address(DAI_ETH_MAINNET_ADDRESS));
        emit BuildBearDAIV2Event("buildbear capture");
        DaiV2(DAI_ETH_MAINNET_ADDRESS).transferFrom(
            impersonatedAddress, 0x6B175474E89094C44Da98b954EedeAC495271d0F, 2581366963101906549127
        );
    }
}
