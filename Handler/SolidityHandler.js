import { memo } from 'react';
import { ambulanceAbi } from './abi/abis';
const web3 = new Web3(Web3.givenProvider);
export const { ambulanceAddress } = " 0xcf52F95F272Ba974032826da2EA600Be3FE0713a";
const SimpleContract = new web3.eth.Contract(ambulanceAbi, contractAddr);

//Address is a string type
//No return value
//only admin can access
export function addHospital(address) {
    SimpleContract.methods.addHospital(address).send();
}

//Address is a string type
//No return value
//only admin can access
export function removeHospital(address) {
    SimpleContract.methods.removeHospital(address).send();
}
//Address is a string type
//No return value
//only admin can access
export function addPolice(address) {
    SimpleContract.methods.addPolice(address).send();
}

//Address is a string type
//No return value
//only admin can access
export function removePolice(address) {
    SimpleContract.methods.addPolice(address).send();
}

//Address is a string type
//No return value
//only admin can access
export function addAmbulance(address) {
    SimpleContract.methods.addAmbulance(TextInputValue).send();
}

//Address is a string type
//No return value
//only admin can access
export function removeAmbulance(address) {
    SimpleContract.methods.removeAmbulance(TextInputValue).send();
}

//Address is a string type
//No return value
//only admin can access
export function verifyDelivery(address) {
    SimpleContract.methods.verifyDelivery(memoryHashString).send();
}

//MemoryhashString is a string that takes in a location within the array (will ask patrick more about this)
//Timelimit is an integer time limit (do not know units, will need to ask Patrick)
//location is a string that represent the coordinates of the patient i.e. standard coordinates found in gps
//allowedHospitalList is an array of allowed hospitals (addresses)
//Penalty price is the numerical price of an undelivered or over time limit patient
//No return value
//Only police can access
export function postBounty(memoryHashString, timeLimit, memoryLocationString, allowedHospitalsList, penaltyPrice) {
    AmbulanceBounties.methods.postBounty(memoryHashString, timeLimit, memoryLocationString, allowedHospitalsList, penal).send;
}


//memoryHash is a string that takes in an address within the array (will ask patrick more about this) 
//Only police can access this
export function reclaimBounty(memoryHash) {
    AmbulanceBounties.methods.reclaimBounty(memoryHash).send();
}


//hashedBidAmount is wei + a 10 digit salt 
//memoryHash is a string that takes in an address within the array (will ask patrick more about this) 
//Only ambulances can access this
export function bid(memoryHash, hashedBidAmount) {
    AmbulanceBounties.methods.bid(memoryHash, hashedBidAmount).send();
}

//memoryHash is a string that takes in an address within the array (will ask patrick more about this)
//bidValue is value of bid in wei numerical
//salt is the salt value of the bid numerical
//index is the location of the bid in the array
export function revealBid(memoryHash, bidValue, salt, index) {
    AmbulanceBounties.methods.revealBid(memoryHash, bidValue, salt, index).send();
}



