for i in $(seq 1 10); do
    forge script CoinFlipScript.s.sol \
    --rpc-url "$RPC_URL" --private-key "$PRIVATE_KEY" \
    --broadcast --tc flip
    sleep 10 # 10 seconds should be enough for a block to be produced
    # but may need to run the command a couple more times is any reverts happen
done
