// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7; 

// 倒入存证合约
import "./evidence.sol";
// 工厂合约
// 继承存证合约的接口
contract EvidenceFactory{
    //工厂合约签名列表
    address[] signers;
    // 存证合约的信息
    mapping(string=>address) evi_keys;

    // 事件             存证的名字    存证的key      谁创建的
    event NewEvidence(string  _evi,string _key, address _sender);


    // 创建一个存证
    function newMarriageEvidence(string memory _evi,string memory _key,address _a,address _b)public returns(address){
        MarriageEvidence evidence = new MarriageEvidence(_evi,_a,_b);

        evi_keys[_key] = address(evidence);

        emit NewEvidence(_evi,_key,msg.sender);

        return address(evidence);
    }

    // 查看存证合约
    function getEvidence(string memory _key)public view returns(string memory,address[] memory,address[] memory){
        // 按照key去查地址
        address addr = evi_keys[_key];

        return MarriageEvidence(addr).getEvidence();
    }

    // 签名方法
    function sign(string memory _key)public returns(bool){
        address addr = evi_keys[_key];
        // 获取具体的签名
        return MarriageEvidence(addr).sign();
    }

    //
    function isAllSigned(string memory _key)public view returns(bool,string memory){
        address addr = evi_keys[_key];
        // 获取具体的签名
        return MarriageEvidence(addr).isAllSigned();
    }
}