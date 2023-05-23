// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
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
        
        shopRates[] rates;
    }

    mapping (address => shopStruct) public shopMapping;
    address[] allShopArray;



    // Users System
    struct userStruct {
        uint id;
        string fcs;

        uint shopNumber;

        string login;
        bytes32 password;

        string role;

        string city;
        uint balance;
    }

    

    mapping (address => userStruct) public userMapping;
    address[] allUsersArray;

    // Constructor
    constructor() {
        shopRates[] memory void;

        shopMapping[0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC] = shopStruct(1, "Saint Petersburg", 100, void);
        shopMapping[0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c] = shopStruct(2, "Dmitrov",          100, void);
        shopMapping[0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C] = shopStruct(3, "Moscow",           100, void);
        shopMapping[0x583031D1113aD414F02576BD6afaBfb302140225] = shopStruct(4, "Arkhangelsk",      100, void);
        shopMapping[0xdD870fA1b7C4700F2BD7f44238821C26f7392148] = shopStruct(5, "Irkutsk",          100, void);

        allShopArray = [
            0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC, 
            0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c, 
            0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C, 
            0x583031D1113aD414F02576BD6afaBfb302140225, 
            0xdD870fA1b7C4700F2BD7f44238821C26f7392148
        ];

        
        userMapping[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = userStruct(0, "Dmitriy Dmitriev Dmitrievuch",       0,    "dimon",    keccak256("adminPassword"),     "admin",     "Kaluga",           100);
        userMapping[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = userStruct(1, "Alexandrova Alexandra Alexandrovna", 3,    "alex",     keccak256("firstPassword"),     "buyer",     "Moscow",           100);
        userMapping[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db] = userStruct(2, "Ruslanov Ruslan Ruslanovich",        0,    "rus",      keccak256("secondPassword"),    "seller",    "Saint Petersburg", 100);

        allUsersArray = [0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db];
    }




    // Admin functionality
    // function changeRole(uint _id, string memory _role, uint _shopNumberOrZero) public {
    //     require(checkOnAdmin(msg.sender) == 1, "u r not admin of this programm");
        
    //     if (keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("seller")) || keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("buyer")) ) {
    //         userMapping[allUsersArray[_id]].role = _role;
    //         if (keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("buyer"))) {
    //             userMapping[allUsersArray[_id]].shopNumber = _shopNumberOrZero;
    //         }
    //     } else {
    //         console.log("Role undefined");
    //     }
    // } 

    // function addNewAdming(address _newAdmin, string memory _newAdmingLogin, uint _newAdmingBalance, string memory _newAdminPassword) public onlyAdmins {
    //     adminMapping[_newAdmin] = Admin(_newAdmingLogin, _newAdmingBalance, _newAdminPassword);
    //     allAdmins.push(_newAdmin);
    // }

    // function addNewShop(address _newShopAddress, string memory _newShopCity, uint _newShopBalance, uint _newShopper) public onlyAdmins {
        // shopMapping[_newShopAddress] = shopStruct((allShopArray.length + 1), _newShopCity, _newShopBalance);
        // allShopArray.push(_newShopAddress); 

        // shopRates[] memory void;

        // shopMapping[_newShopAddress] = shopStruct((allShopArray.length + 1), _newShopCity, _newShopBalance, void);

        // changeRole(_newShopper, "buyer", allShopArray.length);
    // }

    // function deleteShop (address _shopAddress) public onlyAdmins {
    //     for (uint index = 0; index < allUsersArray.length; index++) {
    //         if (userMapping[allUsersArray[index]].shopNumber == getShopNumber(_shopAddress)) {
    //             userMapping[allUsersArray[index]].shopNumber = 0;
    //             changeRole(index, "seller", 0);
    //         }
    //     }

    //     shopMapping[_shopAddress] = shopStruct(0, "null", 0);
    //     delete allShopArray[getShopNumber(_shopAddress)];
    // }

































    // System Functions For Checks
    modifier onlyAdmins() {
        uint flag = 0;

        if (keccak256(abi.encodePacked(userMapping[msg.sender].role)) == keccak256(abi.encodePacked("admin"))) {
            flag = 1;
        }
        
        require(flag == 1, "u r not admin of this programm"); 
        _;
    }
        

    // function checkOnAdmin(address _itsadmin) internal  returns (uint) {
    //     uint flag = 0;

    //     for (uint index = 0; index < allAdmins.length; index++) {
    //         if (allAdmins[index] == _itsadmin) {
    //             flag = 1;
    //         }
    //     }

    //     return flag;
    // }

    // function getShopNumber(address _shopAddress) internal returns (uint) {
    //     uint number;

    //     for (uint index = 0; index < allShopArray.length; index++) {
    //         if (_shopAddress == allShopArray[index]) {
    //             number = shopMapping[allShopArray[index]].number;
    //         }
    //     }

    //     return number;
    // }

    // System Functions For TESTING
    // function logAllShops() public {
    //     for (uint index = 0; index < allShopArray.length + 1; index++) {
    //         console.log(shopMapping[allShopArray[index]].number, shopMapping[allShopArray[index]].city, shopMapping[allShopArray[index]].balance);
    //     }
    // }

    // function logAllRoles() public  {
    //     for (uint index = 0; index < allUsersArray.length; index++) {
    //         console.log(userMapping[allUsersArray[index]].id, userMapping[allUsersArray[index]].role);
    //     }
    // }
}
