// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7;

// mapping 迭代器

contract mapping_iterator{
    mapping(string=>uint256) points;
    string[] names;

    function addStudent(string memory _name,uint256 _points) public {
        require(points[_name] == 0, "student already exists");

        points[_name] = _points;
        names.push(_name);
    }

    function getSum() public view returns(uint256){
        uint256 sum = 0;
        for(uint256 i = 0; i< names.length; i++ ){
            sum += points[names[i]];
        }

        return sum;

    }
}