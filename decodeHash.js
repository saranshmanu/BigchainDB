const BigchainDB = require('bigchaindb-driver');
const hash = require('tweetnacl')

var privateKey = '7jWaeDMRTdTx6YZkpiRHEBhgoHWURrAAn31n5cuepVRL';
var transaction = 'pGSAIOJk1VhJDuZGIQAy759uSMZ-XV-kMmb8El0ekMjZDVYAgUBvxbHPGgU_g8HeUMVnYJN9pyAa7olnzjFJ1FmckEr-eAVKRyogaHMPu5KU8_B2HBd14ss_2PNQKbkMxGfDylsC';

console.log(hash.box.keyPair())