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
        bytes32 issuerRegistryCode = "232342";
        createSampleIssuer(issuerRegistryCode);

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

    function testIssuersCanEmitSecurities() {
        // create an issuer and a security
        bytes32 issuerRegistryCode = "15523";
        bytes32 securityIsin = "some isin";
        createSampleIssuerAndSecurity(issuerRegistryCode, securityIsin);

        // create a shareholder
        bytes32 shareholderRegistryCode = "38012121204";
        //random sample key
        address shareholderBlockchainKey = 0xa2fa50238e4e8654530f23349ce17b8487a12dcb;

        securitiesDepository.createShareholder(shareholderRegistryCode, shareholderBlockchainKey);

        uint emitAmount = 200000;

        //emit a security
        securitiesDepository.emit(securityIsin, shareholderRegistryCode, emitAmount);

        uint balance = securitiesDepository.getBalance(shareholderRegistryCode, securityIsin);
        Assert.equal(balance, emitAmount, "Security emitting is equal to transaction balance");
    }

// TODO: function testIssuersCanOnlyEmitTheirOwnSecurities() {

    function testShareholderCanTransferSecurities() {
        // create an issuer and a security
        bytes32 issuerRegistryCode = "152232";
        bytes32 securityIsin = "ISIN1234";
        createSampleIssuerAndSecurity(issuerRegistryCode, securityIsin);

        // create shareholder Alice
        bytes32 shareholderAliceRegistryCode = "48012121204";
        address shareholderAliceBlockchainKey = this; // Alice keys is current contract key
        securitiesDepository.createShareholder(shareholderAliceRegistryCode, shareholderAliceBlockchainKey);

        // emit 200000 security to Alice
        uint emitAmount = 200000;
        securitiesDepository.emit(securityIsin, shareholderAliceRegistryCode, emitAmount);

        // create shareholder Bob
        bytes32 shareholderBobRegistryCode = "39010101204";
        address shareholderBobBlockchainKey = 0xaeac7a0f35badde60af79b72c3e4e100ea286a15; // random sample
        securitiesDepository.createShareholder(shareholderBobRegistryCode, shareholderBobBlockchainKey);

        // Alice transfers some securities to Bob
        securitiesDepository.transfer(
            shareholderAliceRegistryCode, shareholderBobRegistryCode,
            securityIsin, 100000
        );

        // check that Alice and Bob balances correspond
        uint aliceBalance = securitiesDepository.getBalance(shareholderAliceRegistryCode, securityIsin);
        uint bobBalance = securitiesDepository.getBalance(shareholderBobRegistryCode, securityIsin);
        Assert.equal(aliceBalance, 100000, "Transfering securities debits sender");
        Assert.equal(bobBalance, 100000, "Transfering securities debits receiver");
    }

    // TODO: function testShareholderCanTransferOnleyTheirOwnSecurities() {

    function createSampleIssuer(bytes32 issuerRegistryCode) {
        bytes32 issuerName = "Producement";
        bytes32 issuerCountry = "EE";
        address issuerBlockchainKey = this;
        securitiesDepository.createIssuer(issuerRegistryCode, issuerBlockchainKey, issuerName, issuerCountry);
    }

    function createSampleIssuerAndSecurity(bytes32 issuerRegistryCode, bytes32 securityIsin) {
        createSampleIssuer(issuerRegistryCode);
        uint securityTypeIndex = 2;
        uint nominalValue = 12;
        securitiesDepository.createSecurity(securityIsin, issuerRegistryCode, securityTypeIndex, nominalValue);
    }

}
