// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0; 

// Solidity Value Types.

// Signed Integers.
/**
 * Negative numbers are allowed for Signed Integer types. e.g int8 public i8 = -1;
 */

// Unsigned Integers.
/** 
 * non negative integers. e.g uint public u256 = 456;
 */

// Boolean.
/**
 * This data type accepts only two values True or False. e.g bool public boo = true;
 */

// Addresses.
/** 
 * Address hold a 20-byte value which represents the size of an  Ethereum address. An address can be used 
 * to get balance or to transfer a balance by balance and transfer method respectively. e.g. address public addr = 0xCA35
 */

// Enums.
/**
 * Enums are used to create user-defined data types, used to assign a name to an integral constant which makes the contract 
 * more readable, maintainable, and less prone to errors. Options of enums can be represented by unsigned integer values 
 * starting from 0. e.g. enum ActionChoices { GoLeft, GoRight, GoStraight, SitStill }
 */


// Bytes.
/**
 * Although bytes are similar to strings, there are some differences between them. bytes are used to store a fixed-sized 
 * character set while the string is used to store the character set equal to or more than a byte. The length of bytes 
 * is from 1 to 32, while the string has a dynamic length. Byte has the advantage that it uses less gas, so better to use 
 * when we know the length of data. e,g. bytes1 a = 0xb5; //  [10110101]
 */

 
   
// Creating a contract
contract Types {   
    
    // Initializing Bool variable
    bool public boolean = false;
    
    // Initializing Signed Integer variable
    int32 public int_var = -60313;

    // Initializing Unsigned Integer Variable
    uint8 public u8 = 1;
 
    //  Initializing String variable
    string public str = "GrowicSolidity";
 
    // Initializing Byte variable
    bytes1 public b = "a";
     
    // Defining an enumerator
    enum my_enum { Growic_, _for, _Geeks } 
 
     
}