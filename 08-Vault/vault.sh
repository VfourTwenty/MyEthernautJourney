cast storage \
$INSTANCE_ADDRESS 1
-r "$RPC_URL"
# 0x412076657279207374726f6e67207365637265742070617373776f7264203a29

cast send \
"$INSTANCE_ADDRESS" "unlock(bytes32)" 0x412076657279207374726f6e67207365637265742070617373776f7264203a29
# shellcheck disable=SC2086
--rpc-url "$RPC_URL" --private-key "$PRIVATE_KEY"