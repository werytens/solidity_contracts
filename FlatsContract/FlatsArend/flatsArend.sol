// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0;

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

    constructor() {
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
                } 
            }
        }
    }

    // Добавление нового клиента
    function newClientCreate(uint _id, uint _price) public payable {
        address nowHouseOwner = getHouserOwner(_id);

        if (_sallings[nowHouseOwner][_id].price > _price || nowHouseOwner == msg.sender || _sallings[nowHouseOwner][_id].price > msg.value || _sallings[nowHouseOwner][_id].onSale != true || (_price * 10**18 ) != (msg.value)) {
        } else {
            _clients[msg.sender].push(Clients(_id, _price));
            clientsArray.push(msg.sender);
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
        } else {}
    } 

    function getHouserOwner (uint _id) internal returns (address) {
        address nowHouseOwner;

        for (uint index = 0; index < _owners.length; index++) {
            for (uint j = 0; j < _estates[_owners[index]].length; j++) {
                if (_id == _estates[_owners[index]][j].id) {
                    nowHouseOwner = _owners[index];
                } else {}
            }
        }

        return nowHouseOwner;
    }

    function getHouse(uint _id) internal returns (Estates memory) {
        for (uint index = 0; index < _estates[getHouserOwner(_id)].length; index++) {
            if (_id == _estates[getHouserOwner(_id)][index].id) {
                return _estates[getHouserOwner(_id)][index];
            }
        }
    }
}

contract HouseRent is EstatesContract {
    
    struct Rents {
        uint id;
        uint rent_price;
        uint rent_days;

        address client;

        bool active;

        uint256 timestamp;
    }
    
    mapping (address => Rents[]) _rents;

    function getHouseRent(uint _id) internal returns (Rents memory) {
        for (uint index = 0; index < _estates[getHouserOwner(_id)].length; index++) {
            if (_id == _rents[getHouserOwner(_id)][index].id) {
                return _rents[getHouserOwner(_id)][index];
            }
        }
    }
    
    function addToRent(uint _id, uint _price, uint _rentDays) public {
        require(msg.sender == getHouserOwner(_id), "u dont own this house");

        _rents[msg.sender].push(Rents(_id, _price, _rentDays, address(0), true, 0));
    }

    function addClientForRent(uint _id) public payable returns (uint) {
        require(msg.sender != getHouserOwner(_id), "You owner of this house");
        require(getHouseRent(_id).active == true, "This house not on rent");
        require(msg.value >= (getHouseRent(_id).rent_price * 10**18), "Msg. Value!!!");

        for (uint index = 0; index < _estates[getHouserOwner(_id)].length; index++) {
            if (_id == _rents[getHouserOwner(_id)][index].id) {
                _rents[getHouserOwner(_id)][index].client = msg.sender;
                _rents[getHouserOwner(_id)][index].timestamp = block.timestamp;
            }
        }

        return  1;
    }

    function cancelRentByOwner(uint _id) public payable {
        require(msg.sender == getHouserOwner(_id), "You owner of this house");
        require(getHouseRent(_id).active == true, "This house not on rent");

        payable(getHouseRent(_id).client).transfer(getHouseRent(_id).rent_price * 10**18);

        getHouseRent(_id).active = false;
        getHouseRent(_id).client = address(0);
    }

    function cancelRentByClient(uint _id) public payable {
        require(msg.sender == getHouseRent(_id).client, "u dont client of this house");
        require(getHouseRent(_id).active == true, "This house not on rent");

        payable(getHouseRent(_id).client).transfer(getHouseRent(_id).rent_price * 10**18);

        getHouseRent(_id).active = false;
        getHouseRent(_id).client = address(0);
    }

    function acceptRent(uint _id) public payable {
        require(msg.sender == getHouserOwner(_id), "You dont own this house");
        require(getHouseRent(_id).active == true, "This house not on rent");

        payable(getHouserOwner(_id)).transfer(getHouseRent(_id).rent_price * 10**18);

        getHouseRent(_id).active = false;
        getHouseRent(_id).client = address(0);
    }

    function endRent(uint _id) public {
        require(msg.sender == getHouserOwner(_id), "You dont own this house");
        require(getHouseRent(_id).active == true, "This house not on rent");
        require(block.timestamp >= getHouseRent(_id).timestamp + getHouseRent(_id).rent_days*1 days, "Not enough time has passed.");

        getHouseRent(_id).active = false;
        getHouseRent(_id).client = address(0);
    }
}
