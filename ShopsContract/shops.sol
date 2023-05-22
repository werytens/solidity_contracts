// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";

/**
 * @title Owner
 * @dev Set & change owner
 */

contract Shops {

    address admin = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    struct Admin {
        string login;
        uint balance;
        string password; 
    }

    mapping (address => Admin) public adminMapping;


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



    // Admin functionality
    function changeRole() public {

    } 



    // Constructor
    constructor() {
        adminMapping[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = Admin("dimon", 500, "aboba337");

        shopMapping[1] = shopStruct(1, "Saint Petersburg", 1500);
        shopMapping[2] = shopStruct(2, "Dmitrov", 400);
        shopMapping[3] = shopStruct(3, "Moscow", 1400);
        shopMapping[4] = shopStruct(4, "Arkhangelsk", 900);
        shopMapping[5] = shopStruct(5, "Irkutsk", 1000);

        shopNumbers = [1, 2, 3, 4, 5];

        


        userMapping[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = userStruct(0, "Alexandrova Alexandra Alexandrovna", 3, "alex", "first", "buyer", "Moscow", 150);
        userMapping[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db] = userStruct(1, "Ruslanov Ruslan Ruslanovich", 0, "rus", "second", "seller", "Saint Petersburg", 70);
    }



    // System Functions For TESTING
    function logAllShops() public {
        for (uint index = 0; index < shopNumbers.length + 1; index++) {
            console.log(shopMapping[index].number, shopMapping[index].city, shopMapping[index].balance);
        }
    }
}
