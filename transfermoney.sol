pragma solidity >0.5.0;
// SPDX-License-Identifier: GPL-3.0

//Base Commit

/**
* @title Transfer
* @dev Store & retrieve value in a variable
*/

import "hardhat/console.sol";

contract Transfer {

    struct User {
        string name;
        uint status;
    }

    struct Transfer {
        address owner;
        address target;
        uint value;
        uint status;
        uint secret_code;
    }

    mapping (address => User) public user_mapping;
    address[] public users;
    Transfer[] public transfers;

    constructor() {
        // Admins
        
        user_mapping[0xdD870fA1b7C4700F2BD7f44238821C26f7392148] = (User("Maxim", 1));
        users.push(0xdD870fA1b7C4700F2BD7f44238821C26f7392148); 
        user_mapping[0x583031D1113aD414F02576BD6afaBfb302140225] = (User("Dima", 1));
        users.push(0x583031D1113aD414F02576BD6afaBfb302140225); 

        // Users
        user_mapping[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] = (User("Alex", 0));
        users.push(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4); 
        user_mapping[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2] = (User("Daniel", 0));
        users.push(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2); 
        user_mapping[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db] = (User("Ivan", 0));
        users.push(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db); 
        user_mapping[0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB] = (User("Anna", 0));
        users.push(0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB); 
    }

    function registration(string memory name, address user_address) public {
        require(user_mapping[msg.sender].status == 1, "u not admin");
        user_mapping[user_address] = (User(name, 0));
        users.push(user_address); 
    }

    function add_transfer(uint value, address target, uint code) public payable {
        require(msg.value == value, "uncorrect value");
        require(target != msg.sender, "u can pay to urself");

        uint flag = 0;

        for (uint index = 0; index < users.length; index++) {
            if (users[index] == target) {
                flag += 1;
            }

            if (users[index] == msg.sender) {
                flag += 1;
            }
        }

        require(flag == 2, "someone user not registered");

        transfers.push(Transfer(msg.sender, target, msg.value, 0, code));
    }
    
    function cancel_transfer(uint id) public {
        require(transfers[id].owner == msg.sender, "u dont owner of transfer");
        require(transfers[id].status == 0, "ur transfer already done");

        payable(msg.sender).transfer(transfers[id].value);

        transfers[id].status = 2;
    }

    function accept_transfer(uint code, uint id) public {
        require(transfers[id].target == msg.sender, "u cant");
        require(transfers[id].status == 0, "transfer alrd accepted or transfer canceled");

        if (code == transfers[id].secret_code) {
            payable(msg.sender).transfer(transfers[id].value);
            transfers[id].status = 1;
        } else {
            payable(transfers[id].owner).transfer(transfers[id].value);
            transfers[id].status = 3;
        }
    }

    function up_to_admin(uint user_id) public {
        require(user_mapping[msg.sender].status == 1, "u not admin");
        user_mapping[users[user_id]].status = 1;
    }
} 
