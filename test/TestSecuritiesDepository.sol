pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SecuritiesDepository.sol";

contract TestSecuritiesDepository {

    SecuritiesDepository securitiesDepository = SecuritiesDepository(DeployedAddresses.SecuritiesDepository());

    function testCreatingAndReadingAnIssuer() {
        bytes32 issuerName = "Producement";
        address issuerBlockchainKey = tx.origin;
        bytes32 issuerRegistryCode = "12345";
        bytes32 issuerCountry = "EE";

        securitiesDepository.createIssuer(issuerRegistryCode, issuerBlockchainKey, issuerName, issuerCountry);

        var (createdIssuerRegistryCode, createdIssuerBlockchainKey, createdIssuerName, createdIssuerCountryCode) =
            securitiesDepository.getIssuer(issuerRegistryCode);

        Assert.equal(createdIssuerRegistryCode, issuerRegistryCode, "Issuer registry code is correct");
        Assert.equal(createdIssuerBlockchainKey, issuerBlockchainKey, "Issuer blockchain key is correct");
        Assert.equal(createdIssuerName, issuerName, "Issuer name is correct");
        Assert.equal(createdIssuerCountryCode, issuerCountry, "Issuer country code is correct");
    }

    function testCreatingAndReadingASecurity() {
        // create an issuer
        bytes32 issuerName = "Producement";
        bytes32 issuerRegistryCode = "38012121202";
        bytes32 issuerCountry = "EE";
        address issuerBlockchainKey = tx.origin;
        securitiesDepository.createIssuer(issuerRegistryCode, issuerBlockchainKey, issuerName, issuerCountry);

        // create a security
        bytes32 isin = "some isin";
        uint securityTypeIndex = 2;
        uint nominalValue = 12;

        securitiesDepository.createSecurity(isin, issuerRegistryCode, securityTypeIndex, nominalValue);

        var (createdSecurityIsin, createdSecurityIssuerRegistryCode,
            createdSecurityTypeIndex, createdSecurityNominalValue) = securitiesDepository.getSecurity(isin);

        Assert.equal(isin, createdSecurityIsin, "Security isin is correct");
        Assert.equal(issuerRegistryCode, createdSecurityIssuerRegistryCode, "Security issuer is correct");
        Assert.equal(securityTypeIndex, createdSecurityTypeIndex, "Security type is correct");
        Assert.equal(nominalValue, createdSecurityNominalValue, "Security nominal value is correct");
    }

    function testCreatingAndReadingAShareholder() {
        bytes32 shareholderRegistryCode = "38012121202";
        address shareholderBlockchainKey = tx.origin;

        securitiesDepository.createShareholder(shareholderRegistryCode, shareholderBlockchainKey);

        var (createdShareholderRegistryCode, createdShareholderBlockchainKey) =
            securitiesDepository.getShareholder(shareholderRegistryCode);

        Assert.equal(shareholderRegistryCode, createdShareholderRegistryCode, "Shareholder registry code is correct");
        Assert.equal(shareholderBlockchainKey, createdShareholderBlockchainKey, "Shareholder blockchain key is correct");

    }

    function testEmittingSecurities() {
        address account = this;

        // create an issuer
        bytes32 issuerName = "Producement";
        bytes32 issuerRegistryCode = "38012121203";
        bytes32 issuerCountry = "EE";
        address issuerBlockchainKey = account;
        securitiesDepository.createIssuer(issuerRegistryCode, issuerBlockchainKey, issuerName, issuerCountry);

        // create a security
        bytes32 securityIsin = "some isin";
        uint securityTypeIndex = 2;
        uint nominalValue = 12;
        securitiesDepository.createSecurity(securityIsin, issuerRegistryCode, securityTypeIndex, nominalValue);

        // create a shareholder
        bytes32 shareholderRegistryCode = "38012121204";
        address shareholderBlockchainKey = account;

        securitiesDepository.createShareholder(shareholderRegistryCode, shareholderBlockchainKey);

        uint emitAmount = 200000;

        //emit a security
        securitiesDepository.emit(securityIsin, shareholderRegistryCode, emitAmount);


        uint transactionCount = securitiesDepository.transactionCount(securityIsin);
        Assert.equal(transactionCount, uint(1), "Security emitting transaction is present");
    }



}
