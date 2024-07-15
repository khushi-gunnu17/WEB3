// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "./Ownable.sol";

contract CourseRegistration is Ownable {

    struct Payment {
        address user;
        string email;       // It is hard to do email validation in solidity.
        uint amount;
    }

    uint public courseFee;
    Payment[] public payments;

    // event
    event PaymentReceived(address indexed user, string email, uint amount);

    constructor (uint _courseFee) Ownable(msg.sender) {
        courseFee = _courseFee;
    }


    function payForCourse(string memory email) public payable {
        require(msg.value == courseFee, "Payment must be equal to the course fee.");
        payments.push(Payment(msg.sender, email, msg.value));
        emit PaymentReceived(msg.sender, email, msg.value);
    }


    // withdrawing the amount so the owner can access the cash received.
    function withdrawFunds() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }


    function getPaymentsByUser(address userAddress) public view returns (Payment[] memory) {

        uint count = 0;     // It will be used to count the number of payments made by the given user.

        for(uint i=0 ; i < payments.length ; i++) {
            if (payments[i].user == userAddress) {
                count++;
            }
        }

        Payment[] memory userPayments = new Payment[](count);

        uint index = 0;

        for (uint i=0 ; i<payments.length ; i++) {
            if (payments[i].user == userAddress) {
                userPayments[index] = payments[i];
                index++;
            }
        }

        // This returns the userPayments array, which contains all the payments made by the given user.
        return userPayments;
    }


    // This declares a public view function getAllPayments that returns the entire payments array. It allows anyone to view all the payments made to the contract.
    function getAllPayments() public view returns (Payment[] memory) {
        return payments;
    }

}