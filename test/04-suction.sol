// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7;

/*
    卖方
    买方    竞拍-价高者的
    平台方  创建合约 结束拍卖
*/

    // 合约
    contract suction{   
        address payable owner;              // 拍卖公司
        address payable seller;             // 卖方
        uint256 public hightBid;            // 竞拍最高价
        address payable hightBider;         // 竞拍价最高地址
        uint256 public startBid;            // 起拍价
        uint256 public endTime;             // 结束时间
        bool    isFinished;                 // 是否结束

        // 事件记录
        event BidEvent(address _highter,uint256 hightAmount);
        event EndBidEvent(address _winner,uint256 _amount);

        // 构造函数
        constructor (address _seller, uint256 _starBid){
            owner   = payable(msg.sender);
            seller  = payable(_seller);
            startBid= _starBid;
            isFinished = false;
            endTime =block.timestamp +120;
            hightBid = 0;                       // 初始化最高价格
        }

        // 竞拍
        function bid(uint256 _amount) public payable {
            require(_amount > hightBid ," amount must > hightBid ");            // 判断_amount 需要大于最高价
            require(_amount == msg.value,"amount must equal value ");           // 判断 两个数值是否相等
            require(!isFinished," auction already finished ");                  //判断是否结束
            require(block.timestamp <= endTime," auction not time out ");       //判断结束的时间
            // A 100  B200  判断是否是第一个出价
            if(address(0) != hightBider){
                hightBider.transfer(hightBid);                                  // 退钱
            }
            // 记录最高出价人的 金额和地址
            hightBid = _amount;
            hightBider = payable(msg.sender);

            emit BidEvent(msg.sender,_amount);
        }

        //结束竞拍
        function endbid () public payable {
            require(!isFinished," auction already finished ");                  //判断是否结束
            require(msg.sender == owner,"only ower can end auction");           // 只有管理员才能修改
            isFinished = true;                                                  //修改状态  结束竞拍
            // 给卖方打钱 收取手续费
            seller.transfer(hightBid * 90 / 100);

            emit EndBidEvent(hightBider,hightBid);
        }
    }