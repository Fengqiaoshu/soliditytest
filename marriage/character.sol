// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7; 

// 导入
import "./role.sol";

contract Character{
    // using下 要用到的数据对象
    using Role for Role.PersonRole;
    // 定义一个具体的数据对象
    Role.PersonRole characters;
    address[] allCharacters;
    address owner;


    constructor(){
        // 谁部署的谁就是管理员
        owner = msg.sender;
    }

    // 定义一个描述符
    modifier onlyOwner(){
        require(msg.sender == owner," only owner can do ");
        _;
    }


    function isCharacter(address _person) public view returns(bool){
        return characters.isRole(_person);
    }


    function addCharacter(address _person,string memory _summary) public onlyOwner returns(bool) {
        bool ok = characters.addRole(_person, _summary);
        require(ok,"add role failed");
        allCharacters.push(_person);
        return true;
    }

    function removeCharacter(address _person) public onlyOwner returns(bool) {
        bool ok = characters.removeRole(_person);
        require(ok,"remove role failed");
        //delete array[]  先找到要删除的元素
        uint256 index = 0;  // 定义一个下标
        for( ; index <allCharacters.length;index ++){
            // 如果找到值了 就退出循环
            if(_person == allCharacters[index]){
                break;
            }
        }
        //[1,2,3,4,5,6] index =3 

        if(index < allCharacters.length -1){
            // 说明找到了 然后把这个下标的值和最后一个值置换 删除最后一个值
            allCharacters[index] = allCharacters[allCharacters.length -1];
            // 删除最后一个元素
            allCharacters.pop();
        }else if(index == allCharacters.length -1){
            allCharacters.pop();
        }
        return true;
    }

    function resetCharacter(address _person,string memory _summary) public onlyOwner returns(bool){
        bool ok = characters.restRole(_person, _summary);
        require(ok,"rest role failed");

        return true;
    }

}