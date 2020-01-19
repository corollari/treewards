const Web3 = require('web3');
const { abi, address } = require('./contract.js');
const privKey = require('./privkey.js');

const web3 = new Web3(new Web3.providers.HttpProvider('https://rinkeby.infura.io/'))

const account = web3.eth.accounts.privateKeyToAccount(privKey);
let contract = new web3.eth.Contract(abi,address);

async function sendTx(call){
	let gas = await call.estimateGas({from:account.address});
	const gasPrice = await web3.eth.getGasPrice();
	var tx = {
		to: address,
		gasPrice,
		gas,
		data: call.encodeABI()
	}
	console.log(gas)
	web3.eth.accounts.signTransaction(tx, privKey)
		.then(signed => {
			console.log(signed);
			var tran = web3.eth.sendSignedTransaction(signed.rawTransaction, console.log)

			tran.on('confirmation', (confirmationNumber, receipt) => {
				console.log('confirmation: ' + confirmationNumber);
			});

			tran.on('transactionHash', hash => {
				console.log('hash');
				console.log(hash);
			});

			tran.on('receipt', receipt => {
				console.log('reciept');
				console.log(receipt);
			});

			tran.on('error', error => {
				console.log(error.toString());
			});
		});
}

function submitOracle(week, landOwnerToUpdate, forestedArea){
	let call = contract.methods.submitOracle(week, landOwnerToUpdate, forestedArea);
	return sendTx(call);
}

// submitOracle(0,account.address,2)

function assignLand(landOwnerToUpdate, landId){
	let call = contract.methods.submitOracle(landOwnerToUpdate, landId);
	return sendTx(call);
}

module.exports = {submitOracle, assignLand};
