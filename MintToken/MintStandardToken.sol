// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "./import/standardToken.sol";

contract MintToken is Ownable{
    struct tokenOwnerMaps {
        uint8 _type;
        address _token;
        string _name;
        string _symbol;
        uint8 _decimals;
        uint256 _total;
    }
    
    mapping(address=>tokenOwnerMaps[]) public tokenOwners;
    mapping(address=>uint8) public tokenOwnersLength;
    mapping(address=>address) public tokenList;
    
    uint256 public mintFee = 2*10**17;
    
    function doMint(string memory _name,string memory _symbol,uint8 _decimals,uint256 _initalSupply) external payable{
        
        require(msg.value>=mintFee,'Mint fee not enough');
        
     
        
        StandardToken _newToken = new StandardToken(msg.sender,_name,_symbol,_decimals,_initalSupply);
        
         _newToken.transferOwnership(msg.sender);
         uint256 totalBalance = _newToken.balanceOf(address(this));
         _newToken.transfer(msg.sender,totalBalance);
        
        
        tokenOwnerMaps memory tokenOwnerMap; 
        tokenOwnerMap._token = address(_newToken);
        tokenOwnerMap._name= _name;
        tokenOwnerMap._symbol= _symbol;
        tokenOwnerMap._decimals= _decimals;
        tokenOwnerMap._total= _initalSupply;
        
        tokenOwners[msg.sender].push(tokenOwnerMap);
        tokenOwnersLength[msg.sender] +=1;
        tokenList[address(_newToken)] =  msg.sender;
        
        payable(owner()).transfer(msg.value);
        
    }
    
    function setFee(uint256 _mintFee) public virtual onlyOwner {
        mintFee = _mintFee;
    }
}