// SPDX-License-Identifier: GPL-3.0

pragma solidity > 0.7.0;

/**
 * @title Test
 * @dev Test Contract
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

        bool transfered;
    }
        
    mapping (address => Estates[]) _estates;
    address[] _owners;
    uint[] estateCount;

    mapping (address => Salling[]) _sallings;

    mapping (address => Clients[]) _clients;
    address[] clients;
    
    

    constructor() {
        _estates[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2].push(Estates(0, 100, 7));
        _owners.push(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
    }

    function newHouseRegister(address _owner, uint _square, uint _years) public {
        require(msg.sender == admin);
        require(_square > 0);
        require(_owner != address(0));

        _estates[_owner].push(Estates(estateCount.length, _square, _years));
        estateCount.push(estateCount.length);
    } 

    function goOnSale(uint _id, uint _seconds, uint _price) public {
        require(!_sallings[msg.sender][_id].onSale);

        _sallings[msg.sender].push(Salling(_id, true, _seconds, _price));
    }

    function newClientAdd(uint _id, uint _price) public  payable  {
        address owner = _owners[_id];
        require(_price >= _sallings[owner][_id].price);
        require(msg.value >= _price);

        _clients[msg.sender].push(Clients(_id, _price, false));
        clients.push(msg.sender);

        payable(msg.sender).transfer(_price);
    }

    function changeOwnership(uint id) public payable {
        uint mostHighPrice = 0;
        address clientWhoWin;
        for (uint index = 0; index < clients.length; index++) {
            address client = clients[index];

            if (_clients[client][index].price > mostHighPrice) {
                mostHighPrice = _clients[client][index].price;
                clientWhoWin = client;
            } else {
                payable(client).transfer(_clients[client][index].price);
            }
        }

        address owner = _owners[id];
        _estates[clientWhoWin][id] = _estates[owner][id];
        delete _estates[owner][id];
    }
}
