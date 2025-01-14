// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

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

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface Token {
    function name() external pure returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address owner) external view returns (uint256);
    function approve(address spender, uint256 tokens) external  returns (bool);
    function transferFrom(address from, address to, uint256 tokens) external  returns (bool);
    function token0() external view returns (address);
    function token1() external view returns (address);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract LockLPToken is Ownable {
    using SafeMath for uint256;
    using Address for address;
    
    mapping(address=>bool) public whiteList;
    mapping(address=>bool) public preSaleContractList;
    
    struct TokenInfo{
        string name;
        string symbol;
        address token_contract;
    }
    
    struct LockTokenData{
        uint256 index;
        TokenInfo token0;
        TokenInfo token1;
        uint8 decimals;
        address token_contract;
        address owner;
        uint256 total_amount;
        uint256 lock_amount;
        uint256 release_time;
        uint256 vestingPeriod;
        uint256 unlock_time;
        string  logo;
    }
    
    LockTokenData[] public lockTokenDataList;
    uint256 public lockTokenDataDataLength = 0;
    
    //user_address => info
    mapping(address=>uint256[]) public userLockTokenData;
    //user_address => length
    mapping(address=>uint256) public userLockTokenDataLength;
    
    
    struct unlockData{
        uint256 unlock_time;
        uint256 unlock_amount;
        bool is_withdraw;
    }
    
    mapping(uint256=>unlockData[]) public unLockInfo;
    
    uint256 public lockFee=3*10**17;
    
    function doLock(
        address token_contract,
        uint256 lock_amount,
        uint256 vestingPeriod,
        uint256 unlock_time,
        string memory logo,
        address ownerAddress
    ) external payable returns(uint256){
        //白名单不收费 
        if(!checkWhiteList(msg.sender)){
            require(msg.value>=lockFee,'Do lock fee not enough');
        }
        
        
        address _ownerAddress = ownerAddress!=address(0) ?  ownerAddress : msg.sender;
     
        require(
            vestingPeriod == 100 ||
            vestingPeriod == 50 ||
            vestingPeriod == 25 ||
            vestingPeriod == 20 ||
            vestingPeriod == 10 ||
            vestingPeriod == 5 ||
            vestingPeriod == 4 ||
            vestingPeriod == 2 ||
            vestingPeriod == 1
        ,'Vesting period not allowed');
        
         //领取规则 
        uint256 all = getAll(vestingPeriod);
        
        uint256 _lock_amount = lock_amount.div(all);
        _lock_amount = _lock_amount.mul(all);
        
        Token token = Token(token_contract);
        
        address address_0 = token.token0();
        address address_1 = token.token1();
        
        require(token.balanceOf(msg.sender) >= _lock_amount,"balance not enough");
        
        token.transferFrom(msg.sender,address(this),_lock_amount);
        
        LockTokenData memory _lockTokenData;
        _lockTokenData.index =lockTokenDataDataLength;
        
        //token0
        _lockTokenData.token0 = getTokenInfo(address_0);
        
        //token1
        _lockTokenData.token1 = getTokenInfo(address_1);
        
        _lockTokenData.decimals = token.decimals();
        _lockTokenData.token_contract =token_contract;
        _lockTokenData.owner = _ownerAddress;
        _lockTokenData.total_amount = token.totalSupply();
        _lockTokenData.lock_amount = _lock_amount;
        _lockTokenData.release_time = block.timestamp;
        _lockTokenData.vestingPeriod =vestingPeriod;
        _lockTokenData.unlock_time = unlock_time;
        _lockTokenData.logo =logo;
        lockTokenDataList.push(_lockTokenData);
        
        userLockTokenData[_ownerAddress].push(lockTokenDataDataLength);
        
        
        
        //领取规则 
        makeUnlock(
            _ownerAddress,
            lockTokenDataDataLength,
            vestingPeriod,
            _lock_amount,
            unlock_time
        );
        
        lockTokenDataDataLength ++;
        
        //白名单不收费 
        if(!checkWhiteList(msg.sender)){
            payable(owner()).transfer(msg.value);
        }
        
        return lockTokenDataDataLength;
    }
    
    function getTokenInfo(address _address) internal view returns (TokenInfo memory _tokeninfo){
        Token _token = Token(_address);
        _tokeninfo.name= _token.name();
        _tokeninfo.symbol= _token.symbol();
        _tokeninfo.token_contract= _address;
    }
    
    function getAll(uint256 vestingPeriod) private pure returns(uint256){
        uint256 Period = 100;
        uint256 all = Period.div(vestingPeriod);
        return all;
    }
    
    function makeUnlock(address _ownerAddress,uint256 _index,uint256 vestingPeriod,uint256 lock_amount,uint256 unlock_time) private {
        uint256 blockTimestamp = block.timestamp;
        uint256 all = getAll(vestingPeriod);
        
        //提取信息 
        unlockData memory _unlockData;
        
        //一份间隔多少秒 
        uint256  perTime = unlock_time.sub(blockTimestamp).div(all);
        
        _unlockData.unlock_amount = lock_amount.div(all);
        _unlockData.is_withdraw = false;
        for(uint i = 0; i < all; i++){
            _unlockData.unlock_time = blockTimestamp.add(perTime.mul(i.add(1)));
            unLockInfo[_index].push(_unlockData);
        }
        
        userLockTokenDataLength[_ownerAddress]++;
    }
    
    function doWithdraw(address token_contract,uint256 dataIndex) public {
        require(tx.origin==msg.sender,"must be human");
        
        LockTokenData memory _LockTokenData;
        
        //根据索引获取锁仓的信息 
        _LockTokenData = lockTokenDataList[dataIndex];
        require(_LockTokenData.unlock_time <= block.timestamp,'Unlock time is not up');
        require(_LockTokenData.owner == msg.sender,'Not owner');
        
        uint256 Period = 100;
        uint256 all = Period.div(_LockTokenData.vestingPeriod);
        
        Token token = Token(token_contract);
        
        for(uint i = 0; i < all; i++){
           unlockData memory _unlockData;
           _unlockData = unLockInfo[dataIndex][i];
           if(_unlockData.unlock_time <= block.timestamp && _unlockData.is_withdraw == false){
                unLockInfo[dataIndex][i].is_withdraw = true;
                token.transfer(msg.sender,_unlockData.unlock_amount);
           }
        }
    }
    
    function setPreSaleContract(address _address,bool _bool) public virtual onlyOwner{
        require(_address != address(0), "not allowed zero address");
        preSaleContractList[_address] = _bool;
    }
    
    function setWhiteList(address _address,bool _bool) public{
        require(_address != address(0), "not allowed zero address");
        require(preSaleContractList[msg.sender] == true || msg.sender == owner() ,"Not owner");
        whiteList[_address] = _bool;
    }
    
      //检查白名单 
    function checkWhiteList(address _address) private view returns (bool){
       return whiteList[_address];
    }
    
    function setLockFee(uint256 _lockFee) public virtual onlyOwner {
        lockFee = _lockFee;
    }
}