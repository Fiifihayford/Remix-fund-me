// SPDX-License-Identifier: MIT

pragma solidity  ^ 0.8.18;
import{priceconverter} from "./priceconverter.sol";
 
 error NotOwner();
 contract FundMe{
    uint256 constant MINIMUM_USD = 5e18;// Minimum amount a sender can send in this contract.(5e18 = 5 *10**18)
    using priceconverter for uint256;
    address[] public funders; // Contains the list of all addresses that funded the account.
    mapping(address addressOfFunders=> uint256 AmountFundedbyFunders) public addressToAmountFunded;
    address public immutable I_owner;

    constructor() {
       I_owner = msg.sender;
    }

      modifier onlyOwner(){// This function makes it possible for you to  execute onlyOwner() to any function you want
        //require(msg.sender == I_owner, "Must be the owner");

        if(msg.sender != I_owner){ 
            revert NotOwner();
        }
        _;
     }   

    function fund()public payable{

      require(msg.value.getConversionRate() >= MINIMUM_USD, "Value not greater than 1 ether");
      funders.push(msg.sender);// This line pushes the address of whoever calls this function(Whoever sends money using this function)
       addressToAmountFunded[msg.sender]+= msg.value; // Tops up the value of the address of the sender incase the sender sends an amount more than once
    }

    function withdraw() public onlyOwner{

       for(uint256 fundersIndex = 0; fundersIndex < funders.length; fundersIndex++){
         address getaddress = funders[fundersIndex];
           addressToAmountFunded[getaddress]=0;
       }
       funders = new address[](0);// resets the address(empty);
       
       (bool callSuccess,) = payable(msg.sender).call{value:address(this).balance}("");
         require(callSuccess, "Call Failed");

    }

   receive() external payable {
      fund();
   }

   fallback() external payable{
      fund();
   }
    
}