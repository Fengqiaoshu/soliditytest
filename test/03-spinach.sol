// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7;

/*
    1.庄家  发布合约 坐等开奖
    2.韭菜  下注    开奖
*/

contract spinach{
        // 数组记录
        struct Player{
            address addr;               // 下注人的地址
            uint256 amount;             // 下注人的数量     
        }
        Player[] bigs;
        Player[] smalls;
        uint256 public totalBigAmount;         //下大的金额总数
        uint256 public totalSmallAmount;       //下小的金额总数
        address owner;                         //平台方地址
        bool public isFinished;                //是否已经结束
        uint256 minBetAmount;                  //定义最小的下注资金
        uint256 public endTime;                //定义时间结束的时间戳

        // 构造函数每次合约部署时执行一次
        constructor (uint256 _min) {
            owner = msg.sender;                 // 合约部署人的地址
            isFinished = false;                 // 合约部署的给予默认值
            minBetAmount = _min;                // 给最小下注赋值
            endTime = block.timestamp + 120;    // 定义当前时间戳 + 120秒
        }

        // 下注  isBig = ture (big)  false(small)
        function bet(bool isBig)public payable{
            require (!isFinished, " game must not finished! " );                //判断游戏是否结束
            require(msg.value >= minBetAmount, " bet's amount must > min ");    //判断下注资金是否大于等于最小金额
            require(block.timestamp < endTime," time not out " );                //判断游戏是否结束

            // 判断下注类型
            if(isBig){
                // big  
                Player memory player = Player(msg.sender,msg.value);
                // 把函数推送到数组里面
                bigs.push(player);
                // 统计下大的金额总数
                totalBigAmount += msg.value;                    
            }else{
                //small
                 Player memory player = Player(msg.sender,msg.value);
                smalls.push(player);
                totalSmallAmount += msg.value;
            }

        }

        //开奖 按照下注金额分配
        function open( )public payable{
            // 计算随机数 【0-17】以内的随机数   small{0,1,2,3,4,5,6,7,8}  big{9,10,11,12,13,14,15,16,17}
            uint256 randnum = uint256(keccak256(abi.encode(block.timestamp,msg.sender,owner,totalBigAmount)))  % 18;                   // 计算随机数 然后针对18取余
            // 判断随机数大小
            if(randnum <= 8){
                // small  big的钱=>smallsmall
                // bonus = 本金+奖金( totalBigAmount * amount/totalSmallAmount )
                //                                          下小的比例
                // 遍历数组
                for( uint256 i = 0 ; i < smalls.length; i++ ){
                    Player memory player = smalls[i];
                    uint256 bonus = player.amount + totalBigAmount * player.amount / totalSmallAmount * 90 /100;
                    payable(player.addr).transfer(bonus);
                }
                payable (owner).transfer(totalBigAmount *10 /100);
            }else{
               // big
                for( uint256 i = 0 ; i < bigs.length; i++ ){
                    Player memory player = bigs[i];
                    uint256 bonus = player.amount + totalSmallAmount * player.amount / totalBigAmount * 90 /100;
                    payable(player.addr).transfer(bonus);
                }
                payable (owner).transfer(totalSmallAmount *10 /100);
            }
        }

        function getBalance() public view returns(uint256,uint256){
            // this 不是和明白指的是当前合约麻
            return (address(this).balance , totalBigAmount + totalSmallAmount);
        }
}