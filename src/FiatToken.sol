import {SafeMath} from "./SafeMath.sol";

contract Ownable {
    // Owner of the contract
    address private _owner;

    /**
     * @dev Event to show ownership has been transferred
     * @param previousOwner representing the address of the previous owner
     * @param newOwner representing the address of the new owner
     */
    event OwnershipTransferred(address previousOwner, address newOwner);

    /**
     * @dev The constructor sets the original owner of the contract to the sender account.
     */
    constructor() public {
        setOwner(msg.sender);
    }

    /**
     * @dev Tells the address of the owner
     * @return the address of the owner
     */
    function owner() external view returns (address) {
        return _owner;
    }

    /**
     * @dev Sets a new owner address
     */
    function setOwner(address newOwner) internal {
        _owner = newOwner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == _owner, "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        setOwner(newOwner);
    }
}

contract Pausable is Ownable {
    event Pause();
    event Unpause();
    event PauserChanged(address indexed newAddress);

    address public pauser;
    bool public paused = false;

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!paused, "Pausable: paused");
        _;
    }

    /**
     * @dev throws if called by any account other than the pauser
     */
    modifier onlyPauser() {
        require(msg.sender == pauser, "Pausable: caller is not the pauser");
        _;
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() external onlyPauser {
        paused = true;
        emit Pause();
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() external onlyPauser {
        paused = false;
        emit Unpause();
    }

    /**
     * @dev update the pauser role
     */
    function updatePauser(address _newPauser) external onlyOwner {
        require(
            _newPauser != address(0),
            "Pausable: new pauser is the zero address"
        );
        pauser = _newPauser;
        emit PauserChanged(pauser);
    }
}

contract Blacklistable is Ownable {
    address public blacklister;
    mapping(address => bool) internal blacklisted;

    event Blacklisted(address indexed _account);
    event UnBlacklisted(address indexed _account);
    event BlacklisterChanged(address indexed newBlacklister);

    /**
     * @dev Throws if called by any account other than the blacklister
     */
    modifier onlyBlacklister() {
        require(
            msg.sender == blacklister,
            "Blacklistable: caller is not the blacklister"
        );
        _;
    }

    /**
     * @dev Throws if argument account is blacklisted
     * @param _account The address to check
     */
    modifier notBlacklisted(address _account) {
        require(
            !blacklisted[_account],
            "Blacklistable: account is blacklisted"
        );
        _;
    }

    /**
     * @dev Checks if account is blacklisted
     * @param _account The address to check
     */
    function isBlacklisted(address _account) external view returns (bool) {
        return blacklisted[_account];
    }

    /**
     * @dev Adds account to blacklist
     * @param _account The address to blacklist
     */
    function blacklist(address _account) external onlyBlacklister {
        blacklisted[_account] = true;
        emit Blacklisted(_account);
    }

    /**
     * @dev Removes account from blacklist
     * @param _account The address to remove from the blacklist
     */
    function unBlacklist(address _account) external onlyBlacklister {
        blacklisted[_account] = false;
        emit UnBlacklisted(_account);
    }

    function updateBlacklister(address _newBlacklister) external onlyOwner {
        require(
            _newBlacklister != address(0),
            "Blacklistable: new blacklister is the zero address"
        );
        blacklister = _newBlacklister;
        emit BlacklisterChanged(blacklister);
    }
}

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
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

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
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

abstract contract AbstractFiatTokenV1 is IERC20 {
    function _approve(
        address owner,
        address spender,
        uint256 value
    ) internal virtual;

    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal virtual;
}

contract FiatTokenV1 is AbstractFiatTokenV1, Ownable, Pausable, Blacklistable {
    using SafeMath for uint256;

    string public name;
    string public symbol;
    uint8 public decimals;
    string public currency;
    address public masterMinter;
    bool internal initialized;

    mapping(address => uint256) internal balances;
    mapping(address => mapping(address => uint256)) internal allowed;
    uint256 internal totalSupply_ = 0;
    mapping(address => bool) internal minters;
    mapping(address => uint256) internal minterAllowed;

    event Mint(address indexed minter, address indexed to, uint256 amount);
    event Burn(address indexed burner, uint256 amount);
    event MinterConfigured(address indexed minter, uint256 minterAllowedAmount);
    event MinterRemoved(address indexed oldMinter);
    event MasterMinterChanged(address indexed newMasterMinter);

    function initialize(
        string memory tokenName,
        string memory tokenSymbol,
        string memory tokenCurrency,
        uint8 tokenDecimals,
        address newMasterMinter,
        address newPauser,
        address newBlacklister,
        address newOwner
    ) public {
        require(!initialized, "FiatToken: contract is already initialized");
        require(
            newMasterMinter != address(0),
            "FiatToken: new masterMinter is the zero address"
        );
        require(
            newPauser != address(0),
            "FiatToken: new pauser is the zero address"
        );
        require(
            newBlacklister != address(0),
            "FiatToken: new blacklister is the zero address"
        );
        require(
            newOwner != address(0),
            "FiatToken: new owner is the zero address"
        );

        name = tokenName;
        symbol = tokenSymbol;
        currency = tokenCurrency;
        decimals = tokenDecimals;
        masterMinter = newMasterMinter;
        pauser = newPauser;
        blacklister = newBlacklister;
        setOwner(newOwner);
        initialized = true;
    }

    /**
     * @dev Throws if called by any account other than a minter
     */
    modifier onlyMinters() {
        require(minters[msg.sender], "FiatToken: caller is not a minter");
        _;
    }

    /**
     * @dev Function to mint tokens
     * @param _to The address that will receive the minted tokens.
     * @param _amount The amount of tokens to mint. Must be less than or equal
     * to the minterAllowance of the caller.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(
        address _to,
        uint256 _amount
    )
        external
        whenNotPaused
        onlyMinters
        notBlacklisted(msg.sender)
        notBlacklisted(_to)
        returns (bool)
    {
        require(_to != address(0), "FiatToken: mint to the zero address");
        require(_amount > 0, "FiatToken: mint amount not greater than 0");

        uint256 mintingAllowedAmount = minterAllowed[msg.sender];
        require(
            _amount <= mintingAllowedAmount,
            "FiatToken: mint amount exceeds minterAllowance"
        );

        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        minterAllowed[msg.sender] = mintingAllowedAmount.sub(_amount);
        emit Mint(msg.sender, _to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
    }

    /**
     * @dev Throws if called by any account other than the masterMinter
     */
    modifier onlyMasterMinter() {
        require(
            msg.sender == masterMinter,
            "FiatToken: caller is not the masterMinter"
        );
        _;
    }

    /**
     * @dev Get minter allowance for an account
     * @param minter The address of the minter
     */
    function minterAllowance(address minter) external view returns (uint256) {
        return minterAllowed[minter];
    }

    /**
     * @dev Checks if account is a minter
     * @param account The address to check
     */
    function isMinter(address account) external view returns (bool) {
        return minters[account];
    }

    /**
     * @notice Amount of remaining tokens spender is allowed to transfer on
     * behalf of the token owner
     * @param owner     Token owner's address
     * @param spender   Spender's address
     * @return Allowance amount
     */
    function allowance(
        address owner,
        address spender
    ) external view override returns (uint256) {
        return allowed[owner][spender];
    }

    /**
     * @dev Get totalSupply of token
     */
    function totalSupply() external view override returns (uint256) {
        return totalSupply_;
    }

    /**
     * @dev Get token balance of an account
     * @param account address The account
     */
    function balanceOf(
        address account
    ) external view override returns (uint256) {
        return balances[account];
    }

    /**
     * @notice Set spender's allowance over the caller's tokens to be a given
     * value.
     * @param spender   Spender's address
     * @param value     Allowance amount
     * @return True if successful
     */
    function approve(
        address spender,
        uint256 value
    )
        external
        override
        whenNotPaused
        notBlacklisted(msg.sender)
        notBlacklisted(spender)
        returns (bool)
    {
        _approve(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Internal function to set allowance
     * @param owner     Token owner's address
     * @param spender   Spender's address
     * @param value     Allowance amount
     */
    function _approve(
        address owner,
        address spender,
        uint256 value
    ) internal override {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        allowed[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /**
     * @notice Transfer tokens by spending allowance
     * @param from  Payer's address
     * @param to    Payee's address
     * @param value Transfer amount
     * @return True if successful
     */
    function transferFrom(
        address from,
        address to,
        uint256 value
    )
        external
        override
        whenNotPaused
        notBlacklisted(msg.sender)
        notBlacklisted(from)
        notBlacklisted(to)
        returns (bool)
    {
        require(
            value <= allowed[from][msg.sender],
            "ERC20: transfer amount exceeds allowance"
        );
        _transfer(from, to, value);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
        return true;
    }

    /**
     * @notice Transfer tokens from the caller
     * @param to    Payee's address
     * @param value Transfer amount
     * @return True if successful
     */
    function transfer(
        address to,
        uint256 value
    )
        external
        override
        whenNotPaused
        notBlacklisted(msg.sender)
        notBlacklisted(to)
        returns (bool)
    {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @notice Internal function to process transfers
     * @param from  Payer's address
     * @param to    Payee's address
     * @param value Transfer amount
     */
    function _transfer(
        address from,
        address to,
        uint256 value
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(
            value <= balances[from],
            "ERC20: transfer amount exceeds balance"
        );

        balances[from] = balances[from].sub(value);
        balances[to] = balances[to].add(value);
        emit Transfer(from, to, value);
    }

    /**
     * @dev Function to add/update a new minter
     * @param minter The address of the minter
     * @param minterAllowedAmount The minting amount allowed for the minter
     * @return True if the operation was successful.
     */
    function configureMinter(
        address minter,
        uint256 minterAllowedAmount
    ) external whenNotPaused onlyMasterMinter returns (bool) {
        minters[minter] = true;
        minterAllowed[minter] = minterAllowedAmount;
        emit MinterConfigured(minter, minterAllowedAmount);
        return true;
    }

    /**
     * @dev Function to remove a minter
     * @param minter The address of the minter to remove
     * @return True if the operation was successful.
     */
    function removeMinter(
        address minter
    ) external onlyMasterMinter returns (bool) {
        minters[minter] = false;
        minterAllowed[minter] = 0;
        emit MinterRemoved(minter);
        return true;
    }

    /**
     * @dev allows a minter to burn some of its own tokens
     * Validates that caller is a minter and that sender is not blacklisted
     * amount is less than or equal to the minter's account balance
     * @param _amount uint256 the amount of tokens to be burned
     */
    function burn(
        uint256 _amount
    ) external whenNotPaused onlyMinters notBlacklisted(msg.sender) {
        uint256 balance = balances[msg.sender];
        require(_amount > 0, "FiatToken: burn amount not greater than 0");
        require(balance >= _amount, "FiatToken: burn amount exceeds balance");

        totalSupply_ = totalSupply_.sub(_amount);
        balances[msg.sender] = balance.sub(_amount);
        emit Burn(msg.sender, _amount);
        emit Transfer(msg.sender, address(0), _amount);
    }

    function updateMasterMinter(address _newMasterMinter) external onlyOwner {
        require(
            _newMasterMinter != address(0),
            "FiatToken: new masterMinter is the zero address"
        );
        masterMinter = _newMasterMinter;
        emit MasterMinterChanged(masterMinter);
    }
}

contract FiatTokenV1_1 is FiatTokenV1 {}

abstract contract IFiatTokenV2 is FiatTokenV1_1 {
    uint8 internal _initializedVersion;

    /**
     * @notice Initialize v2
     * @param newName   New token name
     */
    function initializeV2(string calldata newName) external virtual;

    /**
     * @notice Increase the allowance by a given increment
     * @param spender   Spender's address
     * @param increment Amount of increase in allowance
     * @return True if successful
     */
    function increaseAllowance(
        address spender,
        uint256 increment
    )
        external
        whenNotPaused
        notBlacklisted(msg.sender)
        notBlacklisted(spender)
        returns (bool)
    {
        _increaseAllowance(msg.sender, spender, increment);
        return true;
    }

    /**
     * @notice Decrease the allowance by a given decrement
     * @param spender   Spender's address
     * @param decrement Amount of decrease in allowance
     * @return True if successful
     */
    function decreaseAllowance(
        address spender,
        uint256 decrement
    )
        external
        whenNotPaused
        notBlacklisted(msg.sender)
        notBlacklisted(spender)
        returns (bool)
    {
        _decreaseAllowance(msg.sender, spender, decrement);
        return true;
    }

    /**
     * @notice Execute a transfer with a signed authorization
     * @param from          Payer's address (Authorizer)
     * @param to            Payee's address
     * @param value         Amount to be transferred
     * @param validAfter    The time after which this is valid (unix time)
     * @param validBefore   The time before which this is valid (unix time)
     * @param nonce         Unique nonce
     * @param v             v of the signature
     * @param r             r of the signature
     * @param s             s of the signature
     */
    function transferWithAuthorization(
        address from,
        address to,
        uint256 value,
        uint256 validAfter,
        uint256 validBefore,
        bytes32 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external whenNotPaused notBlacklisted(from) notBlacklisted(to) {}

    /**
     * @notice Receive a transfer with a signed authorization from the payer
     * @dev This has an additional check to ensure that the payee's address
     * matches the caller of this function to prevent front-running attacks.
     * @param from          Payer's address (Authorizer)
     * @param to            Payee's address
     * @param value         Amount to be transferred
     * @param validAfter    The time after which this is valid (unix time)
     * @param validBefore   The time before which this is valid (unix time)
     * @param nonce         Unique nonce
     * @param v             v of the signature
     * @param r             r of the signature
     * @param s             s of the signature
     */
    function receiveWithAuthorization(
        address from,
        address to,
        uint256 value,
        uint256 validAfter,
        uint256 validBefore,
        bytes32 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external whenNotPaused notBlacklisted(from) notBlacklisted(to) {}

    /**
     * @notice Attempt to cancel an authorization
     * @dev Works only if the authorization is not yet used.
     * @param authorizer    Authorizer's address
     * @param nonce         Nonce of the authorization
     * @param v             v of the signature
     * @param r             r of the signature
     * @param s             s of the signature
     */
    function cancelAuthorization(
        address authorizer,
        bytes32 nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external whenNotPaused {}

    /**
     * @notice Update allowance with a signed permit
     * @param owner       Token owner's address (Authorizer)
     * @param spender     Spender's address
     * @param value       Amount of allowance
     * @param deadline    Expiration time, seconds since the epoch
     * @param v           v of the signature
     * @param r           r of the signature
     * @param s           s of the signature
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external whenNotPaused notBlacklisted(owner) notBlacklisted(spender) {}

    /**
     * @notice Internal function to increase the allowance by a given increment
     * @param owner     Token owner's address
     * @param spender   Spender's address
     * @param increment Amount of increase
     */
    function _increaseAllowance(
        address owner,
        address spender,
        uint256 increment
    ) internal {}

    /**
     * @notice Internal function to decrease the allowance by a given decrement
     * @param owner     Token owner's address
     * @param spender   Spender's address
     * @param decrement Amount of decrease
     */
    function _decreaseAllowance(
        address owner,
        address spender,
        uint256 decrement
    ) internal {}
}
