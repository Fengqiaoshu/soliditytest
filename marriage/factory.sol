// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7; 

// 倒入存证合约
import "./evidence.sol";
// 工厂合约
// 继承存证合约的接口
contract EvidenceFactory is IEvdence{
    //工厂合约签名列表
    address[] signers;
    // 存证合约的信息
    mapping(string=>address) evi_keys;

    // 事件
    event NewEvidence(string  _evi, address _sender, address _eviAddr);

    //构造函数 接受参数
    constructor(address[] memory _signers){
        // 遍历数组
        for(uint256 i = 0;i < _signers.length;i++ ){
            //把内容更新进去
            signers.push(_signers[i]);
        }
    } 
    //验证是否具备签名资格
    function verify(address _signer) override external view returns(bool){
        for(uint256 i = 0;i < signers.length;i++){
            if(signers[i] == _signer){
                return true;
            }
        }
        return false;
    }
    //查看签名者的信息
    function getSigner(uint256 _index)override external view returns(address){
        // 判断是否越界 避免越界报错
        if(_index < signers.length){
            return signers[_index];
        }else{
            return address(0);
        }
    }
    // 需要签名者的数量
    function getSignerSize()override external view returns(uint256){
        return signers.length;
    }

    // 创建一个存证
    function newEvidence(string memory _evi,string memory _key)public returns(address){
        Evidence evidence = new Evidence(_evi,address(this));

        evi_keys[_key] = address(evidence);

        emit NewEvidence(_evi,msg.sender,address(evidence));

        return address(evidence);
    }

    // 查看存证合约
    function getEvidence(string memory _key)public view returns(string memory,address[] memory,address[] memory){
        // 按照key去查地址
        address addr = evi_keys[_key];

        return Evidence(addr).getEvidence();
    }

    // 签名方法
    function sign(string memory _key)public returns(bool){
        address addr = evi_keys[_key];
        // 获取具体的签名
        return Evidence(addr).sign();
    }

    //
    function isAllSigned(string memory _key)public view returns(bool,string memory){
        address addr = evi_keys[_key];
        // 获取具体的签名
        return Evidence(addr).isAllSigned();
    }
}