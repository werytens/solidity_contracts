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
        address owner;
        uint square;
        uint yearsOfExpluatation;
    }

    struct Salling {
        uint id;
        bool onSale;
        uint onSaleTime;
        uint price;

        bool transfered;
    }

    Estates[] public houseArrays;
    Salling[] public sallings;

    address client;

    constructor() {
        houseArrays.push(Estates(0, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, 50, 7));
        sallings.push(Salling(0, false, 0, 0, false));
    }

    function newHouseRegister(uint _id, address _owner, uint _square, uint _years) public {
        require(msg.sender == admin);
        houseArrays.push(Estates(_id, _owner, _square, _years));
        sallings.push(Salling(0, false, 0, 0, false));
    } 

    function goOnSale(uint _Id, uint _SecondsCount, uint _Price) public {
        require(houseArrays[_Id].owner == msg.sender);
        require(sallings[_Id].onSale == false);


        sallings[_Id].onSale = true;
        sallings[_Id].onSaleTime = _SecondsCount;
        sallings[_Id].price = _Price;
    }

    function cancelSale(uint _Id) public payable  {
        require(msg.sender != client);
        require(houseArrays[_Id].owner == msg.sender);
        require(sallings[_Id].onSale == false);

        if (sallings[_Id].transfered == true) {
            payable(client).transfer(sallings[_Id].price * 10**18);
        }

        sallings[_Id].onSale = false;
    }


    function buyHouse(uint _houseId) public payable {
        require(msg.sender != houseArrays[_houseId].owner);
        require(sallings[_houseId].onSale == true);
        require(msg.value == (sallings[_houseId].price * 10**18));
        
        sallings[_houseId].transfered = true;
        client = msg.sender;

        // changeOwnership(_houseId, msg.sender);
    }

    //     • возможность возврата средств отправителю, если продавец не подтвердил и закончился срок продажи

    // исправить так, чтобы вызывалась продавцом
    function changeOwnership(uint _houseId) public  {
        require(msg.sender != houseArrays[_houseId].owner);
        require(sallings[_houseId].transfered == true);

        payable(houseArrays[_houseId].owner).transfer(sallings[_houseId].price * 10**18);

        houseArrays[_houseId].owner = msg.sender;
    }


    function checkAll() public view returns (Estates[] memory) {
        return houseArrays;
    }
}
