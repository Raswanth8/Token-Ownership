//SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

/*
 * @title Tracker
 * @author  Raswanth
 */

// @dev This contract is used to track the ownsership of the tokens
contract Tracker {
    struct Token {
        address owner;
        uint256 balance;
        string certificate;
        string name;
        uint32 price;
        uint256 timestamp;
        bool isSold;
    }

    mapping(address => Token) public tokens;

    // @dev This function is used to add the token to the list of tokens
    function addToken(
        address _owner,
        string memory _name,
        string memory _certificate,
        uint32 _price
    ) public {
        Token memory token = Token(
            _owner,
            0,
            _certificate,
            _name,
            _price,
            block.timestamp,
            false
        );
        tokens[_owner] = token;
    }

    // @dev This function is used to update the token details
    function updateToken(
        address _owner,
        string memory _name,
        string memory _certificate,
        uint32 _price
    ) public {
        Token memory token = tokens[_owner];
        token.name = _name;
        token.certificate = _certificate;
        token.price = _price;
        token.timestamp = block.timestamp;
        tokens[_owner] = token;
    }

    // @dev This function is used to transfer the ownership of the token
    function transferToken(address _owner, address _newOwner) public {
        Token memory token = tokens[_owner];
        token.owner = _newOwner;
        tokens[_owner] = token;
    }

    // @dev This function is used to sell the token
    function sellToken(address _owner, uint256 _amount) public {
        Token memory token = tokens[_owner];
        token.balance -= _amount;
        token.isSold = true;
        tokens[_owner] = token;
    }

    // @dev This function is used to check if the token is sold
    function isSold(address _owner) public view returns (bool) {
        Token memory token = tokens[_owner];
        return token.isSold;
    }

    // @dev This function is used to check proof of ownership
    function isOwner(address _owner) public view returns (bool) {
        Token memory token = tokens[_owner];
        return token.owner == msg.sender;
    }

    // @dev This function is used to provide micropayment for the token to orginal owner
    function pay(address _owner, uint256 _amount) public {
        Token memory token = tokens[_owner];
        token.balance += _amount;
        tokens[_owner] = token;
    }

    // @dev This function is to provide copyright for the token
    function copyright(address _newowner, uint256 _amount) public {
        Token memory token = tokens[_newowner];
        token.balance -= _amount;
        tokens[_newowner] = token;
    }

    // @dev This function is used to verify certificate of the token
    function verifyCertificate(address _owner, string memory _certificate)
        public
        view
        returns (bool)
    {
        Token memory token = tokens[_owner];
        return
            keccak256(abi.encodePacked(token.certificate)) ==
            keccak256(abi.encodePacked(_certificate));
    }
}
