// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7;

// 接口
interface IA {
    
    function setName(string memory _name )external;

    function getName() external view returns(string memory);
}

// 集成接口的合约
contract A is IA {
    string myname;

    function setName(string memory _name )override external{
        myname = _name;
    }

    function getName()override external view returns(string memory ){
        return myname;
    }
}

contract call_demo{
    IA a;

    constructor (address addr){
        a = IA(addr);
    }

    function upgrade(address addr)public{
        a = IA(addr);
    }

     function setName(string memory _name )public{
        a.setName(_name);
    }

    function getName() public view returns(string memory ){
        return a.getName();
    }
}