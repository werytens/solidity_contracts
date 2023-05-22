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

    mapping (uint => shopStruct) public shopMapping;
    uint[] shopNumbers;



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

        shopMapping[1] = shopStruct(1, "Saint Petersburg", 1500);
        shopMapping[2] = shopStruct(2, "Dmitrov", 400);
        shopMapping[3] = shopStruct(3, "Moscow", 1400);
        shopMapping[4] = shopStruct(4, "Arkhangelsk", 900);
        shopMapping[5] = shopStruct(5, "Irkutsk", 1000);

        shopNumbers = [1, 2, 3, 4, 5];

        

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

    function addNewShop(string memory _newShopCity, uint _newShopBalance, uint _newShopper) public {
        require(checkOnAdmin(msg.sender) == 1, "u r not admin of this programm");

        shopMapping[shopNumbers.length + 1] = shopStruct((shopNumbers.length + 1), _newShopCity, _newShopBalance);
        shopNumbers.push(shopNumbers.length + 1);

        changeRole(_newShopper, "buyer", shopNumbers.length);
    }

    function deleteShop (uint _shopNumber) public {
        require(checkOnAdmin(msg.sender) == 1, "u r not admin of this programm");

        shopMapping[_shopNumber] = shopStruct(0, "null", 0);
        delete shopNumbers[_shopNumber];

        for (uint index = 0; index < allUsersArray.length; index++) {
            if (userMapping[allUsersArray[index]].shopNumber == _shopNumber) {
                userMapping[allUsersArray[index]].shopNumber = 0;
                changeRole(index, "seller", 0);
            }
        }
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

    // System Functions For TESTING
    function logAllShops() public {
        for (uint index = 0; index < shopNumbers.length + 1; index++) {
            console.log(shopMapping[index].number, shopMapping[index].city, shopMapping[index].balance);
        }
    }

    function logAllRoles() public  {
        for (uint index = 0; index < allUsersArray.length; index++) {
            console.log(userMapping[allUsersArray[index]].id, userMapping[allUsersArray[index]].role);
        }
    }
}
