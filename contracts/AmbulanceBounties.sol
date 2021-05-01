pragma solidity ^0.7.0;

// SPDX-License-Identifier: UNLICENSED

contract AmbulanceBounties {
    
    // 30 second long bid window for ambulances to place their bids (for testing)
    uint constant BID_PERIOD_LENGTH = 30;
    // 30 second long reveal window for ambulances to verify their bids (for testing)
    uint constant REVEAL_PERIOD_LENGTH = 30;
    
    // Required length for the salt used in hashing bids
    uint constant SALT_LENGTH = 10;
    
    uint256 constant MAX_INT = 2**256 - 1;
    
    
    address admin;
    
    // We map addresses to their permissions. If an address maps to true, that means it is verified as that role.
    // Using a mapping instead of an array for these roles gives us O(1) insertion, deletion, and lookup since we can simply set the value to false to remove them.
    // However, we cannot get a list of all keys in the mapping without also storing an array of the keys. If this is necessary, then we
    // should abandon the mapping idea.
    mapping(address => bool) ambulances;
    mapping(address => bool) policeStations;
    mapping(address => bool) hospitals;
    
    // Closed is the first option in the enum so that it is the default option
    enum BountyStatus {Closed, InProgress, Open}
    
    struct Bounty {
        address payable bountyPoster;
        address payable bountyAccepter;
        BountyStatus status;
        
        uint postDate;
        uint dueDate;
        // Should be a string that represents the coordinates of the patient, compliant with ISO 6709
        string location;
        address[] allowedHospitals;
        
        uint maxBid;
        uint penalty;
        
        // Maps an address to its bid. This enforces one bid per address, so that ambulances do not just bid as many prices as they can, and then reveal lower and lower bids during the reveal period.
        // We use 2 arrays because we can't have nested mappings in Solidity.
        address[] bidders;
        bytes32[] hashedBids;
        
        uint finalBid;
        
    }
    
    // Note: We maintain an array so that we can see all bounties, and a mapping for fast bounty information lookup
    // The string is the "ID" of the bounty, and the Bounty object is the actual object. Together, these two data structures form something like a Set data structure.
    string[] public bounties;
    mapping(string => Bounty) public bountyMapping;
    
    constructor() {
        admin = msg.sender;
    }
    
    // constructor(address[] memory a, address[] memory p, address[] memory h) {
    //     admin = msg.sender;
        
    //     for (uint i = 0; i < a.length; i++) {
    //         ambulances[a[i]] = true;
    //     }
        
    //     for (uint i = 0; i < p.length; i++) {
    //         policeStations[p[i]] = true;
    //     }
        
    //     for (uint i = 0; i < h.length; i++) {
    //         hospitals[h[i]] = true;
    //     }
        
    // }
   string greeting = 'Hello World';
    function greet() public view returns (string memory) {
      
      return greeting;
    }
    
    // timeLimit is how long the ambulances have to deliver the patient, not including bid and reveal times.
    function postBounty (string memory hash, uint timeLimit, string memory location, address[] memory allowedHospitals, uint penalty) public payable  {
        require(policeStations[msg.sender]);
        require(msg.value > 0);
        for (uint i = 0; i < allowedHospitals.length; i++) {
            require(hospitals[allowedHospitals[i]]);
        }
        
        
        // The reason we make a new object has something to do with Solidity and how it treats the memory keyword
        Bounty memory newBounty;
        newBounty.bountyPoster = msg.sender;
        newBounty.status = BountyStatus.Open;
        newBounty.postDate = block.timestamp;
        newBounty.dueDate = block.timestamp + BID_PERIOD_LENGTH + REVEAL_PERIOD_LENGTH + timeLimit;
        newBounty.location = location;
        newBounty.allowedHospitals = allowedHospitals;
        newBounty.maxBid = msg.value;
        newBounty.penalty = penalty;
        newBounty.finalBid = MAX_INT;
        
        bounties.push(hash);
        bountyMapping[hash] = newBounty;
        
    }
    
    // Unfortunately, we force the ambulances to iterate over the whole list of bidders when they want to bid.
    // This can be fixed by not storing all of the bounty information on the blockchain.
    // The hashed amount should be an amount in wei + a 10 digit salt. Note that if the bounty is hashed with a salt that is not 10 digits long, the bid will be invalid.
    // This value should then be encoded from a string to a hex value using abi.encode, and then passed through the keccak256 hash function (hex input)
    function bid (string memory hash, bytes32 hashedAmount) public returns (uint index) {
        require(ambulances[msg.sender], "Sender not authorized");
        require(bountyMapping[hash].status == BountyStatus.Open, "This bounty is not open");
        require(block.timestamp < bountyMapping[hash].postDate + BID_PERIOD_LENGTH, "The bidding period is over");
        require(!contains(bountyMapping[hash].bidders, msg.sender), "Sender has already submitted a bid");

        bountyMapping[hash].bidders.push(msg.sender);
        bountyMapping[hash].hashedBids.push(hashedAmount);
        return bountyMapping[hash].bidders.length - 1;
    }
    
    
    // We can make this payable and add a penalty or something later
    // Currently, if two ambulances made the same bid, the one that reveals its bid first will win
    function revealBid (string memory hash, uint bidValue, uint salt, uint index) public payable {
        // Sender must be ambulance
        require(ambulances[msg.sender], "Sender not authorized");
        // Must be in the reveal period
        require(block.timestamp < bountyMapping[hash].postDate + BID_PERIOD_LENGTH + REVEAL_PERIOD_LENGTH, "The reveal period is over");
        require(block.timestamp >= bountyMapping[hash].postDate + BID_PERIOD_LENGTH, "The reveal period has not yet started");
        // Bounty must be open (i.e. not retracted)
        require(bountyMapping[hash].status == BountyStatus.Open, "This bounty is not open");
        // Bid must be less than the current lowest bid
        require(bidValue < bountyMapping[hash].finalBid, "This bid is too high");
        // Bid must be less than the current lowest bid
        require(bidValue < bountyMapping[hash].maxBid, "This bid is too high");
        // Revealer must provide the correct id for the bidder list
        require(msg.sender == bountyMapping[hash].bidders[index], "Wrong index in bidder list");
        
        // Sender must pay the penalty amount to reveal the bid, which will be refunded on job completion
        require(bountyMapping[hash].penalty == msg.value, "Paid amount is not equal to the required penalty amount");
        // Salt must be 10 digits long
        require(bytes(uint2str(salt)).length == SALT_LENGTH, "Salt is not the correct length");
        // Hashed bid must match the bid value.
        // 0x + keccak256 of the abi.encoded value is what the client should pass as the hashed bid. For the bidvalue, they can just pass regular (unpadded) wei values
        require(bountyMapping[hash].hashedBids[index] == keccak256(abi.encode(append(uint2str(bidValue), uint2str(salt)))), "The bid value does not match the hash");
        
        Bounty storage referencedBounty = bountyMapping[hash];
        
        // If we already assigned someone to take the job earlier in the reveal period, refund that ambulance's penalty since they no longer have the job
        if (referencedBounty.bountyAccepter != address(0)) {
            referencedBounty.bountyAccepter.transfer(bountyMapping[hash].penalty);
        }
        
        referencedBounty.status = BountyStatus.InProgress;
        referencedBounty.bountyAccepter = msg.sender;
        referencedBounty.finalBid = bidValue;
        
        bountyMapping[hash] = referencedBounty;
        
    }
    
    
    function verifyDelivery (string memory hash) public {
        require(hospitals[msg.sender], "Sender not authorized");
        require(bountyMapping[hash].status == BountyStatus.InProgress, "Bounty not in progress");
        require(block.timestamp > bountyMapping[hash].postDate + BID_PERIOD_LENGTH + REVEAL_PERIOD_LENGTH, "Bounty is not ready to be claimed yet");
        require(block.timestamp < bountyMapping[hash].dueDate, "Bounty has expired");
        require(contains(bountyMapping[hash].allowedHospitals, msg.sender));
        
        bountyMapping[hash].bountyAccepter.transfer(bountyMapping[hash].finalBid + bountyMapping[hash].penalty);
        
        if (bountyMapping[hash].maxBid - bountyMapping[hash].finalBid > 0) {
            bountyMapping[hash].bountyPoster.transfer(bountyMapping[hash].maxBid - bountyMapping[hash].finalBid);
        }
        
        Bounty storage referencedBounty = bountyMapping[hash];
        
        referencedBounty.status = BountyStatus.Closed;
        
        bountyMapping[hash] = referencedBounty;
        
        removeBounty(hash);
    }
    
    // Allows police stations to reclaim their funds + the penalty for failed jobs
    function reclaimBounty(string memory hash) public {
        require(bountyMapping[hash].bountyPoster == msg.sender);
        require(bountyMapping[hash].status == BountyStatus.InProgress);
        require(bountyMapping[hash].bountyAccepter != address(0));
        require(bountyMapping[hash].dueDate > block.timestamp);
        
        bountyMapping[hash].bountyPoster.transfer(bountyMapping[hash].maxBid + bountyMapping[hash].penalty);
        
        
        removeBounty(hash);
    }
    
    
    function retractBounty (string memory hash) public {
        require(msg.sender == bountyMapping[hash].bountyPoster);
        require(bountyMapping[hash].status == BountyStatus.Open);
        
        bountyMapping[hash].bountyPoster.transfer(bountyMapping[hash].maxBid);
        
        removeBounty(hash);
    }
    
    
    function removeBounty (string memory hash) private {
        // Delete doesn't preserve order, but we can at the cost of more processing
        for (uint i = 0; i < bounties.length; i++) {
            // Comparing the strings
            if (keccak256(abi.encode(bounties[i])) == keccak256(abi.encode(hash))) {
                bounties[i] = bounties[bounties.length - 1];
                bounties.pop();
            }
        }
        
        // If we can assume that the bounty ids (the hashes that go into bountyMapping) are properly generated,
        // we don't have to delete any data from the bountyMapping
    }
    
    
    // Allows the admin to add verified ambulances
    function addAmbulance (address ambulance) public {
        require(msg.sender == admin);
        require(ambulances[ambulance] != true);
        ambulances[ambulance] = true;
    }
    
    // Allows the admin to remove verified ambulances
    function removeAmbulance (address ambulance) public {
        require(msg.sender == admin);
        require(ambulances[ambulance] != false);
        ambulances[ambulance] = false;
    }
    
    // Allows the admin to add verified police stations
    function addPolice (address police) public {
        require(msg.sender == admin);
        require(policeStations[police] != true);
        policeStations[police] = true;
    }
    
    // Allows the admin to remove verified police stations
    function removePolice (address police) public {
        require(msg.sender == admin);
        require(policeStations[police] != false);
        policeStations[police] = false;
    }
    
    // Allows the admin to add verified hospitals
    function addHospital (address hospital) public {
        require(msg.sender == admin);
        require(hospitals[hospital] != true);
        hospitals[hospital] = true;
    }
    
    // Allows the admin to remove verified hospitals
    function removeHospital (address hospital) public {
        require(msg.sender == admin);
        require(hospitals[hospital] != false);
        hospitals[hospital] = false;
    }
    
    
    // This sucks, but it's one of the consequences of storing everything on the blockchain
    function contains (address[] memory addresses, address addressToFind) private pure returns (bool doesContain) {
        for (uint i = 0; i < addresses.length; i++) {
            if (addresses[i] == addressToFind) {
                return true;
            }
        }
        return false;
    }
    
    
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
    
    function append(string memory a, string memory b) internal pure returns (string memory) {

        return string(abi.encodePacked(a, b));

    }
    
}