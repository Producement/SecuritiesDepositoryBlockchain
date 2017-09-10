var SecuritiesDepository = artifacts.require("./SecuritiesDepository.sol");

module.exports = function(deployer) {
  deployer.deploy(SecuritiesDepository);
};
