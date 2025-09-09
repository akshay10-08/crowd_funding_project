// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Funding_Contract {
  address public creator;
  uint256 public goal;
  uint256 public deadline;

mapping(address => uint256) public contributions;
uint256 public totalcontri;
bool isFunded;
bool isCompleted;

event goalReached (uint256 totalcontri);
event fundTransfer (address backer , uint256 amount );
event deadlineReached (uint256 totalContri);

constructor (uint256 fundingGoal, uint256 time){
creator = msg.sender;
goal = fundingGoal * 1 ether;
deadline = block.timestamp + time * 1 minutes;

isFunded = false;
isCompleted = false;
}

modifier onlycreator() {
    require (creator==msg.sender , "Only creator can call this function");
    _;
}
function contribute() public payable {
    require(block.timestamp < deadline, "Deadline has passed");
    require(!isCompleted, "crowd funding is completed");

    uint256 amount = msg.value;
    contributions[msg.sender] += amount;
    totalcontri += amount;

    if(totalcontri >= goal){
    isFunded = true;
    }

emit fundTransfer(msg.sender, amount);
}

function withdrawFunds () onlycreator public{
    require(isFunded, "Goal has not been reached");
    require(!isCompleted, "Crowd Funding is alredy completed");

    isCompleted = true ; 
payable (creator).transfer(address(this).balance);

}
function getCurrentBalance()  public view returns(uint256){
    return address(this).balance;
}

}
