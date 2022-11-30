pragma solidity ^0.8.4;


interface IERC4626 {
    function asset() external view returns (address assetTokenAddress);

    function totalAssets() external view returns (uint256 totalManagedAssets);

    function convertToShares(uint256 assets) external view returns (uint256 shares);

    function convertToAssets(uint256 shares) external view returns (uint256 assets);

    function maxDeposit(address receiver) external view returns (uint256 maxAssets);

    function previewDeposit(uint256 assets) external view returns (uint256 shares);

    function deposit(uint256 assets, address receiver) external returns (uint256 shares);

    function maxMint(address receiver) external view returns (uint256 maxShares);

    function previewMint(uint256 shares) external view returns (uint256 assets);

    function mint(uint256 shares, address receiver) external returns (uint256 assets);

    function maxWithdraw(address owner) external view returns (uint256 maxAssets);

    function previewWithdraw(uint256 assets) external view returns (uint256 shares);

    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) external returns (uint256 shares);

    function maxRedeem(address owner) external view returns (uint256 maxShares);

    function previewRedeem(uint256 shares) external view returns (uint256 assets);

    function redeem(
        uint256 shares,
        address receiver,
        address owner
    ) external returns (uint256 assets);

    event Deposit(address indexed caller, address indexed owner, uint256 assets, uint256 shares);
    event Withdraw(
        address indexed caller,
        address indexed receiver,
        address indexed owner,
        uint256 assets,
        uint256 shares
    );
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
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
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

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
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
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
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
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

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
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
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

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}


interface IPotteryKeeper {
    function addActiveVault(address _vault) external;

    function removeActiveVault(address _vault, uint256 _pos) external;
}


interface ICakePool {
    function deposit(uint256 _amount, uint256 _lockDuration) external;

    function withdrawByAmount(uint256 _amount) external;

    function withdraw(uint256 _shares) external;

    function withdrawAll() external;

    function calculatePerformanceFee(address _user) external view returns (uint256);

    function calculateOverdueFee(address _user) external view returns (uint256);

    function calculateWithdrawFee(address _user, uint256 _shares) external view returns (uint256);

    function calculateTotalPendingCakeRewards() external view returns (uint256);

    function getPricePerFullShare() external view returns (uint256);

    function available() external view returns (uint256);

    function balanceOf() external view returns (uint256);
}

