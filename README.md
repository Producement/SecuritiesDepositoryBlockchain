# SecuritiesDepositoryBlockchain
This is [Securities Depository](https://en.wikipedia.org/wiki/Central_securities_depository)
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