//Can change names later on
//Can edit files for more specifics later

const AmbulanceBounties = artifacts.require("./AmbulanceBounties.sol");

module.exports = function(deployer) {

        deployer.deploy(AmbulanceBounties);
};