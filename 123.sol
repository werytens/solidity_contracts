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
        
        address[] clients;
        uint[] clientPrices;
    }
        
    mapping (address => Estates[]) _estates;
    mapping (address => Salling[]) _sallings;
    address[] owners;
    uint[] estateCount;

    constructor() {
        _estates[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2].push(Estates(0, 100, 7));
        owners.push(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
    }

    function newHouseRegister(address _owner, uint _square, uint _years) public {
        require(msg.sender == admin);
        require(_square > 0);

        _estates[_owner].push(Estates(estateCount.length, _square, _years));
        estateCount.push(estateCount.length);
    } 

    function goOnSale(uint _SecondsCount, uint _Price) public {
        require(_sallings[msg.sender].onSale != true);

        _sallings[msg.sender].push(Salling(_estates[msg.sender].id, true, _SecondsCount, _Price));
    }

    // function cancelSale(uint _Id) public payable  {
    //     require(msg.sender != client);
    //     require(houseArrays[_Id].owner == msg.sender);
    //     require(sallings[_Id].onSale == false);

    //     if (sallings[_Id].transfered == true) {
    //         payable(client).transfer(sallings[_Id].price * 10**18);
    //     }

    //     sallings[_Id].onSale = false;
    // }

    // function buyHouse(uint _houseId) public payable {
    //     require(msg.sender != houseArrays[_houseId].owner);
    //     require(sallings[_houseId].onSale == true);
    //     require(msg.value >= (sallings[_houseId].price * 10**18));
        
    //     sallings[_houseId].transfered = true;
    //     sallings[_houseId].clients[msg.sender] = msg.value;
    // }

    // function changeOwnership(uint _houseId) public  {
    //     require(msg.sender != houseArrays[_houseId].owner);
    //     require(sallings[_houseId].transfered == true);

    //     payable(houseArrays[_houseId].owner).transfer(sallings[_houseId].price * 10**18);

    //     houseArrays[_houseId].owner = msg.sender;
    // }

}
