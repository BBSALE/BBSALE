// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

     /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function geUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }
    
    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock");
        require(block.timestamp > _lockTime , "Contract is locked until 7 days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}

// pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}


// pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
    
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// pragma solidity >=0.6.2;

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface LockLpToken{
    function doLock(
        address token_contract,
        uint256 lock_amount,
        uint256 vestingPeriod,
        uint256 unlock_time,
        string memory logo,
        address ownerAddress
    ) external payable returns(uint256);
}


contract PreSaleInfo is Context, Ownable{
     using SafeMath for uint256;
     using Address for address;
     
     address private platformAddress;//平台 
     address private routerAddress;//uniswap地址 
     address private lockLpAddress;//锁币LP 
     IUniswapV2Router02 public _uniswapV2Router;
     address public swapLpRouter;
     
     uint256 public lpTokenLockIndex;
     
     uint256 public tokenSoldFee; //%
     uint256 public ethRaisedFee; //%
     
     
     uint256 public saleTokenAmount;//已卖多少代币
     uint256 public saleEthAmount;//已卖多少已ETH
     uint256 public leftTokenAmount;//剩下多少代币 
     uint256 public liquidityTokenAmount;
     uint public preSaleStatus = 0;//正常状态  0失败  1成功
     uint public isHardCap = 0;//达到硬顶可以直接完成 
     
     struct SellHistories {
        address buyAddress;
        uint256 time;
        uint256 ethAmount;
        uint256 tokenAmount;
    }
    
    //购买记录 
    SellHistories[] public sellHistoriesList;
    uint256 public SellHistoriesLength = 0;
    
    //msg.sender -> token
    mapping(address=>uint256) public userbuyTokenAmount;
    //msg.sender -> eth token
    mapping(address=>uint256) public userBuyEthAmount;
    //msg.sender -> eth token
    mapping(address=>bool) public userHasClaim;
    
    bool public enableWhiteList =  false; //开启白名单功能 
    uint256 public whiteCloseTime = 0;//白名单自动关闭的时间
    mapping(address=>bool) public whiteList;//白名单 
     
     uint256 public release_time;//发布时间 
     address public _creator;
     uint256 public tokenTotal;
     address public tokenAddress;
     uint256 public preSaleAmount; //要预售的代币数量
     uint256 public presaleRate;
     uint256 public softCap;  //要预售的代币软顶 
     uint256 public hardCap; //要预售的代币硬顶
     uint256 public minContribution; //最小购买多少 ETH
     uint256 public maxContribution;  //最大购多少 ETH
     uint256 public liquidityRate;  //募集到的资金多少比例放在流动池
     uint256 public swapListingRate;  //销售的代币价值 (1 ETH = ?? token)
     uint256 public preSaleStartTime;  //预售开始时间
     uint256 public preSaleEndTime;  //预售结束时间
     uint256 public liquidityUnLockTime;  //流动性解锁时间 
     uint public verified_type=0;
     
     
     address public uniswapV2Pair;//币对地址 
     
     bool public hasAddLiquidity = false;
     
     
    
    struct Information{
        string logo;
        string website;
        string github;
        string twitter;
        string reddit;
        string telegram;
        string desc;
        string provide;
    }
    
    Information public information;
    
    constructor (
        address creator_,
        uint256 _tokenTotal,
        address token_,
        uint256[] memory _cap, //0:soft 1:hard
        uint256[] memory  _contribution,//0:min 1:max
        uint256[] memory _Rate, //0_presaleRate 1swapListingRate 2liquidityRate
        uint256[] memory _preSaleTime,//0:start Time  1:end time 3:liquidityUnLockTime
        uint256[] memory _fee,//0:?% of Tokens Sold  1:?% of eth Raised
        address[] memory _address,
        uint _verified_type
    ){
        
        release_time = block.timestamp;
        
       _creator = creator_;
       tokenTotal = _tokenTotal;
       tokenAddress = token_;
       presaleRate = _Rate[0];
       preSaleAmount = _Rate[0].mul(_cap[1]).div(10**18);
       leftTokenAmount = _Rate[0].mul(_cap[1]).div(10**18);
       
     
       
       softCap = _cap[0];
       hardCap = _cap[1];
       minContribution = _contribution[0];
       maxContribution = _contribution[1];
       liquidityRate = _Rate[2];
       swapListingRate = _Rate[1];
       preSaleStartTime = _preSaleTime[0];
       preSaleEndTime = _preSaleTime[1];
       liquidityUnLockTime = _preSaleTime[2];
       
       tokenSoldFee = _fee[0];
       ethRaisedFee = _fee[1];
       
       platformAddress = _address[0];
       routerAddress = _address[1];
       lockLpAddress = _address[2];
       
       verified_type = _verified_type;
       
          //ETH流动性支出
       uint256 ethFee = hardCap.mul(ethRaisedFee).div(100);
       uint256 liquidityEthAll = hardCap.sub(ethFee).mul(liquidityRate).div(100);
          
       //流动性支出
       liquidityTokenAmount = liquidityEthAll.mul(swapListingRate).div(10**18);
       
       
       //oktest
       _uniswapV2Router = IUniswapV2Router02(routerAddress);
       
       swapLpRouter = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(token_, _uniswapV2Router.WETH());
        if(swapLpRouter == address(0)){
            // Pair doesn't exist
            swapLpRouter = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(token_, _uniswapV2Router.WETH());
        }

    }
    
    //购买币 
    function doContribute() public payable{
        uint256 _ethAmount = msg.value;
        
        //时间判断 
        require(preSaleStartTime <= block.timestamp,"Pre-sale has not yet started");
        require(preSaleEndTime >= block.timestamp,"Pre-sale has ended");
        
        
        require(checkWhiteList(msg.sender),"Not allowed contribute");
        require(_ethAmount >= minContribution ,"Must greater or equal to min contribute");
        uint256 _userBuyEthAmount = userBuyEthAmount[msg.sender];
        require(_userBuyEthAmount.add(_ethAmount) <= maxContribution,"Exceed max contribute");
        require(saleEthAmount.add(_ethAmount) <= hardCap,"Exceed max hardCap");
        
        //根据ETH换算成可购买的代币 
        uint256 _sellAmount=  presaleRate.mul(_ethAmount).div(10**18);
        require(_sellAmount <= leftTokenAmount,"Exceed the remaining pre-sale");
        
        userBuyEthAmount[msg.sender] = _userBuyEthAmount.add(_ethAmount);
        userbuyTokenAmount[msg.sender] = userbuyTokenAmount[msg.sender].add(_sellAmount);
        
        //记录日志 
        SellHistories memory _sellHistories;
        _sellHistories.buyAddress = msg.sender;
        _sellHistories.time = block.timestamp;
        _sellHistories.ethAmount = _ethAmount;
        _sellHistories.tokenAmount = _sellAmount;
        
        sellHistoriesList.push(_sellHistories);
        SellHistoriesLength++;
        
        saleTokenAmount =  saleTokenAmount.add(_sellAmount);//已卖多少代币
        saleEthAmount = saleEthAmount.add(_ethAmount);//已卖多少已ETH
        leftTokenAmount = leftTokenAmount.sub(_sellAmount);//剩下多少代币 
        
        if(saleEthAmount >= softCap){//到达软顶就成功 
            preSaleStatus = 1;
        }
        if(saleEthAmount >= hardCap){
            isHardCap = 1;
        }
        
        //payable(platformAddress).transfer(_ethAmount);
    }
    
   //失败取回  
    function claimFunds() public {
        require(preSaleEndTime <= block.timestamp , "The pre-sale time is not over");
        require(preSaleStatus == 0 , "The pre-sale is not fail");
        
        if(!userHasClaim[msg.sender]){
            
            //创建者提取 
            if(_creator==msg.sender){
              //取回代币 
              IUniswapV2Pair _token = IUniswapV2Pair(tokenAddress);
              if(_token.balanceOf(address(this)) > 0)
                _token.transfer(msg.sender,_token.balanceOf(address(this)));
            }
            //投资者提取 
            //取回平台币 
            if(userBuyEthAmount[msg.sender] > 0)
                payable(msg.sender).transfer(userBuyEthAmount[msg.sender]);
           
            
            userHasClaim[msg.sender] = true;
        }
        
    }
    
    //成功取回  
     function claimToken() public {
        if(isHardCap == 0){
            require(preSaleEndTime <= block.timestamp , "The pre-sale time is not over");
        }
        require(preSaleStatus ==1 , "The pre-sale is not success");
       
        if(!userHasClaim[msg.sender]){
            //添加流动性 
            (uint256 ethFee,,uint256 liquidityEthAll) = swapAndLiquify();
              
            //创建者提取 
            if(_creator==msg.sender){
              
              //取回平台币 
              if(ethFee > 0)
                payable(platformAddress).transfer(ethFee);
              
              if(saleEthAmount.sub(ethFee).sub(liquidityEthAll) > 0)
                payable(msg.sender).transfer(saleEthAmount.sub(ethFee).sub(liquidityEthAll));
              
              
              //取回剩余代币 
              IUniswapV2Pair _token = IUniswapV2Pair(tokenAddress);
               //手续费用 
              uint256 fee = saleTokenAmount.mul(tokenSoldFee).div(100);
              if(fee > 0)
                _token.transfer(platformAddress,fee);
              
              
              
              //剩下的代币 
              uint256 _balance = _token.balanceOf(address(this));
              _balance = _balance.sub(saleTokenAmount);
              if(_balance > 0)
                _token.transfer(msg.sender,_balance);
              
            }
            
            //投资者提取 
            //取回代币 
            IUniswapV2Pair _tokens = IUniswapV2Pair(tokenAddress);
            if(userbuyTokenAmount[msg.sender] > 0)
               _tokens.transfer(address(this),userbuyTokenAmount[msg.sender]);
               
            userHasClaim[msg.sender] = true;
        }
        
    }
    
    receive() external payable{
        doContribute();
    }
    
    //设置最小最大购买数量 
    function  setContribution(uint256 _minContribution,uint256 _maxContribution) public {
        require(_creator==msg.sender,'modifier must be creator');
        require(_minContribution <= _maxContribution ,"The minimum contribution limit cannot be higher than max limit");
        require(_maxContribution <= hardCap,"The maximum contribution limit cannot be higher than hard cap");
        
        minContribution = _minContribution;
        maxContribution = _maxContribution;
    }
   
    
    //开启白名单 
    function setEnableWhiteList(uint _enable) public{
         require(_creator==msg.sender,'modifier must be creator');
         if(_enable == 1){
            enableWhiteList = true;
         }
         else{
            enableWhiteList = false;
         }
    }
    function setWhiteCloseTime(uint256 _closetime) public{
        require(_creator==msg.sender,'modifier must be creator');
        require(enableWhiteList==true,'must enable whitelist');
        whiteCloseTime = _closetime;
    }
    //设置白名单 
    function setWhiteList(address[] memory _addressList,bool _bool) public{
        require(_creator==msg.sender,'modifier must be creator');
        require(enableWhiteList==true,'must enable whitelist');
        for(uint256 i=0;i<_addressList.length;i++){
            whiteList[_addressList[i]] = _bool;
        }
    }
    //检查白名单 
    function checkWhiteList(address _address) public view returns (bool){
        if(enableWhiteList == false)
            return true;
        
        if(whiteCloseTime > 0 &&  whiteCloseTime <= block.timestamp)
            return true;
            
       return whiteList[_address];
    }
   
  
    //更新信息 
    function updateInfomation(
        string memory logo,
        string memory website,
        string memory github,
        string memory twitter,
        string memory reddit,
        string memory telegram,
        string memory desc,
        string memory provide
    )
    public 
    {
        require(_creator==tx.origin,'modifier must be creator');
        Information memory _information;
        _information.logo=logo;
        _information.website=website;
        _information.github=github;
        _information.twitter=twitter;
        _information.reddit=reddit;
        _information.telegram=telegram;
        _information.desc=desc;
        _information.provide=provide;
        
        information = _information;
    }
    
    //添加流动性 
    function swapAndLiquify() internal returns (uint256 ethFee,uint256 liquidityAll,uint256 liquidityEthAll){
        
         //ETH流动性支出
         ethFee = saleEthAmount.mul(ethRaisedFee).div(100);
         liquidityEthAll = saleEthAmount.sub(ethFee).mul(liquidityRate).div(100);
          
         //流动性支出
         liquidityAll = liquidityEthAll.mul(swapListingRate).div(10**18);
         
         if(hasAddLiquidity == false){
            IUniswapV2Pair _token =  IUniswapV2Pair(tokenAddress);
            _token.approve(address(_uniswapV2Router),liquidityAll);
             
             // add the liquidity
             _uniswapV2Router.addLiquidityETH{value : liquidityEthAll}(
                tokenAddress,
                liquidityAll,
                0, // slippage is unavoidable
                0, // slippage is unavoidable
                address(this),
                block.timestamp
            );
            
            //授权合约取币
            IUniswapV2Pair _IUniswapV2Pair = IUniswapV2Pair(swapLpRouter);
            _IUniswapV2Pair.approve(lockLpAddress,_IUniswapV2Pair.balanceOf(address(this)));
            
            //锁起来 
            LockLpToken _LockLpToken =  LockLpToken(lockLpAddress);
            lpTokenLockIndex = _LockLpToken.doLock(
                swapLpRouter,
                _IUniswapV2Pair.balanceOf(address(this)),
                100,
                liquidityUnLockTime,
                information.logo,
                _creator
            );
            
            hasAddLiquidity= true;
         }
    }
}