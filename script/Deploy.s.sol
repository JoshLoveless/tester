// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/MyERC721C.sol";

contract DeployMyERC721C is Script {
    function run() external {
        // Read private key as string first, then convert
        string memory privateKeyString = vm.envString("PRIVATE_KEY");
        uint256 deployerPrivateKey;
        
        // Handle both cases: with and without 0x prefix
        if (bytes(privateKeyString).length == 66) {
            // Has 0x prefix
            deployerPrivateKey = vm.parseUint(privateKeyString);
        } else {
            // No 0x prefix, add it
            deployerPrivateKey = vm.parseUint(string(abi.encodePacked("0x", privateKeyString)));
        }
        
        address deployer = vm.addr(deployerPrivateKey);
        
        console.log("Deploying from:", deployer);
        console.log("Deployer balance:", deployer.balance);
        
        vm.startBroadcast(deployerPrivateKey);
        
        MyERC721C nftContract = new MyERC721C(
            "My ApeChain Collection",    // name
            "MAC",                       // symbol
            10000,                       // maxSupply
            0.01 ether,                  // mintPrice (0.01 APE)
            deployer,                    // royaltyRecipient
            500                          // royaltyPercentage (5%)
        );
        
        console.log("Contract deployed to:", address(nftContract));
        
        vm.stopBroadcast();
    }
}