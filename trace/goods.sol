// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7;

contract Goods{
    // 定于数据结构
    struct TraceData{
        address operator;               //谁改的状态
        uint8   status;                 //商品状态
        uint256 timestamp;              //定义时间戳
        string  remark;                 //备注
    }
    uint256 goodID;                     // 商品id
    uint8   currentStatus;
    TraceData[] traceDatas;
    uint8 constant STATUS_CREATE = 0;  //定義常量 
    
    event Newstatus(address _operator, uint8 _status, uint256 _time, string _remark);

    constructor(uint256 _goodID){
        goodID = _goodID;
        traceDatas.push(TraceData(tx.origin,STATUS_CREATE,block.timestamp,"create"));
        currentStatus = STATUS_CREATE;
        emit Newstatus(tx.origin,STATUS_CREATE,block.timestamp,"create");
    }


   function changeStatus(uint8 _status,string memory _remark)public returns(bool) {
        currentStatus = _status;
        traceDatas.push(TraceData(tx.origin,_status,block.timestamp,_remark));
        emit Newstatus(tx.origin,_status,block.timestamp,_remark);
        return true;
   }

   function getStatus()public view returns(uint8){
        return currentStatus;
   }

   function gwtTraceInfo() public view returns(TraceData[] memory) {
        return traceDatas;
   }
}