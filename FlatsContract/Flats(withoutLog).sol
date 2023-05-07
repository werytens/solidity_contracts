// SPDX-License-Identifier: GPL-3.0

// pragma solidity ^0.5.1;
pragma solidity >= 0.7.0;

// import "@nomiclabs/buidler/console.sol";

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
    address[] clientsArray;

    constructor() public {
        _estates[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4].push(Estates(0, 100, 7));
        _estates[0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB].push(Estates(1, 100, 7));
        _sallings[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4].push(Salling(0, true, 0, 0));
        _sallings[0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB].push(Salling(1, true, 0, 0));

        _owners.push(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
        _owners.push(0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB);
    }

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
                    _sallings[msg.sender][_id].onSale = true;
                    _sallings[msg.sender][_id].onSaleTime = _time;
                    _sallings[msg.sender][_id].price = price;
                    // console.log("Success!");
                } 
            }
        }
    }

    // Добавление нового клиента
    function newClientCreate(uint _id, uint _price) public payable {
        address nowHouseOwner = getHouserOwner(_id);

        if (_sallings[nowHouseOwner][_id].price > _price || nowHouseOwner == msg.sender || _sallings[nowHouseOwner][_id].price > msg.value || _sallings[nowHouseOwner][_id].onSale != true || (_price * 10**18 ) != (msg.value)) {
            // console.log("Error!");
        } else {
            _clients[msg.sender].push(Clients(_id, _price));
            clientsArray.push(msg.sender);
            // console.log("Success!");
        }
    }

    // Финальный перевод средств + аукцион
    function finalPurshate(uint _id) public payable  {
        address nowHouseOwner = getHouserOwner(_id);
        require(nowHouseOwner == msg.sender, "You didt own this house.");

        address bestClient = address(0);
        uint bestPrice = 0;


        for (uint index = 0; index < clientsArray.length; index++) {
            for (uint j = 0; j < _clients[clientsArray[index]].length; j++) {
                if (_clients[clientsArray[index]][j].id == _id) {
                    if (_clients[clientsArray[index]][_id].price > bestPrice) {
                        bestClient = clientsArray[index];
                        bestPrice = _clients[clientsArray[index]][_id].price;
                    } 
                }
            }
        }

        for (uint index = 0; index < clientsArray.length; index++) {
            for (uint j = 0; j < _clients[clientsArray[index]].length; j++) {
                if (_clients[clientsArray[index]][j].id == _id) {
                    if (_clients[clientsArray[index]][_id].price != bestPrice) {
                        payable(clientsArray[index]).transfer(_clients[clientsArray[index]][_id].price * 10**18);
                    } 
                }
            }
        }    
            
        payable(msg.sender).transfer(bestPrice * 10**18);

        _estates[bestClient].push(Estates(_id, _estates[nowHouseOwner][_id].square, _estates[nowHouseOwner][_id].yearsOfExpluatation));
        _sallings[bestClient].push(Salling(_id, false, 0, 0));
        _owners[_id] = bestClient;

        _estates[msg.sender][_id].id = 999999999;
        _estates[msg.sender][_id].square = 0;
        _estates[msg.sender][_id].yearsOfExpluatation = 0;
        _sallings[msg.sender][_id].id = 999999999;
        _sallings[msg.sender][_id].onSale = false;
        _sallings[msg.sender][_id].onSaleTime = 0;
        _sallings[msg.sender][_id].price = 0;
    }

    function cancelSell(uint _id) public payable {
        address nowHouseOwner = getHouserOwner(_id);

        if (nowHouseOwner == msg.sender) {
            for (uint index = 0; index < clientsArray.length; index++) {
                for (uint j = 0; j < _clients[clientsArray[index]].length; j++) {
                    if (_clients[clientsArray[index]][j].id == _id) {
                        payable(clientsArray[index]).transfer(_clients[clientsArray[index]][j].price * 10**18);
                    }
                }
            }
        } else {
            // console.log("You did`t own this house!");
        }
    } 

    function getHouserOwner (uint _id) private returns (address) {
        address nowHouseOwner;

        for (uint index = 0; index < _owners.length; index++) {
            for (uint j = 0; j < _estates[_owners[index]].length; j++) {
                if (_id == _estates[_owners[index]][j].id) {
                    nowHouseOwner = _owners[index];
                } else {
                    // console.log("This house doesn't exist!");
                }
            }
        }

        return nowHouseOwner;
    }

    // function checkAll() public {
    //     for (uint index = 0; index < _owners.length; index++) {
    //         console.log(_owners[index]);
    //         for (uint j = 0; j < _estates[_owners[index]].length; j++) {
    //             console.log(_estates[_owners[index]][j].id);
    //         }
    //     }
    // }

    // function checkAllSallings() public {
    //     for (uint index = 0; index < _owners.length; index++) {
    //         for (uint j = 0; j < _estates[_owners[index]].length; j++) {
    //             console.log(_sallings[msg.sender][j].id);
    //         }
    //     }
    // }

    // function checkAllClients() public {
    //     for (uint index = 0; index < clientsArray.length; index++) {
    //         console.log(clientsArray[index]);
    //         for (uint j = 0; j < _clients[clientsArray[index]].length; j++) {
    //             console.log("id", _clients[clientsArray[index]][j].id);
    //             console.log("price", _clients[clientsArray[index]][j].price);
    //         }
    //     }   
    // }
}

// contract HouseRent is EstatesContract {
//     function houseRent() public {
// Спросить о передаче денег за момент времени (а если он должен осуществлять по кнопке - как сделать чтобы в определённый момент времени средства - 
// начислялись в "долг").
// Остальной функционал есть в основном конракте с продажами. 
//     }
// }
