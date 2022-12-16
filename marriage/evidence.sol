// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7; 

// 定义接口
interface IEvdence{
    //验证是否具备签名资格
    function verify(address _signer) external view returns(bool);
    //签名函数
    function sign() external  returns(bool);
    // 需要签名者的数量
    function getEvidence() external view returns(string memory,address[] memory,address[] memory);

}

// 存证合约  继承接口
contract MarrigeEvidence is IEvdence {
    // 先定义数据
    string evidence;                // 存证信息
    address[] needSigners;          // 需要签名的列表
    address[]  signers;             // 签过名的列表
    
    //event
    event NewMarrigeEvidence(string _evi,address _sender,address _a,address _b);
    event AddRepeatSignaturesEvidence(string _evi,address _sender);
    event AddSignaturesEvidence(string _evi,address _sender);


    
    // 构造函数
    constructor(string memory _evi,address _a, address _b){
        // 判断地址是否有效
        require(address(0) != _a," _a is invalid address ");
        require(address(0) != _b," _b is invalid address ");
        // 判断不能是本身的地址
        require(_a != tx.origin," _a can not verifier ");
        require(_b != tx.origin," _b can not verifier ");

        needSigners.push(tx.origin);
        needSigners.push(_a);
        needSigners.push(_b);
        signers.push(tx.origin);
        evidence = _evi;
        emit NewMarrigeEvidence(_evi,tx.origin,_a,_b);
        
    }



    // 查看存证信息
    function getEvidence()override external view returns(string memory,address[] memory,address[] memory){
        
        return(evidence,needSigners,signers);
    }

   

    //存证信息中签名的功能
    function sign() override external  returns(bool){
        // 判断是否具备签名的资格
        require(_verify(tx.origin)," _signer is not valid");
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

    // 外部函数 允许外部调用
    function verify(address _signer)override external view returns(bool){
        return _verify(_signer);
    }

     //验证是否具有签名资格 只允许内部调用
    function _verify(address _signer) internal view returns(bool){
         for(uint256 i = 0 ; i < needSigners.length; i++ ){
            // 判断是否已经签名
            if(needSigners[i] == _signer ){
                return true;
            }
        }
        //循环结束没有返回true
        return false;
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
        
        for(uint256 i = 0 ; i < needSigners.length; i++ ){
            //判断一旦有一个不在就 false
            if(!isSigned(needSigners[i])){
                // 返回一个空值
                return (false," ");
            }
        }
        // 循环结束没有返回false 就代表着都签了 
        return (true,evidence);
    }

}