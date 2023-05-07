// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.5.1;

import "@nomiclabs/buidler/console.sol";

/** 
 * @title Ballot
 * @dev Implements voting process along with vote delegation
 */

contract EstatesContract {
    address admin = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    struct Estates {
        uint id;
        uint square;
        uint yearsOfExpluatation;
    }

    struct Salling {
        uint id;
        bool onSale;
        uint onSaleTime;
        uint price;
    }

    struct Clients {
        uint id;
        uint price;
    }
        
    mapping (address => Estates[]) _estates;
    mapping (address => Salling[]) _sallings;
    mapping (address => Clients[]) _clients;

    address[] _owners;
    uint[] estateCount;
    address[] clients;

    constructor() public {
        _estates[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4].push(Estates(0, 100, 7));
        _estates[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4].push(Estates(1, 100, 7));
        _owners.push(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        _estates[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db].push(Estates(2, 100, 7));
        _estates[0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db].push(Estates(3, 100, 7));
        _owners.push(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db);
    }

    // owners
    // 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
    // 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
    // 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB


    // Добавление новой квартиры
    function addNewHouse(address _owner, uint _square, uint _yearsOfExpluatation) public {
        require(msg.sender == admin);
        _estates[_owner].push(Estates(_owners.length, _square, _yearsOfExpluatation));
        _owners.push(_owner);
    }


    // Выставление квартиры на продажу
    function goOnSale(uint _id, uint _time, uint price) public {
        for (uint index = 0; index < _owners.length; index++) {
            for (uint j = 0; j < _estates[_owners[index]].length; j++) {
                if (_estates[_owners[index]][j].id == _id && _owners[index] == msg.sender) {
                    _sallings[msg.sender].push(Salling(_id, true, _time, price));
                    console.log("Success!");
                } 
            }
        }
    }

    function checkAll() public {
        for (uint index = 0; index < _owners.length; index++) {
            console.log(_owners[index]);
            for (uint j = 0; j < _estates[_owners[index]].length; j++) {
                console.log(_estates[_owners[index]][j].id);
            }
        }
    }

    function checkAllSallings() public {
        for (uint index = 0; index < _owners.length; index++) {
            for (uint j = 0; j < _estates[_owners[index]].length; j++) {
                console.log(_sallings[msg.sender][j].id);
            }
        }
    }
}
