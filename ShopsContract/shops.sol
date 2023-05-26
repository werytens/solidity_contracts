// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.22 < 0.9.0;
pragma experimental ABIEncoderV2;


import "hardhat/console.sol";

/**
 * @title Owner
 * @dev Set & change owner
 */

contract Shops {
    // Shops System
    struct shopRates {
        uint userId;
        uint rateId;

        uint shopNumber;
        uint shopRate;
        string rateComment;

        sellersComments[] sellers_comments;
        buyersAccepts[] buyers_accepts;

        address[] allSellersCommentsOwners;
        address[] allBuyersAcceptsOwners;
    }

    shopRates[] rates;

    function addNewRate(uint _shopNumber, uint _shopRate, string memory _rateComment) public onlySellers {
        require(_shopRate > 0 && _shopRate <= 5, "your grade must be > 0 and < 5");
        require(checkForAlreadyHaveRateOfThisShop(_shopNumber) == 0, "u have already appreciated the work of this store");
        
        shopRates storage newRate = rates.push();

        sellersComments storage selcom = newRate.sellers_comments.push();
        buyersAccepts storage buyacc = newRate.buyers_accepts.push();

        address[] memory void;

        newRate.userId = getUserIdForAddress(msg.sender);
        newRate.rateId = rates.length;
        newRate.shopNumber = _shopNumber;
        newRate.shopRate = _shopRate;
        newRate.rateComment = _rateComment;
        newRate.allSellersCommentsOwners = void;
        newRate.allBuyersAcceptsOwners = void;
    }

    function addCommentToRate(uint _rateId, string memory _rateComment) public onlySellers returns (uint) {
        require(getUserIdForAddress(msg.sender) != rates[_rateId].userId, "U owner of this rate");

        for (uint index = 0; index < rates[_rateId].allSellersCommentsOwners.length; index++) {
            if (rates[_rateId].allSellersCommentsOwners[index] == msg.sender) {
                console.log("u already have comment of this rate");
                return 0;
            }
        }

        sellersComments storage newComment = rates[_rateId].sellers_comments.push();

        newComment.owner = msg.sender;
        newComment.comment = _rateComment;
        return 1;
    }

    function acceptRate(uint _rateId, bool _accept) public onlyBuyers returns (uint) {
        require(getUserIdForAddress(msg.sender) != rates[_rateId].userId, "U owner of this rate");

        for (uint index = 0; index < rates[_rateId].allSellersCommentsOwners.length; index++) {
            if (rates[_rateId].allBuyersAcceptsOwners[index] == msg.sender) {
                console.log("u already accept of this rate");
                return 0;
            }
        }

        buyersAccepts storage accept = rates[_rateId].buyers_accepts.push();

        accept.owner = msg.sender;
        accept.isAccept = _accept;
        return 1;
    }
    

    struct sellersComments {
        string comment;

        address owner;
    }

    struct buyersAccepts {
        bool isAccept;

        address owner;
    }
    


    struct shopStruct {
        uint number;
        string city;
        uint balance;

        uint[] sellers_ids;
    }

    mapping (address => shopStruct) public shopMapping;
    address[] allShopArray;



    // Users System
    struct userStruct {
        uint id;
        string fcs;

        string login;
        bytes32 password;

        string role;

        string city;
        uint balance;

        uint[] userRequests;
    }

    

    mapping (address => userStruct) public userMapping;
    address[] allUsersArray;
    

    // Constructor
    constructor() {
        uint[] memory void;

        address shop1 = 0x4e8AABbc87bf85aa2bB51e278396389D833d59d9;
        address shop2 = 0x31100DfA60058875574Fe1926f2e167a1fe8808e;
        address shop3 = 0xb8229f27b39e3Ab014C8Acb0dcE3643e4AcB5FEB;
        address shop4 = 0x7cbE550908139e252fC2c002e0CA48b84cF8dDA4;
        address shop5 = 0xCC22278D6172a2f9DEcFaf837D8D196d2f41B681;


        shopMapping[shop1] = shopStruct(1,     "Saint Petersburg",     100, void);
        shopMapping[shop2] = shopStruct(2,     "Dmitrov",              100, void);
        shopMapping[shop3] = shopStruct(3,     "Moscow",               100, void);
        shopMapping[shop4] = shopStruct(4,     "Arkhangelsk",          100, void);
        shopMapping[shop5] = shopStruct(5,     "Irkutsk",              100, void);

        shopMapping[shop5].sellers_ids = [1];

        allShopArray = [
            shop1, 
            shop2, 
            shop3, 
            shop4, 
            shop5
        ];

        address user1 = 0xAAE559A97B0436e1f8Bc0687d7145C3d45923635;
        address user2 = 0xd8Ecf901279BcD2286Eaadca95698E33CE16d2dC;
        address user3 = 0x3dB5D3C0aE829e8C9040dCD255be1E7E974cbeb3;

        
        userMapping[user1] = userStruct(0, "Dmitriy Dmitriev Dmitrievuch",          "dimon",    keccak256("adminPassword"),     "admin",     "Kaluga",           100, void);
        userMapping[user2] = userStruct(1, "Alexandrova Alexandra Alexandrovna",    "alex",     keccak256("firstPassword"),     "buyer",     "Moscow",           100, void);
        userMapping[user3] = userStruct(2, "Ruslanov Ruslan Ruslanovich",           "rus",      keccak256("secondPassword"),    "seller",    "Saint Petersburg", 100, void);

        allUsersArray = [user1, user2, user3];
   
        allRequests.push(0);
    }

    function registerUser(string memory _userLogin, string memory _userPassword, string memory _userPasswordRepeat, string memory _fcs, string memory _userCity) public {
        require(keccak256(abi.encodePacked(_userPassword)) == keccak256(abi.encodePacked(_userPasswordRepeat)), "ur password (repeated) invalid.");
        require(checkLoginForTaken(_userLogin) == 0, "ur login is taken");
        require(checkUserAlreadyRegister(msg.sender) == 0, "u already registered");

        uint[] memory void;
        userMapping[msg.sender] = userStruct(allUsersArray.length, _fcs, _userLogin, keccak256(abi.encodePacked(_userPassword)), "seller", _userCity, 100, void);
    }

    // Requests
    struct requestForm {
        uint requestId;
        uint userId;

        string roleToRequest;
        bool requestIsOpen;
    }

    mapping (address => requestForm[]) public requestMapping;
    address[] allRequestsOwners;
    uint[] allRequests;

    function requestForSeller() public onlyBuyers { requestAdd("seller"); }

    function requestForBuyer(uint _shopId) public onlySellers { 
        shopMapping[allShopArray[_shopId]].sellers_ids.push(getUserIdForAddress(msg.sender));
        
        requestAdd("buyer"); 
    }

    function requestForAdmin() public notAdmin { requestAdd("admin"); }

    function requestAdd(string memory _requestRole) internal {
        uint id = allRequests.length;

        requestMapping[msg.sender].push(requestForm(id, getUserIdForAddress(msg.sender), _requestRole, true));
        userMapping[msg.sender].userRequests.push(id);
        if (checkAlreadyHadRequest(msg.sender) == 0) {allRequestsOwners.push(msg.sender);}
        allRequests.push(id);
    }

    function clearRequest(uint _requestId) internal  {
        for (uint index = 0; index < allRequestsOwners.length; index++) {
            for (uint j = 0; j < userMapping[allRequestsOwners[index]].userRequests.length; j++) {
                if (userMapping[allRequestsOwners[index]].userRequests[j] == _requestId) {
                    requestMapping[allRequestsOwners[index]][_requestId].requestIsOpen == false;
                }
            }
        }
    }

    ////// Admin functionality

    function roleRequestAccept(uint _requestId) public onlyAdmins {
        for (uint index = 0; index < allRequestsOwners.length; index++) {
            for (uint j = 0; j < userMapping[allRequestsOwners[index]].userRequests.length; j++) {
                if (userMapping[allRequestsOwners[index]].userRequests[j] == _requestId) {
                    if (requestMapping[allRequestsOwners[index]][_requestId].requestIsOpen == false) {
                        console.log("This request already closed!");
                    } else {
                        requestMapping[allRequestsOwners[index]][_requestId].requestIsOpen == false;

                        changeRole(requestMapping[allRequestsOwners[index]][_requestId].userId, requestMapping[allRequestsOwners[index]][_requestId].roleToRequest);
                    }
                }
            }
        }
    }

    function roleRequestClose(uint _requestId) public onlyAdmins {
        for (uint index = 0; index < allRequestsOwners.length; index++) {
            for (uint j = 0; j < userMapping[allRequestsOwners[index]].userRequests.length; j++) {
                if (userMapping[allRequestsOwners[index]].userRequests[j] == _requestId) {
                    if (requestMapping[allRequestsOwners[index]][_requestId].requestIsOpen == false) {
                        console.log("This request already closed!");
                    } else {
                        requestMapping[allRequestsOwners[index]][_requestId].requestIsOpen == false;
                    }
                }
            }
        }
    }

    function changeRole(uint _userId, string memory _role) internal {
        userMapping[allUsersArray[_userId]].role = _role;
    }

    // Shop Management
    function addNewShop(address _shopAddress, string memory _city) public onlyAdmins {
        uint[] memory void;

        shopMapping[_shopAddress] = shopStruct(allShopArray.length, _city, 100, void);
        allShopArray.push(_shopAddress);
    }

    function deleteShop(uint _id) public onlyAdmins {
        uint[] memory void;

        for (uint index = 0; index < shopMapping[allShopArray[_id]].sellers_ids.length; index++) {
            changeRole(shopMapping[allShopArray[_id]].sellers_ids[index], "seller");
        }

        shopMapping[allShopArray[_id]].number = 0;
        shopMapping[allShopArray[_id]].city = "None";
        shopMapping[allShopArray[_id]].balance = 0;
        shopMapping[allShopArray[_id]].sellers_ids = void;

        delete allShopArray[_id];
    }


    // System Functionaliti
    modifier onlyAdmins() {
        uint flag = 0;

        if (keccak256(abi.encodePacked(userMapping[msg.sender].role)) == keccak256(abi.encodePacked("admin"))) {
            flag = 1;
        }
        
        require(flag == 1, "u r not admin of this programm"); 
        _;
    }

    modifier notAdmin() {
        uint flag = 0;

        if (keccak256(abi.encodePacked(userMapping[msg.sender].role)) != keccak256(abi.encodePacked("admin"))) {
            flag = 1;
        }
        
        require(flag == 1, "u r also admin of this programm"); 
        _;
    }

    modifier onlySellers() {
        uint flag = 0;

        if (keccak256(abi.encodePacked(userMapping[msg.sender].role)) == keccak256(abi.encodePacked("seller"))) {
            flag = 1;
        }
        
        require(flag == 1, "u r not seller of this programm"); 
        _;
    }

    modifier onlyBuyers() {
        uint flag = 0;

        if (keccak256(abi.encodePacked(userMapping[msg.sender].role)) == keccak256(abi.encodePacked("buyer"))) {
            flag = 1;
        }
        
        require(flag == 1, "u r not buyer of this programm"); 
        _;
    }

    function getUserIdForAddress(address _userAddress) internal returns (uint) {
        for (uint index = 0; index < allUsersArray.length; index++) {
            if (allUsersArray[index] == _userAddress) {
                return userMapping[allUsersArray[index]].id;
            }
        }
    }

    function getUserAddressForId(uint _userId) internal returns (address) {
        for (uint index = 0; index < allUsersArray.length; index++) {
            if (userMapping[allUsersArray[index]].id == _userId) {
                console.log(allUsersArray[index]);
                return allUsersArray[index];
            }
        }
    }

    function checkAlreadyHadRequest(address _userAddress) internal returns (uint) {
        for (uint index = 0; index < allRequestsOwners.length; index++) {
            if (_userAddress == allRequestsOwners[index]) {
                return 1;
            } else {return 0;}
        }
    }

    function checkForAlreadyHaveRateOfThisShop(uint shopId) internal returns (uint) {
        uint flag = 0;

        for (uint index = 0; index < rates.length; index++) {
            if (rates[index].shopNumber == shopId && rates[index].userId == getUserIdForAddress(msg.sender)) {
                flag = 1;
            }
        }

        return flag;
    }

    function checkLoginForTaken(string memory _userLogin) internal returns (uint) {
        uint flag = 0;
        
        for (uint index = 0; index < allUsersArray.length; index++) {
            if (keccak256(abi.encodePacked(userMapping[allUsersArray[index]].login)) == keccak256(abi.encodePacked(_userLogin))) {
                flag = 1;
            }
        }

        return flag;
    }

    function checkUserAlreadyRegister(address _userAddress) internal returns (uint) {
        uint flag = 0;

        for (uint index = 0; index < allUsersArray.length; index++) {
            if (allUsersArray[index] == msg.sender) {
                flag = 1;
            }
        }

        return flag;
    }

    // For Interface Functions

    function getShopCount() public view returns (uint) {
        return allShopArray.length;
    }

    function getInfoAboutShop(uint _shopId) public view returns (string memory) {
        return shopMapping[allShopArray[_shopId]].city;
    }

    // struct shopRates {
    //     uint userId;
    //     uint rateId;

    //     uint shopNumber;
    //     uint shopRate;
    //     string rateComment;

    //     sellersComments[] sellers_comments;
    //     buyersAccepts[] buyers_accepts;

    //     address[] allSellersCommentsOwners;
    //     address[] allBuyersAcceptsOwners;
    // }
}
