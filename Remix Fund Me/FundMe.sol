// Get funds from the users
// Withdraw funds
// Set a minimum funding value in USD 

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// solhint-disable-next-line interface-starts-with-i
/* interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}
*/

import {PriceConverter} from "./PriceConverter.sol";


contract FundMe {
    using PriceConverter for uint256;
    uint256 public minimumUSD = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    
    function fund() public payable {
       require(msg.value.getConversionRate()>= minimumUSD, "didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }
    function withdraw() public {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
          address funder = funders[funderIndex];
          addressToAmountFunded[funder] = 0;
     }
     //reset the Array
      funders = new address[](0);
    // actually withdraw the funds

    // 1. transfer
    // 2. send
    // 3. call
    // msg.sender = address
    // payable(msg.sender) = payable address

    // transfer 
    // payable(msg.sender).transfer(address(this).balance);
    // // send
    // bool sendSuccess = payable(msg.sender).send(address(this).balance);
    // require(sendSuccess, "Send failed");
    // call

   (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
   require(callSuccess, "Call failed");

   }
}