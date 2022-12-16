// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7;

/*
    1.3 个功能
    2.银行名字
    3.银行账本检测
*/

contract bank_demo{
    string public bankName;  //定义银行名字
    uint256 totalAmount;    //存款数量
    address public admin;   //定义管理员
    mapping(address=>uint256)balances; //用户余额
    constructor(string memory _name){
        bankName    = _name;
        admin       = msg.sender;
    }  
    // 存钱功能
    function deposit(uint256 _amount) public payable{
        //判断传过来的值是不是大于0
        require(_amount > 0," amount must > 0 ");
        require(msg.value == _amount," msg.value must equal amount" );
        balances[msg.sender] += _amount;   //  a += b; a = a + b;  维护账本
        totalAmount += _amount;            //存款余额增加
        require(address(this).balance == totalAmount,"bank's balance must ok"); // 查看钱是否对

    }
    // 提款功能
    function withdraw(uint256 _amount)public payable{
        require(_amount > 0," amount must > 0 ");
        require(balances[msg.sender] >= _amount,"user's balance not enough"); //余额数量必须大于取款数量
        balances[msg.sender] -= _amount;   // 维护账本
        payable(msg.sender).transfer(_amount);       //转账
        totalAmount -= _amount;            //存款余额减少
        require(address(this).balance == totalAmount,"bank's balance must ok"); // 查看钱是否对
    
    }
    // 记账功能 账本内部的操作
    function transfer(address _to, uint256 _amount)public {
        require(_amount > 0," amount must > 0 ");
        require(address(0) != _to,"to address must valid"); //地址必须为有效地址
        require(balances[msg.sender] >= _amount,"user's balance not enough"); //余额数量必须大于取款数量
        // 操作账本
        balances[msg.sender] -= _amount;   
        balances[_to] += _amount;          
        require(address(this).balance == totalAmount,"bank's balance must ok"); // 查看钱是否对
    }
    
    // 用户余额查询
    function balanceof(address _who)public view returns(uint256){
        return balances[_who];
    }

      // 检查功能
    function getBalance()public view returns(uint256, uint256){
        return (address(this).balance, totalAmount);
    }
}