// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
import "./import/PreSaleInfo.sol";

interface LockLPToken {
    function setWhiteList(address _address,bool _bool) external;
}

contract CreatePreSale is Ownable{
     using SafeMath for uint256;
     using SafeMath for uint256;
     
     address public platformAddress= 0xaF61074E68363BD4eB2330a207782b60a1950723;//平台 
     address public routerAddress= 0x10ED43C718714eb63d5aA57B78B54704E256024E;//uniswap地址 
     address public lockLpAddress = 0x2fB0BA3d4d14D72bA01582612981eBb40135931C;//锁币LP 
    
     address[] public preSaleContracts;
     uint256 public preSaleContractsLength=0;
     //预售的合约地址  msg.sender=>contract
     mapping(address=>address) public preSaleSenderContracts;
     //presale contract => index id
     mapping(address=>uint256) public preSaleContractsIndex;
     //token => index id
     mapping(address=>uint256[]) public preSaleTokenIndexs;
     mapping(address=>uint256) public preSaleTokenIndexsLength;
     
     uint256 public tokenSoldFee = 0; //%
     uint256 public ethRaisedFee = 2; //% 
     uint256 public createFee = 1*10**18;
     
    function doCreate(
        address _tokenAddress,
        uint256[] memory _cap,//0:soft 1:hard
        uint256[] memory _contribution, //0：min 1:max
        uint256[] memory _rate, //0 预售价格  1 流动池价格  2流动池比例  
        uint256[] memory _preSaleTime,//0:start Time  1:end time 3:liquidityUnLockTime
        string[] memory _information,//0:logo  1:website 2:github 3:twitter 4:reddit 5:telegram 6:desc 7:provide
        uint _verified_type
    ) external  payable{
       require(preSaleSenderContracts[msg.sender]==address(0x0),'Has release pre-sale');
       require(_cap[0] <= _cap[1],"The soft cap cannot be higher than hard cap");
       require(_contribution[0] <= _contribution[1],"Min contribution limit cannot be higher than max limit");
       require(_contribution[1] <= _cap[1],"Max contribution limit cannot be higher than hard cap");
       require(_rate[2] <= 100,'Liquidity amount needs to be a number <= 100');
       require(_rate[1] <= _rate[0],'Swap Listing Rate too large');
       require(_preSaleTime[0] >= block.timestamp,'Start time must be greater than block time ');
       require(_preSaleTime[0] <= _preSaleTime[1],'Start time must be less than end time ');
       require(_preSaleTime[2] > _preSaleTime[1],'liquidity unlock time must be greater than end time ');
       require(msg.value>=createFee,'Create fee not enough');

      //计算用户要转入多少 
      (uint256 _tokenTotal,uint256 _transferAll) = calculateTranferAll(_tokenAddress,_rate[0],_rate[1],_rate[2],_cap[1]);
      
       uint256[] memory _fee = new uint256[](2);
       _fee[0] = tokenSoldFee;
       _fee[1] = ethRaisedFee;
       
       address[] memory _address = new address[](3);
        _address[0] = platformAddress;
        _address[1] = routerAddress;
        _address[2] = lockLpAddress;
        
        
       PreSaleInfo _newToken = new PreSaleInfo(
             msg.sender,
             _tokenTotal,
             _tokenAddress,
             _cap,
             _contribution,
             _rate,
             _preSaleTime,
            _fee,
            _address,
            _verified_type
           );
           
        initInfomation(
            _newToken,
            _information[0],
            _information[1],
            _information[2],
            _information[3],
            _information[4],
            _information[5],
            _information[6],
            _information[7]
      );
        
       preSaleContracts.push(address(_newToken)); 
       preSaleSenderContracts[msg.sender] = address(_newToken);
       preSaleContractsIndex[address(_newToken)] = preSaleContractsLength;
       preSaleTokenIndexs[_tokenAddress].push(preSaleContractsLength);
       preSaleTokenIndexsLength[_tokenAddress] ++;
       
       preSaleContractsLength ++;
       
       //把代币转给新建立的合约 
       IUniswapV2Pair _token = IUniswapV2Pair(_tokenAddress);
       _token.transfer(address(_newToken),_transferAll);
       
       LockLPToken _LockLPToken = LockLPToken(lockLpAddress);
       _LockLPToken.setWhiteList(address(_newToken),true);
       
       payable(owner()).transfer(msg.value);
    }
    
    function setTokenSoldFee(uint256 _tokenSoldFee) public virtual onlyOwner{
        tokenSoldFee = _tokenSoldFee;
    }
    
    function setEthRaisedFee(uint256 _ethRaisedFee) public virtual onlyOwner{
        ethRaisedFee = _ethRaisedFee;
    }
    
    function setCreateFee(uint256 _createFee) public virtual onlyOwner{
        createFee = _createFee;
    }
    
    function setPlatformAddress(address _address) public virtual onlyOwner{
        require(_address != address(0), "not allowed zero address");
        platformAddress = _address;
    }
    
    function setLockLpAddress(address _address) public virtual onlyOwner{
        require(_address != address(0), "not allowed zero address");
        lockLpAddress = _address;
    }
    
    function initInfomation(
        PreSaleInfo _newToken,
        string memory logo,
        string memory website,
        string memory github,
        string memory twitter,
        string memory reddit,
        string memory telegram,
        string memory desc,
        string memory provide) internal{
        _newToken.updateInfomation(
            logo,
            website,
            github,
            twitter,
            reddit,
            telegram,
            desc,
            provide
        );

    }
    
    //计算并转入 TOKEN
    function calculateTranferAll(
        address _tokenAddress,
        uint256 _preSaleRate,
        uint256 _swapListingRate,
        uint256 _liquidityRate,
        uint256 _hardcap
    ) internal returns (uint256 tokenTotal,uint256 transferAll){
        
        IUniswapV2Pair _token = IUniswapV2Pair(_tokenAddress);
        
        tokenTotal = _token.totalSupply();
        
        //计算总额 
        uint256 _preSaleAmount =  _preSaleRate.mul(_hardcap).div(10**18);
         
       
        uint256 tokenFeeAll = _preSaleAmount.mul(tokenSoldFee).div(100); 
            
       
        uint256 liquidityAll = _hardcap.mul(ethRaisedFee).div(100);
        liquidityAll = _hardcap.sub(liquidityAll);//扣除手续费 
        liquidityAll = liquidityAll.mul(_liquidityRate).div(100);//乘于流动性比例    
        liquidityAll  =  liquidityAll.mul(_swapListingRate).div(10**18);
            
        transferAll = _preSaleAmount.add(tokenFeeAll).add(liquidityAll);
        
        require(_token.balanceOf(msg.sender) >= transferAll,"balance not enough");
        
        _token.transferFrom(msg.sender,address(this),transferAll);
        
    }
    
}