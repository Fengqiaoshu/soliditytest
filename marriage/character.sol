// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7; 


import "./role.sol";

contract Character{
    using Role for Role.PersonRole;

    Role.PersonRole characters;
    address[] allCharacters;
    address owner;
}