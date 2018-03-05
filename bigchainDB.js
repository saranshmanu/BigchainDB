const BigchainDB = require('bigchaindb-driver');
const bip39 = require('bip39');


const API_PATH = 'https://test.bigchaindb.com/api/v1/';
const conn = new BigchainDB.Connection(API_PATH, {
    app_id: 'f0c5a7ce',
    app_key: 'f97a09137b19d4693554d24efb7dbd43'
});

const alice = new BigchainDB.Ed25519Keypair(bip39.mnemonicToSeed('seedPhrase').slice(0,32));

console.log(alice);

const painting = {
    name: 'Meninas',
    author: 'Diego Rodríguez de Silva y Velázquez',
    place: 'Madrid',
    year: '1656'
};

function createPaint() {
    // Construct a transaction payload
    const txCreatePaint = BigchainDB.Transaction.makeCreateTransaction(
        // Asset field
        {
            painting
        },
        // Metadata field, contains information about the transaction itself
        // (can be `null` if not needed)
        {
            datetime: new Date().toString(),
            location: 'Madrid',
            value: {
                value_eur: '25000000€',
                value_btc: '2200'
            }
        },
        // Output. For this case we create a simple Ed25519 condition
        [BigchainDB.Transaction.makeOutput(
            BigchainDB.Transaction.makeEd25519Condition(alice.publicKey))],
        // Issuers
        alice.publicKey
    );
    // The owner of the painting signs the transaction
    const txSigned = BigchainDB.Transaction.signTransaction(txCreatePaint, alice.privateKey);
    console.log(txSigned);
    // Send the transaction off to BigchainDB
    conn.postTransaction(txSigned)
    // Check the status of the transaction
    .then(() => conn.pollStatusAndFetchTransaction(txSigned.id))
    .then(res => {
        document.body.innerHTML += '<h3>Transaction created</h3>';
        document.body.innerHTML += txSigned.id
    // txSigned.id corresponds to the asset id of the painting
    })
}

function transferOwnership(txCreatedID, newOwner) {
    const newUser = new BigchainDB.Ed25519Keypair();
    // Get transaction payload by ID
    conn.getTransaction(txCreatedID)
        .then((txCreated) => {
        const createTranfer = BigchainDB.Transaction.
        makeTransferTransaction(
            // The output index 0 is the one that is being spent
            [{
                tx: txCreated,
                output_index: 0
            }],
            [BigchainDB.Transaction.makeOutput(
                BigchainDB.Transaction.makeEd25519Condition(
                    newOwner.publicKey))
            ],
            {
                datetime: new Date().toString(),
                value: {
                    value_eur: '30000000€',
                    value_btc: '2100',
                }
            }
        );
        // Sign with the key of the owner of the painting (Alice)
        const signedTransfer = BigchainDB.Transaction
            .signTransaction(createTranfer, alice.privateKey)
        return conn.postTransaction(signedTransfer)
    })
.then((signedTransfer) => conn.pollStatusAndFetchTransaction(signedTransfer.id))
.then(res => {
        document.body.innerHTML += '<h3>Transfer Transaction created</h3>'
    document.body.innerHTML += res.id
})
}

createPaint();