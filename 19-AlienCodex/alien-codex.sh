    echo -e "\n  ***** MAKING CONTACT *****"

    cast send "$ALIEN_CODEX" "makeContact()" \
    --rpc-url "$RPC_URL"  --private-key "$PRIVATE_KEY"
#   cast storage $ALIEN_CODEX 0 --rpc-url $RPC_URL
#   0x0000000000000000000000010bc04aa6aac163a6b3667636d798fa053d43bd11


    cast send "$ALIEN_CODEX" "retract()" \
    --rpc-url "$RPC_URL"  --private-key "$PRIVATE_KEY"
#   cast storage $ALIEN_CODEX 1 --rpc-url $RPC_URL
#   0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff


#   bytes32 arrayStartSlot = keccak256(abi.encode(1));
#   uint startSlotUint = uint(arrayStartSlot);

#   since there are 2**256 storage slots:
#   uint256 targetIndex = type(uint256).max - startSlotUint + 1;
#   targetIndex: 35707666377435648211887908874984608119992236509074197713628505308453184860938

    cast send "$ALIEN_CODEX" "revise(uint256,bytes32)" \
    35707666377435648211887908874984608119992236509074197713628505308453184860938 \
    0x000000000000000000000000walletaddressnoprefixhere --rpc-url "$RPC_URL" --private-key "$PRIVATE_KEY"
