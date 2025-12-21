// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Factorial {

    // Function to calculate factorial of n
    function factorial(uint n) public pure returns (uint) {
        uint result = 1;

        for (uint i = 1; i <= n; i++) {
            result *= i;
        }

        return result;
    }
}
