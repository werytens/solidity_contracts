// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";

/**
 * @title Owner
 * @dev Set & change owner
 */

contract Shops {

    struct Admin {
        string login;
        uint balance;
        string password; 
    }

    mapping (address => Admin) public adminMapping;
    address[] allAdmins;


    // Shops System
    struct shopStruct {
        uint number;
        string city;
        uint balance;
    }

    mapping (address => shopStruct) public shopMapping;
    address[] allShopArray;



    // Users System
    struct userStruct {
        uint id;
        string fcs;

        uint shopNumber;

        string loggin;
        string password;

        string role;

        string city;
        uint balance;
    }

    struct shopRates {
        uint userId;
        uint rateId;

        uint shopNumber;
        uint shopRate;
        string rateComment;
    }

    mapping (address => userStruct) public userMapping;
    mapping (uint => shopRates) public rateMapping;

    address[] allUsersArray;
    uint[] allRatesArray;



    // Constructor
    constructor() {
        adminMapping[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = Admin("dimon", 500, "aboba337");
        allAdmins.push(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);

        shopMapping[0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC] = shopStruct(1, "Saint Petersburg", 1500);
        shopMapping[0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c] = shopStruct(2, "Dmitrov", 400);
        shopMapping[0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C] = shopStruct(3, "Moscow", 1400);
        shopMapping[0x583031D1113aD414F02576BD6afaBfb302140225] = shopStruct(4, "Arkhangelsk", 900);
        shopMapping[0xdD870fA1b7C4700F2BD7f44238821C26f7392148] = shopStruct(5, "Irkutsk", 1000);

        allShopArray = [
            0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC, 
            0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c, 
            0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C, 
            0x583031D1113aD414F02576BD6afaBfb302140225, 
            0xdD870fA1b7C4700F2BD7f44238821C26f7392148
        ];

        

        userMapping[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = userStruct(0, "Alexandrova Alexandra Alexandrovna", 3, "alex", "first", "buyer", "Moscow", 150);
        userMapping[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db] = userStruct(1, "Ruslanov Ruslan Ruslanovich", 0, "rus", "second", "seller", "Saint Petersburg", 70);

        allUsersArray = [0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db];
    }



    // Admin functionality
    function changeRole(uint _id, string memory _role, uint _shopNumberOrZero) public {
        require(checkOnAdmin(msg.sender) == 1, "u r not admin of this programm");
        
        if (keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("seller")) || keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("buyer")) ) {
            userMapping[allUsersArray[_id]].role = _role;
            if (keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("buyer"))) {
                userMapping[allUsersArray[_id]].shopNumber = _shopNumberOrZero;
            }
        } else {
            console.log("Role undefined");
        }
    } 

    function addNewAdming(address _newAdmin, string memory _newAdmingLogin, uint _newAdmingBalance, string memory _newAdminPassword) public {
        require(checkOnAdmin(msg.sender) == 1, "u r not admin of this programm");

        adminMapping[_newAdmin] = Admin(_newAdmingLogin, _newAdmingBalance, _newAdminPassword);
        allAdmins.push(_newAdmin);
    }

    function addNewShop(address _newShopAddress, string memory _newShopCity, uint _newShopBalance, uint _newShopper) public {
        require(checkOnAdmin(msg.sender) == 1, "u r not admin of this programm");

        shopMapping[_newShopAddress] = shopStruct((allShopArray.length + 1), _newShopCity, _newShopBalance);
        allShopArray.push(_newShopAddress);

        changeRole(_newShopper, "buyer", allShopArray.length);
    }

    function deleteShop (address _shopAddress) public {
        require(checkOnAdmin(msg.sender) == 1, "u r not admin of this programm");

        for (uint index = 0; index < allUsersArray.length; index++) {
            if (userMapping[allUsersArray[index]].shopNumber == getShopNumber(_shopAddress)) {
                userMapping[allUsersArray[index]].shopNumber = 0;
                changeRole(index, "seller", 0);
            }
        }

        shopMapping[_shopAddress] = shopStruct(0, "null", 0);
        delete allShopArray[ getShopNumber(_shopAddress)];
    }






































    // System Functions For Checks
    function checkOnAdmin(address _itsadmin) internal  returns (uint) {
        uint flag = 0;

        for (uint index = 0; index < allAdmins.length; index++) {
            if (allAdmins[index] == _itsadmin) {
                flag = 1;
            }
        }

        return flag;
    }

    function getShopNumber(address _shopAddress) internal returns (uint) {
        uint number;

        for (uint index = 0; index < allShopArray.length; index++) {
            if (_shopAddress == allShopArray[index]) {
                number = shopMapping[allShopArray[index]].number;
            }
        }

        return number;
    }

    // System Functions For TESTING
    function logAllShops() public {
        for (uint index = 0; index < allShopArray.length + 1; index++) {
            console.log(shopMapping[allShopArray[index]].number, shopMapping[allShopArray[index]].city, shopMapping[allShopArray[index]].balance);
        }
    }

    function logAllRoles() public  {
        for (uint index = 0; index < allUsersArray.length; index++) {
            console.log(userMapping[allUsersArray[index]].id, userMapping[allUsersArray[index]].role);
        }
    }
}
