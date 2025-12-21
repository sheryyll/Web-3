// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SumOfNumbers {

    // Function to calculate sum of first N natural numbers
    function sum(uint n) public pure returns (uint) {
        uint total = 0;

        for (uint i = 1; i <= n; i++) {
            total += i;
        }

        return total;
    }
}
