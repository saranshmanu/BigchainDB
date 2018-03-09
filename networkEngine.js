const axios = require('axios');

// https://test.bigchaindb.com/api/v1/
// http://localhost:59984/api/v1/
// http://139.59.12.96:59984/api/v1/

axios.get('http://139.59.12.96:59984/api/v1/')
    .then(response => {
        console.log(response.data);
    })
    .catch(error => {
        console.log(error);
    });

// get all the information about a transaction using the Asset ID
axios.get('http://139.59.12.96:59984/api/v1/transactions/2a2543ca997c214c1b1edeb5e302f15259e734af4c47166e519ea0359d3310d4')
    .then(response => {
        console.log(response.data);
    })
    .catch(error => {
        console.log(error);
    });

// Use the public key of the user to track all the transactions made by the user
axios.get('http://139.59.12.96:59984/api/v1/outputs?public_key=GEkKQDKFf5qzi7WwY2VzwBd3VyLhCu1aSaWjSAU7dCpo')
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
