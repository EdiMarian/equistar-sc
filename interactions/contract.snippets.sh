PROJECT="${PWD}"

TOKEN_ID="ESTAR-461bab"
TOKEN_ID_HEX="0x$(echo -n ${TOKEN_ID} | xxd -p -u | tr -d '\n')"

PEM_FILE="/home/edi/Desktop/wallet-estar/wallet-owner.pem"
PROXY=https://gateway.multiversx.com
CHAINID=1
ADDRESS=erd1qqqqqqqqqqqqqpgqplw6qj45dvvdfcf7dcl30rp3y5zl0arawmfs6ratsj
MY_ADDRESS="erd1szcgm7vq3tmyxfgd4wd2k2emh59az8jq5jjpj9799a0k59u0wmfss4vw3v"

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