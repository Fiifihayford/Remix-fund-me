// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;
import {AggregatorV3Interface} from "@chainlink/contracts@1.2.0/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
library priceconverter{
    function getprice() internal view returns(uint256){//This is going to get the price of ether in USD
      //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
      //ABI
       AggregatorV3Interface priceFeed = AggregatorV3Interface(0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF);
       (,int256 price,,,)=priceFeed.latestRoundData();
        return uint256(price * 1e10 );//chainlink price feed returns price in 8 decimal places
      
    }

    
    function getConversionRate(uint256 ethAmount)internal view returns(uint256) { // Convert the value of etherum in terms on USD base of the price
      //1 ETH
      // 2000_000000000000000000
      uint256 ethprice = getprice();
      //(2000_000000000000000000 * 1_000000000000000000) / 1e18;
      uint256 ethAmountInUsd = (ethprice * ethAmount)/ 1e18;
      return ethAmountInUsd;

    }
}