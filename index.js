const Web3 = require('web3');
const { abi, address } = require('./contract.js');
const privKey = require('./privkey.js');

const web3 = new Web3(new Web3.providers.HttpProvider('https://rinkeby.infura.io/'))



