// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;
import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract Flashloan is FlashLoanSimpleReceiverBase {
    address payable owner;

    constructor(address _addressProvider)
        FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider))
    {}

/*
@param _token adddress of USDC token
@param _amount of USDC with 6 zeros
*/
    function fn_RequestFlashLoan(address _token, uint256 _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        //
        // This contract now has the funds requested.
        // Your logic goeas here.
        //

        // At the end of your logic above, this contract owes
        // the flashloaned amount + premiums.
        // Therefore ensure your contract has enough to repay
        // these amounts.

        // Approve the Pool contract allowance to *pull* the owed amount
        uint256 totalAmount = amount + premium;
        IERC20(asset).approve(address(POOL), totalAmount);

        return true;
    }

    receive() external payable {}
}
/*
 * Definitaion: Flashloans are loans that are taken without any collateral.
 * A special type of transaction where borrowed amount is returned in the same trnasaction.
 * Not available on Ethereum but on Optimism, Harmony, Avalanche, Polygon, Fantom

 ** FlashLoanSimpleReceiverBase: This is a base contract provided by the Aave Protocol that provides a
     convenient interface for executing flash loans. It contains functions that handle the loan execution, such as executeOperation().

 ** IPoolAddressesProvider: This is an interface that defines the functions for interacting with the Aave LendingPool contract.
     It provides access to the contract addresses of the Aave Protocol, such as the addresses of the LendingPool and the LendingPoolParametersProvider.
 */
