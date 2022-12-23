// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7; 

import "./factory.sol";
import "./character.sol";

contract Marriage is Character {
    // 记录下工厂合约的地址
    EvidenceFactory eviFactory;
    //构造函数
    constructor (){

        addCharacter(msg.sender, "witness1");
        // 创建工厂合约
        eviFactory = new EvidenceFactory();
    }

    // 颁发证书
    function newMarriageEvidence(string memory _evi,string memory _key,address _a,address _b)public {
       // 判断调用合约的地址是不是具有资格
       require(isCharacter(msg.sender), " sender is not witness");
       // 调用合约内的方法
        eviFactory.newMarriageEvidence(_evi, _key, _a, _b);
    }


    // 签名的逻辑
    function sign(string memory _key) public returns(bool) {
        return eviFactory.sign(_key);
    }


    // 获取
    function getEvidence(string memory _key)public view returns(string memory,address[] memory,address[] memory){
        return eviFactory.getEvidence(_key);
    }

    // 验证签名是否全部都签过
    function isAllSigned(string memory _key)public view returns(bool,string memory){
       return eviFactory.isAllSigned(_key);
    }

}