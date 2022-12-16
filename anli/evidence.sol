// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7; 

// 定义接口
interface IEvdence{
    //验证是否具备签名资格
    function verify(address _signer) external view returns(bool);
    //查看签名者的信息
    function getSigner(uint256 _index) external view returns(address);
    // 需要签名者的数量
    function getSignerSize() external view returns(uint256);

}

// 存证合约
contract Evidence{
    // 先定义数据
    string evidence;                // 存证信息
    address[]  signers;             // 签过名的列表
    address public factoryAddr;     // 工厂合约地址
    
    //event
    event NewSignaturesEvidence(string _evi,address _sender);
    event AddRepeatSignaturesEvidence(string _evi,address _sender);
    event AddSignaturesEvidence(string _evi,address _sender);


   //function
    // 先验证构造函数a是否能被创建出来（看看调用的人是否有资格）
    function callVerify(address _signer) public view returns(bool){
        // 查看是否具备验证资格
        return IEvdence(factoryAddr).verify(_signer);
    }
    
    // 构造函数
    constructor(string memory _evi,address _factory){
        factoryAddr = _factory;
        // tx.origin  交易的原始发起者
        require(callVerify(tx.origin)," _signer is not valid");
        evidence = _evi;
        signers.push(tx.origin);
        // 写入事件
        emit NewSignaturesEvidence(_evi,tx.origin);
        
    }



    // 查看存证信息
    function getEvidence() public view returns(string memory,address[] memory,address[] memory){
        // 先获取签名者的数量
        uint256 iSize = IEvdence(factoryAddr).getSignerSize();
        // 定义一个本地的遍历储存数组
        address[] memory signerlist = new address[](iSize);
        //遍历签名者
        for( uint256 i = 0; i < iSize; i++ ){
            // 把遍历结果存储到本地数组中
            signerlist[i] =  IEvdence(factoryAddr).getSigner(i);
        }
        // 返回数据
        return(evidence,signerlist,signers);
    }

    //存证信息中签名的功能
    function sign() public returns(bool){
        // 判断是否具备签名的资格
        require(callVerify(tx.origin)," _signer is not valid");
        // 判断他是否是重复操作
        if(isSigned(tx.origin)){
            emit AddRepeatSignaturesEvidence(evidence,tx.origin);
            return true;
        }
        //如果没有重复操作 开始真正的签名
        // 把该地址加到签名列表中
        signers.push(tx.origin);
        emit AddSignaturesEvidence(evidence,tx.origin);
        return true;
        
    }
    // 判断是否已经签过名
    function isSigned(address _signer)internal view returns(bool){
        // 判断是否在列表中
        //遍历签名者列表
        for(uint256 i = 0 ; i < signers.length; i++ ){
            // 判断是否已经签名
            if(signers[i] == _signer ){
                return true;
            }
        }
        //循环结束没有返回true
        return false;
    }

    // 如果要求所有的多签人都进行签名
    function isAllSigned()public view returns(bool,string memory){
        //对比两个数组是否相等
        uint256 iSize = IEvdence(factoryAddr).getSignerSize();
        for(uint256 i = 0 ; i < iSize; i++ ){
            //判断一旦有一个不在就 false
            if(!isSigned(IEvdence(factoryAddr).getSigner(i))){
                // 返回一个空值
                return (false," ");
            }
        }
        // 循环结束没有返回false 就代表着都签了
        return (true,evidence);
    }

}