// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7;

/*
    1.发红包  红包类型：平均分配 = ture  随机分配 
    2.抢红包  

*/

contract redpacket{
    bool    public rType;          //红包的类型
    uint8   public rCount;         //红包的数量
    uint256 public rTotalAmount;   //红包总量
    address public tuhao;          //发红包的人
    mapping(address=>bool)isStake;
    

    // 构造函数
    constructor(bool isAvg,uint8 _count, uint256 _amount) payable {
        rType = isAvg;
        rCount = _count;
        rTotalAmount = _amount;
        tuhao = msg.sender;
        
        require(_amount == msg.value," redpacket's balance is ok ");
       
    }

    // 合约查询
    function getBalance () public view returns (uint256){
        return address(this).balance;
    }

    // 抢红包
    function stakePacket(  ) public payable {
        require(rCount > 0, "red packet must left");                       //首先要判断红包是否还有剩余
        require(getBalance() > 0, " contratc's balance must enough ");     //判断红包是否还有钱
        require( !isStake[msg.sender]," user does not stake ");            //判断地址是否抢过
        isStake[msg.sender] = true;

        if(rType){
            // 平均分配
            uint256 amount = getBalance() / rCount; 
            payable(msg.sender).transfer(amount);
        }else{
            // 随机分配
            if(rCount == 1){
                //判断时候还剩最后一个红包是的话全拿走
                payable(msg.sender).transfer(getBalance());
            }else{ 
                uint256  randnum = uint256(keccak256(abi.encode(tuhao,rTotalAmount,rCount,block.timestamp,msg.sender))) % 10 ;
                uint256 amount = getBalance() * randnum / 10 ;
                payable(msg.sender).transfer(amount);
            }
            
        }
        rCount --;      //开始抢红包 减少红包数量
    }

    //销毁合约，返回到指定地址内
    function kill() public payable {
        selfdestruct(tuhao);
    }

}