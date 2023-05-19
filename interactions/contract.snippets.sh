PROJECT="${PWD}"

TOKEN_ID="ESTAR-461bab"
TOKEN_ID_HEX="0x$(echo -n ${TOKEN_ID} | xxd -p -u | tr -d '\n')"

TEST_TOKEN_ID="HYPE-619661"
TEST_TOKEN_ID_IN_HEX="0x$(echo -n ${TEST_TOKEN_ID} | xxd -p -u | tr -d '\n')"

PEM_FILE="/home/edi/Desktop/wallet-estar/wallet-owner.pem"
PROXY=https://gateway.multiversx.com
CHAINID=1
ADDRESS=erd1qqqqqqqqqqqqqpgqplw6qj45dvvdfcf7dcl30rp3y5zl0arawmfs6ratsj
MY_ADDRESS="erd1szcgm7vq3tmyxfgd4wd2k2emh59az8jq5jjpj9799a0k59u0wmfss4vw3v"

deploy() {
  mxpy --verbose contract deploy --project=${PROJECT} --recall-nonce --pem=${PEM_FILE} \
    --gas-limit=60000000 --send --outfile="${PROJECT}/interactions/logs/deploy.json" \
    --proxy=${PROXY} --chain=${CHAINID} \
    --arguments $TOKEN_ID_HEX || return
}

updateContract() {
  mxpy --verbose contract upgrade ${ADDRESS} --project=${PROJECT} --recall-nonce --pem=${PEM_FILE} \
    --gas-limit=60000000 --send --outfile="${PROJECT}/interactions/logs/deploy.json" \
    --proxy=${PROXY} --chain=${CHAINID} \
    --arguments $TOKEN_ID_HEX
}

updateTicketPriceInEstar() {
  mxpy --verbose contract call ${ADDRESS} --recall-nonce \
    --pem=${PEM_FILE} \
    --gas-limit=5000000 \
    --proxy=${PROXY} --chain=${CHAINID} \
    --function="updateTicketPriceInEstar" \
    --arguments 10000000000000000000 \
    --send \
    --outfile="${PROJECT}/interactions/logs/stake.json"
}

updateTicketPriceInEgld() {
  mxpy --verbose contract call ${ADDRESS} --recall-nonce \
    --pem=${PEM_FILE} \
    --gas-limit=5000000 \
    --proxy=${PROXY} --chain=${CHAINID} \
    --function="updateTicketPriceInEgld" \
    --arguments 660000000000000 \
    --send \
    --outfile="${PROJECT}/interactions/logs/stake.json"
}

setStablePriceInEstar() {
  mxpy --verbose contract call ${ADDRESS} --recall-nonce \
    --pem=${PEM_FILE} \
    --gas-limit=5000000 \
    --proxy=${PROXY} --chain=${CHAINID} \
    --function="setStablePriceInEstar" \
    --arguments 5 50000000000000000000000 \
    --send \
    --outfile="${PROJECT}/interactions/logs/stake.json"
}

setStablePriceInEgld() {
  mxpy --verbose contract call ${ADDRESS} --recall-nonce \
    --pem=${PEM_FILE} \
    --gas-limit=5000000 \
    --proxy=${PROXY} --chain=${CHAINID} \
    --function="setStablePriceInEgld" \
    --arguments 5 3333000000000000000 \
    --send \
    --outfile="${PROJECT}/interactions/logs/stake.json"
}

setUserStable() {
  mxpy --verbose contract call ${ADDRESS} --recall-nonce \
    --pem=${PEM_FILE} \
    --gas-limit=5000000 \
    --proxy=${PROXY} --chain=${CHAINID} \
    --value=0 \
    --function="setUserStable" \
    --arguments $MY_ADDRESS 3 \
    --send \
    --outfile="${PROJECT}/interactions/logs/stake.json"
}

withdrawEgld() {
  mxpy --verbose contract call ${ADDRESS} --recall-nonce \
    --pem=${PEM_FILE} \
    --gas-limit=5000000 \
    --proxy=${PROXY} --chain=${CHAINID} \
    --value=0 \
    --function="withdrawEgld" \
    --send \
    --outfile="${PROJECT}/interactions/logs/stake.json"
}

buyTickets() {
  method_name="0x$(echo -n 'buyTickets' | xxd -p -u | tr -d '\n')"
  mxpy --verbose contract call ${ADDRESS} --recall-nonce \
    --pem=${PEM_FILE} \
    --gas-limit=5000000 \
    --proxy=${PROXY} --chain=${CHAINID} \
    --function="ESDTTransfer" \
    --arguments $TEST_TOKEN_ID_IN_HEX 100000000000000000000 $method_name \
    --send \
    --outfile="${PROJECT}/interactions/logs/stake.json"
}

buyTicketsWithEgld() {
  method_name="0x$(echo -n 'buyTickets' | xxd -p -u | tr -d '\n')"
  mxpy --verbose contract call ${ADDRESS} --recall-nonce \
    --pem=${PEM_FILE} \
    --gas-limit=5000000 \
    --proxy=${PROXY} --chain=${CHAINID} \
    --value=660000000000000 \
    --function="buyTickets" \
    --send \
    --outfile="${PROJECT}/interactions/logs/stake.json"
}

upgradeStableWithEstar() {
  method_name="0x$(echo -n 'upgradeStable' | xxd -p -u | tr -d '\n')"
  mxpy --verbose contract call ${ADDRESS} --recall-nonce \
    --pem=${PEM_FILE} \
    --gas-limit=5000000 \
    --proxy=${PROXY} --chain=${CHAINID} \
    --function="ESDTTransfer" \
    --arguments $TOKEN_ID_HEX 5000000000000000000000 $method_name \
    --send \
    --outfile="${PROJECT}/interactions/logs/stake.json"
}

upgradeStableWithEgld() {
  method_name="0x$(echo -n 'upgradeStable' | xxd -p -u | tr -d '\n')"
  mxpy --verbose contract call ${ADDRESS} --recall-nonce \
    --pem=${PEM_FILE} \
    --gas-limit=5000000 \
    --proxy=${PROXY} --chain=${CHAINID} \
    --value=666000000000000000 \
    --function="upgradeStable" \
    --send \
    --outfile="${PROJECT}/interactions/logs/stake.json"
}

getTicketPriceInEstar() {
  mxpy --verbose contract query ${ADDRESS} --function="getTicketPriceInEstar" \
    --proxy=${PROXY}
}

getTicketPriceInEgld() {
  mxpy --verbose contract query ${ADDRESS} --function="getTicketPriceInEgld" \
    --proxy=${PROXY}
}

getTotalTicketsPerAddress() {
  mxpy --verbose contract query ${ADDRESS} --function="getTotalTicketsPerAddress" --arguments $MY_ADDRESS \
    --proxy=${PROXY}
}

getStablePriceInEstar() {
  mxpy --verbose contract query ${ADDRESS} --function="getStablePriceInEstar" --arguments 1 \
    --proxy=${PROXY}
}

getStablePriceInEgld() {
  mxpy --verbose contract query ${ADDRESS} --function="getStablePriceInEgld" --arguments 1 \
    --proxy=${PROXY}
}

getUserStable() {
  mxpy --verbose contract query ${ADDRESS} --function="getUserStable" --arguments $MY_ADDRESS \
    --proxy=${PROXY}
}