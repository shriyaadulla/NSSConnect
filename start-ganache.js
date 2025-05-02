require('dotenv').config();

const { Server } = require('@ganache/cli');

const server = new Server({
    gasLimit: 12000000,
    defaultBalanceEther: 1000,
    mnemonic: {
        words: 'candy vivid private inside apart frost season pepper resource supply eager secret'
    },
    wallet: {
        accounts: [
            {
                secretKey: '0x7C9529A67102755B7E6102D6D950AC5D5863C98713805CEC576B945B15B71EAC',
                balance: 1000000000000000000000
            }
        ]
    }
});

server.listen(8545, function(err, blockchain) {
    if (err) {
        console.log(err);
        return;
    }
    console.log('Ganache started on port 8545');
    console.log('\nAccounts with 1000 ETH each:\n');
    
    // Get the first 10 accounts
    for (let i = 0; i < 10; i++) {
        const privateKey = `0x${i.toString(16).padStart(64, '0')}`;
        console.log(`Account ${i + 1}: ${server.provider.eth.accounts.wallet[i].address}`);
        console.log(`Private Key: ${privateKey}`);
        console.log('---');
    }
});
