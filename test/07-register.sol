// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7;


struct ContratInfo{
    address builder;    // 构建者
    address crtAddr;    // 合约的地址
    string  version;    // 合约版本 
}

contract register_demo{
    mapping(string=>ContratInfo) contracts; // 记录的合约信息
    address owner;

    constructor(){
        owner = msg.sender;
    }

    function  addContract(string memory _nameKey,address _addr, string memory _ver)public{
        // 判断如果如果是第一次
        if(contracts[_nameKey].crtAddr == address(0)){
            // 赋值参数
            contracts[_nameKey].builder = msg.sender;
            contracts[_nameKey].crtAddr = _addr;
            contracts[_nameKey].version =  _ver;
        }else{
            contracts[_nameKey].crtAddr = _addr;
            contracts[_nameKey].version =  _ver;
        }
    }

    function getInfo(string memory _nameKey) public view returns(ContratInfo memory){
        return contracts[_nameKey];
    }
}