// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7;

contract Car{
    string brandName;  
    uint256 value;
    string version;

    constructor(string  memory _name,uint256 _val, string memory _ver){
        brandName = _name;
        value = _val;
        version  = _ver;
    }

    function getInfo()public view returns(string memory,uint256 ,string memory){
        return (brandName,value,version);
    }
}


contract factory{
    address[] allCars;

    function product(string memory _name,uint256 _val,string memory _ver)public{
    
        Car car = new Car(_name,_val,_ver);
        allCars.push(address(car));
    }

    function getAllCars() public view returns(address[] memory){
        return allCars;
    }
}