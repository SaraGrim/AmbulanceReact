export const ambulanceAbi = [
    {
        "inputs": [],
        "stateMutability": "nonpayable",
        "type": "constructor"
    },
    {
        "inputs": [
            {
                "internalType": "uint256",
                "name": "",
                "type": "uint256"
            }
        ],
        "name": "bounties",
        "outputs": [
            {
                "internalType": "string",
                "name": "",
                "type": "string"
            }
        ],
        "stateMutability": "view",
        "type": "function",
        "constant": true
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "",
                "type": "string"
            }
        ],
        "name": "bountyMapping",
        "outputs": [
            {
                "internalType": "address payable",
                "name": "bountyPoster",
                "type": "address"
            },
            {
                "internalType": "address payable",
                "name": "bountyAccepter",
                "type": "address"
            },
            {
                "internalType": "enum AmbulanceBounties.BountyStatus",
                "name": "status",
                "type": "uint8"
            },
            {
                "internalType": "uint256",
                "name": "postDate",
                "type": "uint256"
            },
            {
                "internalType": "uint256",
                "name": "dueDate",
                "type": "uint256"
            },
            {
                "internalType": "string",
                "name": "location",
                "type": "string"
            },
            {
                "internalType": "uint256",
                "name": "maxBid",
                "type": "uint256"
            },
            {
                "internalType": "uint256",
                "name": "penalty",
                "type": "uint256"
            },
            {
                "internalType": "uint256",
                "name": "finalBid",
                "type": "uint256"
            }
        ],
        "stateMutability": "view",
        "type": "function",
        "constant": true
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "hash",
                "type": "string"
            },
            {
                "internalType": "uint256",
                "name": "timeLimit",
                "type": "uint256"
            },
            {
                "internalType": "string",
                "name": "location",
                "type": "string"
            },
            {
                "internalType": "address[]",
                "name": "allowedHospitals",
                "type": "address[]"
            },
            {
                "internalType": "uint256",
                "name": "penalty",
                "type": "uint256"
            }
        ],
        "name": "postBounty",
        "outputs": [],
        "stateMutability": "payable",
        "type": "function",
        "payable": true
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "hash",
                "type": "string"
            },
            {
                "internalType": "bytes32",
                "name": "hashedAmount",
                "type": "bytes32"
            }
        ],
        "name": "bid",
        "outputs": [
            {
                "internalType": "uint256",
                "name": "index",
                "type": "uint256"
            }
        ],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "hash",
                "type": "string"
            },
            {
                "internalType": "uint256",
                "name": "bidValue",
                "type": "uint256"
            },
            {
                "internalType": "uint256",
                "name": "salt",
                "type": "uint256"
            },
            {
                "internalType": "uint256",
                "name": "index",
                "type": "uint256"
            }
        ],
        "name": "revealBid",
        "outputs": [],
        "stateMutability": "payable",
        "type": "function",
        "payable": true
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "hash",
                "type": "string"
            }
        ],
        "name": "verifyDelivery",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "hash",
                "type": "string"
            }
        ],
        "name": "reclaimBounty",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "hash",
                "type": "string"
            }
        ],
        "name": "retractBounty",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "ambulance",
                "type": "address"
            }
        ],
        "name": "addAmbulance",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "ambulance",
                "type": "address"
            }
        ],
        "name": "removeAmbulance",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "police",
                "type": "address"
            }
        ],
        "name": "addPolice",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "police",
                "type": "address"
            }
        ],
        "name": "removePolice",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "hospital",
                "type": "address"
            }
        ],
        "name": "addHospital",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "hospital",
                "type": "address"
            }
        ],
        "name": "removeHospital",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
]
