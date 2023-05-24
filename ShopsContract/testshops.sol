// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.22 < 0.9.0;
pragma experimental ABIEncoderV2;


import "hardhat/console.sol";

/**
 * @title Owner
 * @dev Set & change owner
 */

contract Shops {
    // Shops System
    struct shopRates {
        uint userId;
        uint rateId;

        uint shopNumber;
        uint shopRate;
        string rateComment;
    }

    struct shopStruct {
        uint number;
        string city;
        uint balance;

        uint[] sellers_ids;
    }

    mapping (address => shopStruct) public shopMapping;
    address[] allShopArray;



    // Users System
    struct userStruct {
        uint id;
        string fcs;

        string login;
        bytes32 password;

        string role;

        string city;
        uint balance;

        uint[] userRequests;
    }

    

    mapping (address => userStruct) public userMapping;
    address[] allUsersArray;

    // Constructor
    constructor() {
        uint[] memory void;

        shopMapping[0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC] = shopStruct(1,     "Saint Petersburg",     100, void);
        shopMapping[0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c] = shopStruct(2,     "Dmitrov",              100, void);
        shopMapping[0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C] = shopStruct(3,     "Moscow",               100, void);
        shopMapping[0x583031D1113aD414F02576BD6afaBfb302140225] = shopStruct(4,     "Arkhangelsk",          100, void);
        shopMapping[0xdD870fA1b7C4700F2BD7f44238821C26f7392148] = shopStruct(5,     "Irkutsk",              100, void);

        shopMapping[0xdD870fA1b7C4700F2BD7f44238821C26f7392148].sellers_ids = [1];

        allShopArray = [
            0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC, 
            0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c, 
            0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C, 
            0x583031D1113aD414F02576BD6afaBfb302140225, 
            0xdD870fA1b7C4700F2BD7f44238821C26f7392148
        ];

        
        userMapping[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = userStruct(0, "Dmitriy Dmitriev Dmitrievuch",          "dimon",    keccak256("adminPassword"),     "admin",     "Kaluga",           100, void);
        userMapping[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = userStruct(1, "Alexandrova Alexandra Alexandrovna",    "alex",     keccak256("firstPassword"),     "buyer",     "Moscow",           100, void);
        userMapping[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db] = userStruct(2, "Ruslanov Ruslan Ruslanovich",           "rus",      keccak256("secondPassword"),    "seller",    "Saint Petersburg", 100, void);

        allUsersArray = [0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db];
   
        allRequests.push(0);
    }



    // Requests
    struct requestForm {
        uint requestId;
        uint userId;

        string roleToRequest;
        bool requestIsOpen;
    }

    mapping (address => requestForm[]) public requestMapping;
    address[] allRequestsOwners;
    uint[] allRequests;

    function requestForSeller() public onlyBuyers { requestAdd("seller"); }
    function requestForBuyer() public onlySellers { 
        // Input for something shop
        // TODO
        
        
        requestAdd("buyer"); 
        }
    function requestForAdmin() public notAdmin { requestAdd("admin"); }

    function requestAdd(string memory _requestRole) internal {
        uint id = allRequests.length;

        requestMapping[msg.sender].push(requestForm(id, getUserIdForAddress(msg.sender), _requestRole, true));
        userMapping[msg.sender].userRequests.push(id);
        if (checkAlreadyHadRequest(msg.sender) == 0) {allRequestsOwners.push(msg.sender);}
        allRequests.push(id);
    }

    function clearRequest(uint _requestId) internal  {
        for (uint index = 0; index < allRequestsOwners.length; index++) {
            for (uint j = 0; j < userMapping[allRequestsOwners[index]].userRequests.length; j++) {
                if (userMapping[allRequestsOwners[index]].userRequests[j] == _requestId) {
                    requestMapping[allRequestsOwners[index]][_requestId].requestIsOpen == false;
                }
            }
        }
    }

    ////// Admin functionality

    function roleRequestAccept(uint _requestId) public onlyAdmins {
        for (uint index = 0; index < allRequestsOwners.length; index++) {
            for (uint j = 0; j < userMapping[allRequestsOwners[index]].userRequests.length; j++) {
                if (userMapping[allRequestsOwners[index]].userRequests[j] == _requestId) {
                    if (requestMapping[allRequestsOwners[index]][_requestId].requestIsOpen == false) {
                        console.log("This request already closed!");
                    } else {
                        requestMapping[allRequestsOwners[index]][_requestId].requestIsOpen == false;

                        changeRole(requestMapping[allRequestsOwners[index]][_requestId].userId, requestMapping[allRequestsOwners[index]][_requestId].roleToRequest);
                    }
                }
            }
        }
    }

    function roleRequestClose(uint _requestId) public onlyAdmins {
        for (uint index = 0; index < allRequestsOwners.length; index++) {
            for (uint j = 0; j < userMapping[allRequestsOwners[index]].userRequests.length; j++) {
                if (userMapping[allRequestsOwners[index]].userRequests[j] == _requestId) {
                    if (requestMapping[allRequestsOwners[index]][_requestId].requestIsOpen == false) {
                        console.log("This request already closed!");
                    } else {
                        requestMapping[allRequestsOwners[index]][_requestId].requestIsOpen == false;
                    }
                }
            }
        }
    }

    function changeRole(uint _userId, string memory _role) internal {
        userMapping[allUsersArray[_userId]].role = _role;
    }

    // Shop Management
    function addNewShop(address _shopAddress, string memory _city) public onlyAdmins {
        uint[] memory void;

        shopMapping[_shopAddress] = shopStruct(allShopArray.length, _city, 100, void);
        allShopArray.push(_shopAddress);
    }

    function deleteShop(uint _id) public onlyAdmins {
        uint[] memory void;

        for (uint index = 0; index < shopMapping[allShopArray[_id]].sellers_ids.length; index++) {
            changeRole(shopMapping[allShopArray[_id]].sellers_ids[index], "seller");
        }

        shopMapping[allShopArray[_id]].number = 0;
        shopMapping[allShopArray[_id]].city = "None";
        shopMapping[allShopArray[_id]].balance = 0;
        shopMapping[allShopArray[_id]].sellers_ids = void;

        delete allShopArray[_id];
    }


    // System Functionaliti
    modifier onlyAdmins() {
        uint flag = 0;

        if (keccak256(abi.encodePacked(userMapping[msg.sender].role)) == keccak256(abi.encodePacked("admin"))) {
            flag = 1;
        }
        
        require(flag == 1, "u r not admin of this programm"); 
        _;
    }

    modifier notAdmin() {
        uint flag = 0;

        if (keccak256(abi.encodePacked(userMapping[msg.sender].role)) != keccak256(abi.encodePacked("admin"))) {
            flag = 1;
        }
        
        require(flag == 1, "u r also admin of this programm"); 
        _;
    }

    modifier onlySellers() {
        uint flag = 0;

        if (keccak256(abi.encodePacked(userMapping[msg.sender].role)) == keccak256(abi.encodePacked("seller"))) {
            flag = 1;
        }
        
        require(flag == 1, "u r not seller of this programm"); 
        _;
    }

    modifier onlyBuyers() {
        uint flag = 0;

        if (keccak256(abi.encodePacked(userMapping[msg.sender].role)) == keccak256(abi.encodePacked("buyer"))) {
            flag = 1;
        }
        
        require(flag == 1, "u r not buyer of this programm"); 
        _;
    }

    modifier requestNotClosed() {
        // TODO
        _;
    }


    function getUserIdForAddress(address _userAddress) internal returns (uint) {
        for (uint index = 0; index < allUsersArray.length; index++) {
            if (allUsersArray[index] == _userAddress) {
                return userMapping[allUsersArray[index]].id;
            }
        }
    }

    function getUserAddressForId(uint _userId) internal returns (address) {
        for (uint index = 0; index < allUsersArray.length; index++) {
            if (userMapping[allUsersArray[index]].id == _userId) {
                console.log(allUsersArray[index]);
                return allUsersArray[index];
            }
        }
    }

    function checkAlreadyHadRequest(address _userAddress) internal returns (uint) {
        for (uint index = 0; index < allRequestsOwners.length; index++) {
            if (_userAddress == allRequestsOwners[index]) {
                return 1;
            } else {return 0;}
        }
    }
}
