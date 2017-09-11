pragma solidity ^0.4.4;

contract SecuritiesDepository {

    enum SecurityType { DebtInstrument, FundUnit, Rights, Unit }

    struct Issuer {
        bytes32 registryCode;
        address identifier;
        bytes32 name;
        bytes32 countryCode;
    }
    mapping(bytes32 => Issuer) issuers;

    struct Security {
        bytes32 isin;
        Issuer issuer;
        SecurityType securityType;
        uint nominalValue;
    }
    mapping(bytes32 => Security) securities;

    struct Shareholder {
        bytes32 registryCode;
        address identifier;
    }
    mapping(bytes32 => Shareholder) shareholders;

    enum TransactionType { Debit, Credit }

    struct Transaction {
        Security security;
        Shareholder shareholder;
        uint amount;
        TransactionType transactionType;
    }

    Transaction[] transactions;

    function createIssuer(bytes32 registryCode, address identifier, bytes32 name, bytes32 countryCode) {
        var newIssuer = Issuer(registryCode, identifier, name, countryCode);
        issuers[registryCode] = newIssuer;
    }

    function getIssuer(bytes32 registryCode) returns (bytes32, address, bytes32, bytes32) {
        var issuer = issuers[registryCode];
        return (issuer.registryCode, issuer.identifier, issuer.name, issuer.countryCode);
    }

    function createSecurity(bytes32 isin, bytes32 issuerRegistryCode, uint securityTypeIndex, uint nominalValue) {
        var issuer = issuers[issuerRegistryCode];
        var securityType = getSecurityType(securityTypeIndex);
        var security = Security(isin, issuer, securityType, nominalValue);
        securities[isin] = security;
    }

    function getSecurity(bytes32 isin) returns (bytes32, bytes32, uint, uint) {
        var security = securities[isin];
        return (security.isin, security.issuer.registryCode, uint(security.securityType), security.nominalValue);
    }

    function getSecurityType(uint securityTypeIndex) internal returns (SecurityType securityType) {
        if (securityTypeIndex == 0) {
            securityType = SecurityType.DebtInstrument;
        } else if (securityTypeIndex == 1) {
            securityType = SecurityType.FundUnit;
        } else if (securityTypeIndex == 2) {
            securityType = SecurityType.Rights;
        } else if (securityTypeIndex == 3) {
            securityType = SecurityType.Unit;
        }
    }

    function createShareholder(bytes32 registryCode, address identifier) {
        var shareholder = Shareholder(registryCode, identifier);
        shareholders[registryCode] = shareholder;
    }

    function getShareholder(bytes32 registryCode) returns (bytes32, address) {
        var shareholder = shareholders[registryCode];
        return (shareholder.registryCode, shareholder.identifier);
    }

    function emit(bytes32 securityIsin, bytes32 shareholderRegistryCode, uint amount) {
        var security = securities[securityIsin];
        var shareholder = shareholders[shareholderRegistryCode];

        require(isValidEmission(security, shareholder));

        credit(security, shareholder, amount);
    }

    function isValidEmission(Security security, Shareholder shareholder) internal returns (bool) {
        // regulations and emission rules go here
        // eg. is valid shareholder PEP, AML, .. checks
        // eg. is valid security nominal values
        // ...

        require(msg.sender == security.issuer.identifier);

        return true;
    }

    function transfer(
        bytes32 senderRegistryCode, bytes32 receiverRegistryCode,
        bytes32 securityIsin, uint amount) {
        var security = securities[securityIsin];
        var sender = shareholders[senderRegistryCode];
        var receiver = shareholders[receiverRegistryCode];

        require(isValidTransfer(sender, receiver, security, amount));

        debit(security, sender, amount);
        credit(security, receiver, amount);
    }

    function isValidTransfer(
        Shareholder sender, Shareholder receiver, Security security, uint amount
    ) internal returns (bool) {
        // regulations and transfer rules go here
        // eg. is valid sender and receiver and amounts PEP, AML, .. checks
        // eg. is valid security
        // ...

        uint senderBalance = getBalance(sender.registryCode, security.isin);
        require(senderBalance >= amount);
        require(sender.identifier == msg.sender);

        return true;
    }

    function credit(Security security, Shareholder shareholder, uint amount) internal {
        var transaction = Transaction(security, shareholder, amount, TransactionType.Credit);
        transactions.push(transaction);
    }

    function debit(Security security, Shareholder shareholder, uint amount) internal {
        var transaction = Transaction(security, shareholder, amount, TransactionType.Debit);
        transactions.push(transaction);
    }

    function getBalance(bytes32 shareholderRegistryCode, bytes32 securityIsin) returns (uint) {
        uint balance = 0;
        for (uint i = 0; i < transactions.length; i ++) {
            var transaction = transactions[i];

            if (isTransactionFor(transaction, shareholderRegistryCode, securityIsin)) {
                if (transaction.transactionType == TransactionType.Credit) {
                    balance += transaction.amount;
                } else if (transaction.transactionType == TransactionType.Debit) {
                    balance -= transaction.amount;
                }
            }
        }

        return balance;
    }

    function isTransactionFor(
        Transaction transaction, bytes32 shareholderRegistryCode, bytes32 securityIsin) internal returns (bool) {
        return transaction.security.isin == securityIsin &&
            transaction.shareholder.registryCode == shareholderRegistryCode;
    }

}
