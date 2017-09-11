# Securities / ICO Depository on Blockchain

Accompanying [blog post here](https://medium.com/@JordanValdma/ico-regulations-securities-depository-on-a-blockchain-26a65d54495)

This is ICO / [Securities Depository](https://en.wikipedia.org/wiki/Central_securities_depository)
blockchain implementation Proof of Concept projec on [Ethereum](https://www.ethereum.org).

It implements a simplified securities depository domain model with
Issuer, Security, Shareholder and a Transaction ledger.

Ledger and balances are implemented with [double-entry bookkeeping](https://en.wikipedia.org/wiki/Double-entry_bookkeeping_system) - credit/debit Transactions.

Tests outline
* Creation of Issuer, Security, Shareholder
* Emitting securities by Issuer
* Transferring securities between Shareholders

Current implementation is not optimized for performance.

Contribution is welcome.

## Running

Uses [Truffle](http://truffleframework.com/)

**Run an Ethereum node**

For example

TestRPC via Docker:
```
docker run -d -p 8545:8545 ethereumjs/testrpc:latest --account="0xf3a7e9c563ee0322062ff7a6f51034292af2cf81f010d456a71cb4f7a7134499, 100000000000000000000000000000000"`
```

Geth new account (OSX)
```
geth --dev --ipcpath ~/Library/Ethereum/geth.ipc console
personal.newAccount()
miner.start()
```

Geth existing account and password in password.txt  (OSX)

```
geth --dev -unlock "0" -password password.txt -rpc --ipcpath ~/Library/Ethereum/geth.ipc console
>miner.start();
``` 

**Deploy and test application**
```
truffle compile
truffle test
truffle migrate
```
