const Web3 = require('web3').default;
const fs = require('fs');

async function main() {
    // Connect to Ganache
    const web3 = new Web3('http://127.0.0.1:8545');
    
    // Load the contract ABI and address
    const abi = JSON.parse(fs.readFileSync('./build/contracts/SimpleStorage.json')).abi;
    const address = '0xf2dC8e73F49d8A4676E9E3F232A7BA7A84fE545e';
    
    // Create contract instance
    const contract = new web3.eth.Contract(abi, address);
    
    // Get the current value
    const currentValue = await contract.methods.get().call();
    console.log(`Current value: ${currentValue}`);
    
    // Set a new value
    const accounts = await web3.eth.getAccounts();
    await contract.methods.set(42).send({ from: accounts[0] });
    
    // Get the updated value
    const newValue = await contract.methods.get().call();
    console.log(`Updated value: ${newValue}`);
}

main().catch(console.error);
