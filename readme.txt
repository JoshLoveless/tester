Enable Mint: cast send 0xf5869fa25c039271c8fE3Cb7D6b2e5F174F81b6f \
    "toggleMinting()" \
    --rpc-url apechain \
    --private-key 0x$PRIVATE_KEY

Update BaseURI: cast send 0xf5869fa25c039271c8fE3Cb7D6b2e5F174F81b6f \
    "setBaseURI(string)" \
    "ipfs://QmdhLJeUVLtoEuHn3V3DhrqPF7vfR7bMmUS48MiTqLBCT/" \
    --rpc-url apechain \
    --account deployer

Mint: # This will mint token #1 to your wallet for 0.01 APE
cast send 0xf5869fa25c039271c8fE3Cb7D6b2e5F174F81b6f \
    "mint(address,string)" \
    0x10498372C8C183D6De6D1Ec53B5921de258De2f8 \
    "1" \
    --value 0.01ether \
    --rpc-url apechain \
    --private-key 0x$PRIVATE_KEY

BatchMint: cast send 0xf5869fa25c039271c8fE3Cb7D6b2e5F174F81b6f \
    "batchMint(address,uint256)" \
    0x10498372C8C183D6De6D1Ec53B5921de258De2f8 \
    9 \
    --value 0.09ether \
    --rpc-url apechain \
    --private-key 0x$PRIVATE_KEY

BatchMint: # Batch mint tokens 3-10 to yourself (FREE as owner)
cast send 0xf5869fa25c039271c8fE3Cb7D6b2e5F174F81b6f \
    "batchMint(address[],string[])" \
    "[0x10498372C8C183D6De6D1Ec53B5921de258De2f8,0x10498372C8C183D6De6D1Ec53B5921de258De2f8,0x10498372C8C183D6De6D1Ec53B5921de258De2f8,0x10498372C8C183D6De6D1Ec53B5921de258De2f8,0x10498372C8C183D6De6D1Ec53B5921de258De2f8,0x10498372C8C183D6De6D1Ec53B5921de258De2f8,0x10498372C8C183D6De6D1Ec53B5921de258De2f8,0x10498372C8C183D6De6D1Ec53B5921de258De2f8]" \
    "[3,4,5,6,7,8,9,10]" \
    --rpc-url apechain \
    --private-key 0x$PRIVATE_KEY