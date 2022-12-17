// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7; 

library Role {
    struct PersonRole{
        mapping(address=>bool) isExists;    // 是否存在
        mapping(address=>string) summary;   // 具体信息
    }

    // 判断是否存在
    function isRole(PersonRole storage _role,address _person)internal view returns(bool) {
       if(_person == address(0)){
        return false;
       }
        return _role.isExists[_person];
    }

    // 增加
    function addRole(PersonRole storage _role,address _person,string memory _summary) internal returns(bool){
        if(isRole(_role, _person)){
            return false;
        }
        _role.isExists[_person] = true;
        _role.summary[_person]  = _summary;
        return true;
    }
    // 删除
    function removeRole(PersonRole storage _role,address _person)internal returns(bool){
        if(!isRole(_role, _person)){
            return false;
        }
        delete _role.isExists[_person];
        delete _role.summary[_person];
        return true;
    }
    // 修改
    function restRole(PersonRole storage _role,address _person,string memory _summary)internal returns(bool) {
        if(isRole(_role, _person)){
            return false;
        }
        _role.summary[_person]  = _summary;
        return true;
    }

}