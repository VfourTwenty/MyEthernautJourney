cast send \
"$INSTANCE_ADDRESS" \
"transfer(address,uint)" "$SOMEADDRESS" 21 \
--rpc-url "$RPC_URL" --private-key "$PRIVATE_KEY"