/**
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
        return msg.data;
    }
}

import {IERC165} from "@openzeppelin-4.6.0/contracts/utils/introspection/IERC165.sol";
import {Ownable} from "@openzeppelin-4.6.0/contracts/access/Ownable.sol";
import {SafeERC20, IERC20} from "@openzeppelin-4.6.0/contracts/token/ERC20/utils/SafeERC20.sol";
import {IRandomNumberGenerator} from "./interfaces/IRandomNumberGenerator.sol";
import {Pottery} from "./utils/Pottery.sol";
import {Vault} from "./utils/Vault.sol";
import {IPancakeSwapPotteryDraw} from "./interfaces/IPancakeSwapPotteryDraw.sol";
import {IPancakeSwapPotteryVault} from "./interfaces/IPancakeSwapPotteryVault.sol";
import {IPotteryVaultFactory} from "./interfaces/IPotteryVaultFactory.sol";
import {ICakePool} from "./interfaces/ICakePool.sol";
import {IPotteryKeeper} from "./interfaces/IPotteryKeeper.sol";

contract PancakeSwapPotteryDraw is IPancakeSwapPotteryDraw, Ownable {
    using SafeERC20 for IERC20;

    struct UserInfo {
        uint256 reward;
        uint256 winCount;
    }

    IERC20 immutable cake;
    ICakePool immutable cakePool;
    IRandomNumberGenerator rng;
    IPotteryVaultFactory vaultFactory;
    IPotteryKeeper keeper;

    uint8 constant NUM_OF_WINNER = 8;
    uint8 constant NUM_OF_DRAW = 10;
    uint32 constant POTTERY_PERIOD = 1 weeks;
    uint32 constant START_TIME_BUFFER = 2 weeks;
    uint32 constant DRAW_TIME_BUFFER = 1 weeks;

    mapping(address => Pottery.Pot) pots;

    mapping(address => UserInfo) public userInfos;

    Pottery.Draw[] draws;

    address treasury;
    uint16 public claimFee;

    bool initialize;

    event Init(address admin);

    event CreatePottery(
        address indexed vault,
        uint256 totalPrize,
        uint256 lockTime,
        uint256 drawTime,
        uint256 maxTotalDeposit,
        address admin
    );

    event RedeemPrize(address indexed vault, uint256 actualPrize, uint256 redeemPrize);

    event StartDraw(
        uint256 indexed drawId,
        address indexed vault,
        uint256 indexed requestId,
        uint256 totalPrize,
        uint256 timestamp,
        address admin
    );
    event CloseDraw(
        uint256 indexed drawId,
        address indexed vault,
        uint256 indexed requestId,
        address[] winners,
        uint256 timestamp,
        address admin
    );

    event ClaimReward(address indexed winner, uint256 prize, uint256 fee, uint256 winCount);

    event SetVaultFactory(address admin, address vaultFactory);

    event SetKeeper(address admin, address keeper);

    event SetTreasury(address admin, address treasury);

    event SetClaimFee(address admin, uint16 fee);

    event CancelPottery(address indexed vault, uint256 totalPrize, address admin);

    modifier onlyKeeperOrOwner() {
        require(msg.sender == address(keeper) || msg.sender == owner(), "only keeper or owner");
        _;
    }

    constructor(IERC20 _cake, ICakePool _cakePool) {
        require(address(_cake) != address(0) && address(_cakePool) != address(0), "zero address");

        cake = _cake;
        cakePool = _cakePool;

        initialize = false;
    }

    function init(
        address _rng,
        address _vaultFactory,
        address _keeper,
        address _treasury
    ) external onlyOwner {
        require(!initialize, "init already");

        require(IERC165(_rng).supportsInterface(type(IRandomNumberGenerator).interfaceId), "invalid rng");
        rng = IRandomNumberGenerator(_rng);

        setVaultFactory(_vaultFactory);
        setKeeper(_keeper);
        setTreasury(_treasury);
        setClaimFee(800);

        initialize = true;
        emit Init(msg.sender);
    }

    function generatePottery(
        uint256 _totalPrize,
        uint256 _lockTime,
        uint256 _drawTime,
        uint256 _maxTotalDeposit
    ) public override onlyOwner {
        require(_totalPrize > 0, "zero prize");
        // draw time must be larger than lock time
        require(_drawTime > _lockTime, "draw time earlier than lock time");
        // draw time must be within 1 week of the lock time to finish the draw before unlock
        require(_drawTime < _lockTime + DRAW_TIME_BUFFER, "draw time outside draw buffer time");
        // everything must start in 2 weeks
        require(_drawTime < block.timestamp + START_TIME_BUFFER, "draw time outside start buffer time");
        // the _maxDepositAmount should be greater than 0
        require(_maxTotalDeposit > 0, "zero total deposit");
        uint256 denominator = NUM_OF_DRAW * NUM_OF_WINNER;
        uint256 prize = _totalPrize / denominator;
        require(prize > 0, "zero prize in each winner");
        require(prize % denominator == 0, "winner prize has reminder");

        cake.safeTransferFrom(msg.sender, address(this), _totalPrize);
        address vault = vaultFactory.generateVault(
            cake,
            cakePool,
            PancakeSwapPotteryDraw(address(this)),
            msg.sender,
            address(keeper),
            _lockTime,
            _maxTotalDeposit
        );
        require(vault != address(0), "zero deploy address");
        IPotteryKeeper(keeper).addActiveVault(vault);
        pots[vault] = Pottery.Pot({
            numOfDraw: 0,
            totalPrize: _totalPrize,
            drawTime: _drawTime,
            lastDrawId: 0,
            startDraw: false
        });

        emit CreatePottery(vault, _totalPrize, _lockTime, _drawTime, _maxTotalDeposit, msg.sender);
    }

    function redeemPrizeByRatio() external override {
        // only allow call from vault
        uint256 totalPrize = pots[msg.sender].totalPrize;
        require(totalPrize > 0, "pot not exist");
        require(IPancakeSwapPotteryVault(msg.sender).getStatus() == Vault.Status.BEFORE_LOCK, "pot pass before lock");
        uint256 depositRatio = (IPancakeSwapPotteryVault(msg.sender).totalAssets() * 10000) /
            IPancakeSwapPotteryVault(msg.sender).getMaxTotalDeposit();
        uint256 actualPrize = (totalPrize * depositRatio) / 10000;

        uint256 denominator = NUM_OF_DRAW * NUM_OF_WINNER;
        uint256 prize = actualPrize / denominator;
        require(prize > 0, "zero prize in each winner");
        if (actualPrize % denominator != 0) actualPrize -= actualPrize % denominator;

        uint256 redeemPrize = totalPrize - actualPrize;
        pots[msg.sender].totalPrize = actualPrize;
        if (redeemPrize > 0) cake.safeTransfer(treasury, redeemPrize);

        emit RedeemPrize(msg.sender, actualPrize, redeemPrize);
    }

    function startDraw(address _vault) external override onlyKeeperOrOwner {
        Pottery.Pot storage pot = pots[_vault];
        require(pot.totalPrize > 0, "pot not exist");
        require(pot.numOfDraw < NUM_OF_DRAW, "over draw limit");
        require(timeToDraw(_vault), "too early to draw");
        if (pot.startDraw) {
            Pottery.Draw memory draw = draws[pot.lastDrawId];
            require(draw.closeDrawTime != 0, "last draw has not closed");
        }
        uint256 prize = pot.totalPrize / NUM_OF_DRAW;
        uint256 requestId = rng.requestRandomWords(NUM_OF_WINNER, _vault);
        uint256 drawId = draws.length;
        draws.push(
            Pottery.Draw({
                requestId: requestId,
                vault: IPancakeSwapPotteryVault(_vault),
                startDrawTime: block.timestamp,
                closeDrawTime: 0,
                winners: new address[](NUM_OF_WINNER),
                prize: prize
            })
        );

        pot.lastDrawId = drawId;
        if (!pot.startDraw) pot.startDraw = true;

        emit StartDraw(drawId, _vault, requestId, prize, block.timestamp, msg.sender);
    }

    function forceRequestDraw(address _vault) external override onlyOwner {
        Pottery.Pot storage pot = pots[_vault];
        Pottery.Draw storage draw = draws[pot.lastDrawId];
        require(address(draw.vault) != address(0), "draw not exist");
        require(draw.startDrawTime != 0 && draw.closeDrawTime == 0, "draw has closed");
        require(!rng.fulfillRequest(draw.requestId), "request has fulfilled");
        uint256 requestId = rng.requestRandomWords(NUM_OF_WINNER, _vault);

        draw.requestId = requestId;

        emit StartDraw(pot.lastDrawId, _vault, requestId, draw.prize, block.timestamp, msg.sender);
    }

    function closeDraw(uint256 _drawId) external override onlyKeeperOrOwner {
        Pottery.Draw storage draw = draws[_drawId];
        require(address(draw.vault) != address(0), "draw not exist");
        require(draw.startDrawTime != 0, "draw has not started");
        require(draw.closeDrawTime == 0, "draw has closed");
        draw.closeDrawTime = block.timestamp;

        require(draw.requestId == rng.getLatestRequestId(address(draw.vault)), "requestId not match");
        require(rng.fulfillRequest(draw.requestId), "rng request not fulfill");
        uint256[] memory randomWords = rng.getRandomWords(draw.requestId);
        require(randomWords.length == NUM_OF_WINNER, "winning number not match");
        address[] memory winners = draw.vault.draw(randomWords);
        require(winners.length == NUM_OF_WINNER, "winners not match");
        uint256 eachWinnerPrize = draw.prize / NUM_OF_WINNER;
        for (uint256 i = 0; i < NUM_OF_WINNER; i++) {
            draw.winners[i] = winners[i];
            userInfos[winners[i]].reward += eachWinnerPrize;
            userInfos[winners[i]].winCount += 1;
        }

        Pottery.Pot storage pot = pots[address(draw.vault)];
        pot.numOfDraw += 1;

        emit CloseDraw(_drawId, address(draw.vault), draw.requestId, draw.winners, block.timestamp, msg.sender);
    }

    function claimReward() external override {
        require(userInfos[msg.sender].reward > 0, "nothing to claim");
        uint256 reward = userInfos[msg.sender].reward;
        uint256 winCount = userInfos[msg.sender].winCount;
        uint256 fee = (reward * claimFee) / 10000;
        userInfos[msg.sender].reward = 0;
        userInfos[msg.sender].winCount = 0;
        if (fee > 0) cake.safeTransfer(treasury, fee);
        cake.safeTransfer(msg.sender, (reward - fee));

        emit ClaimReward(msg.sender, reward, fee, winCount);
    }

    function timeToDraw(address _vault) public view override returns (bool) {
        Pottery.Pot storage pot = pots[_vault];
        if (pot.startDraw) {
            Pottery.Draw storage draw = draws[pot.lastDrawId];
            return (draw.startDrawTime + POTTERY_PERIOD <= block.timestamp);
        } else {
            return (pot.drawTime <= block.timestamp);
        }
    }

    function rngFulfillRandomWords(uint256 _drawId) public view override returns (bool) {
        Pottery.Draw storage draw = draws[_drawId];
        return rng.fulfillRequest(draw.requestId);
    }

    function getWinners(uint256 _drawId) external view override returns (address[] memory) {
        return draws[_drawId].winners;
    }

    function getDraw(uint256 _drawId) external view override returns (Pottery.Draw memory) {
        return draws[_drawId];
    }

    function getPot(address _vault) external view override returns (Pottery.Pot memory) {
        return pots[_vault];
    }

    function getNumOfDraw() external view override returns (uint8) {
        return NUM_OF_DRAW;
    }

    function getNumOfWinner() external view override returns (uint8) {
        return NUM_OF_WINNER;
    }

    function getPotteryPeriod() external view override returns (uint256) {
        return POTTERY_PERIOD;
    }

    function getTreasury() external view override returns (address) {
        return treasury;
    }

    function setVaultFactory(address _factory) public onlyOwner {
        require(_factory != address(0), "zero address");
        vaultFactory = IPotteryVaultFactory(_factory);

        emit SetVaultFactory(msg.sender, _factory);
    }

    function setKeeper(address _keeper) public onlyOwner {
        require(_keeper != address(0), "zero address");
        keeper = IPotteryKeeper(_keeper);

        emit SetKeeper(msg.sender, _keeper);
    }

    function setTreasury(address _treasury) public onlyOwner {
        require(_treasury != address(0), "zero address");
        treasury = _treasury;

        emit SetTreasury(msg.sender, _treasury);
    }

    function setClaimFee(uint16 _fee) public onlyOwner {
        require(_fee <= 1000, "over max fee limit");
        claimFee = _fee;

        emit SetClaimFee(msg.sender, _fee);
    }

    function cancelPottery(address _vault) external onlyOwner {
        require(IPancakeSwapPotteryVault(_vault).getStatus() == Vault.Status.BEFORE_LOCK, "pottery started");
        Pottery.Pot storage pot = pots[_vault];
        require(pot.totalPrize > 0, "pottery not exist");
        require(pot.numOfDraw == 0, "pottery cancelled");
        uint256 prize = pot.totalPrize;
        pot.totalPrize = 0;
        pot.numOfDraw = NUM_OF_DRAW;
        cake.safeTransfer(treasury, prize);

        emit CancelPottery(_vault, prize, msg.sender);
    }
}