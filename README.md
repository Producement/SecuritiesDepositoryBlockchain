# SecuritiesDepositoryBlockchain
[Securities Depository](https://en.wikipedia.org/wiki/Central_securities_depository)
on blockchain Proof of Concept. Built on [Ethereum](https://www.ethereum.org).

Implements a simplified securities depository domain model with
Issuer, Security, Shareholder.

Balances are implemented with [double-entry bookkeeping](https://en.wikipedia.org/wiki/Double-entry_bookkeeping_system), by credit/debit Transactions struct ledger.

TestSecuritesDepository.sol tests outline
* Creation of Issuer, Security, Shareholder
* Emitting securities by Issuer
* Transferring securities between Shareholders

Current implementation is not optimized for performance.
