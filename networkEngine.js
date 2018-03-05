const axios = require('axios');

axios.get('https://test.bigchaindb.com/api/v1/')
    .then(response => {
        console.log(response.data);
    })
    .catch(error => {
        console.log(error);
    });

// get all the information about a transaction using the Asset ID
axios.get('https://test.bigchaindb.com/api/v1/transactions/418b8fe96b5296584f9a60d0005d6b18dd4aab92c4b45c4d13bb0d5ca38beaf9')
    .then(response => {
        console.log(response.data);
    })
    .catch(error => {
        console.log(error);
    });

// Use the public key of the user to track all the transactions made by the user
axios.get('https://test.bigchaindb.com/api/v1/outputs?public_key=GEkKQDKFf5qzi7WwY2VzwBd3VyLhCu1aSaWjSAU7dCpo')
    .then(response => {
        console.log(response.data);
    })
    .catch(error => {
        console.log(error);
    });



// axios.get('/user', {
//     params: {
//         ID: 12345
//     }
// }).then(function (response) {
//     console.log(response);
// }).catch(function (error) {
//     console.log(error);
// });
//
