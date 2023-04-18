PROJECT="${PWD}"

TOKEN_ID="ESTAR-ccc274"
TOKEN_ID_HEX="0x$(echo -n ${TOKEN_ESTAR_ID} | xxd -p -u | tr -d '\n')"

PEM_FILE="/home/edi/Desktop/my-wallet/my_wallet.pem"
PROXY=https://devnet-gateway.multiversx.com
CHAINID=D
ADDRESS=erd1qqqqqqqqqqqqqpgqwdwhc6lhgwkwg00724d3qq7jwg6vg8qhxszquk0j0g
MY_ADDRESS="erd1a6p39rlsn2lm20adqe5tmzy543luwqx4dywzflr2dmtwdf75xszqdw9454"

deploy() {
  mxpy --verbose contract deploy --project=${PROJECT} --recall-nonce --pem=${PEM_FILE} \
    --gas-limit=60000000 --send --outfile="${PROJECT}/interactions/logs/deploy.json" \
    --proxy=${PROXY} --chain=${CHAINID} \
    --arguments $TOKEN_ID_HEX 10000000000000000000 || return
}

updateContract() {
  mxpy --verbose contract upgrade ${ADDRESS} --project=${PROJECT} --recall-nonce --pem=${PEM_FILE} \
    --gas-limit=60000000 --send --outfile="${PROJECT}/interactions/logs/deploy.json" \
    --proxy=${PROXY} --chain=${CHAINID} \
    --arguments $TOKEN_ID_HEX 10000000000000000000
}

buyTickets() {
  method_name="0x$(echo -n 'buyTickets' | xxd -p -u | tr -d '\n')"
  mxpy --verbose contract call ${ADDRESS} --recall-nonce \
    --pem=${PEM_FILE} \
    --gas-limit=60000000 \
    --proxy=${PROXY} --chain=${CHAINID} \
    --function="ESDTTransfer" \
    --arguments $TOKEN_ID_HEX 100000000000000000000 $method_name \
    --send \
    --outfile="${PROJECT}/interactions/logs/stake.json"
}

getTotalTicketsPerAddress() {
  mxpy --verbose contract query ${ADDRESS} --function="getTotalTicketsPerAddress" --arguments $MY_ADDRESS \
    --proxy=${PROXY}
}