const WebSocket = require('ws')
const axios = require('axios');

const ws = new WebSocket('ws://139.59.12.96:59985/api/v1/streams/valid_transactions')

// wss://test.bigchaindb.com:443/api/v1/streams/valid_transactions
// ws://139.59.12.96:59985/api/v1/streams/valid_transactions

ws.on('open', () => {
    console.log("CONNECTED")
});

ws.on('message', (data) => {
    let json = JSON.parse(data)
    // axios.get('https://test.bigchaindb.com/api/v1/transactions/' + String(json.transaction_id))
    //     .then(response => {
    //         console.log(response.data['metadata']);
    //     })
    //     .catch(error => {
    //         console.log(error);
    //     })
    console.log("\nTransactionId: ", json.transaction_id)
    console.log("AssetId: ", json.asset_id)
    console.log("BlockId: ", json.block_id)
});