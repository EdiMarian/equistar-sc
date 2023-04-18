PROJECT="${PWD}"

TOKEN_ESTAR_ID="ESTAR-461bab"
TOKEN_ESTAR_ID_HEX="0x$(echo -n ${TOKEN_ESTAR_ID} | xxd -p -u | tr -d '\n')"

PEM_FILE="/home/edi/Desktop/my-wallet/my_wallet.pem"
PROXY=https://devnet-gateway.multiversx.com
CHAINID=D
ADDRESS=erd1qqqqqqqqqqqqqpgq3nnaee50skd7l2c3m7vr7wf8ruv7470mwmfs5d0tll
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

stake() {
  method_name="0x$(echo -n 'stake' | xxd -p -u | tr -d '\n')"
  mxpy --verbose contract call ${MY_ADDRESS} --recall-nonce \
    --pem=${PEM_FILE} \
    --gas-limit=60000000 \
    --proxy=${PROXY} --chain=${CHAINID} \
    --function="MultiESDTNFTTransfer" \
    --arguments $ADDRESS 1 $TOKEN_ID_HEX 1819 1 $method_name \
    --send \
    --outfile="${PROJECT}/interactions/logs/stake.json"
}

getToken() {
  mxpy --verbose contract query ${ADDRESS} --function="getToken" \
    --proxy=${PROXY}
}