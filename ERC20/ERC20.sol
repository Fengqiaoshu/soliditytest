// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7; 

import "./IERC20.sol";


contract ERC20 is IERC20 {

    string  ercName;
    string  ercSymbol;
    uint8   ercDecimals;
    uint256 ercTotalSupply;
    mapping(address=>uint256)ercBalance;    //自定义账本
    mapping(address=>mapping(address=>uint256)) ercAllowance;


    address  owner;
    // 构造函数 初始化一下固定的信息
    constructor(string memory _name, string memory _sym, uint8 _decimals){
        ercName = _name;
        ercSymbol = _sym;
        ercDecimals = _decimals;
        /* 
        owner = msg.sender;
        ercTotalSupply = 2100000;                   // 总的发行量
        ercBalance[owner] = ercTotalSupply;         // 把所有的都给owner 
        */
        
    }
    
    function name()override external view returns (string memory){
        return ercName;
    }

    function symbol()override external view returns (string memory){
         return ercSymbol;
    }

    function decimals()override external view returns (uint8){
        return ercDecimals;
    }

    function totalSupply()override external view returns (uint256){
        return ercTotalSupply;
    }

    function balanceOf(address _owner)override external view returns (uint256 balance){
        return ercBalance[_owner];
    }

    function transfer(address _to, uint256 _value)override external returns (bool success){
        // 判断 传进来的值是否大于0 地址是否为0 账户余额是否大于数值
        require(_value > 0, " value must > 0 ");
        require(address(0) != _to," to address is zero  ");
        require(ercBalance[msg.sender] >= _value," user's balance not enough ");
        // 对账号进行的数值进行操作
        ercBalance[msg.sender] -= _value;
        ercBalance[_to] += _value;
        // 记录事件 
        emit Transfer(msg.sender, _to, _value);

        return true;
    }
    //  委托方 给与谁  额度
    function transferFrom(address _from, address _to, uint256 _value)override external returns (bool success){
        // 检查froom 的额度是否充足
        require(ercBalance[msg.sender] >= _value," user balance not enough  ");
        // 检查额度是否授权
        require(ercAllowance[_from][msg.sender] >= _value," approve's balance not enough ");
        require(address(0) != _to,"_to is zero address");
        // 对于账户进行操作 
        ercBalance[_from] -= _value;
        ercBalance[_to]   += _value;
        // 转账结束后 授权的额度减少
        ercAllowance[_from][msg.sender] -= _value;
        // 记录事件
        emit Transfer(msg.sender,_to,_value);
        return true;
    }
    // 授权
    function approve(address _spender, uint256 _value)override external returns (bool success){
        //判断  传入值必须大于0 地址不能为空的地址
        require(_value > 0 ,"_value must > 0");
        require(address(0) != _spender ," _spender is zero address");
        require( ercBalance[msg.sender] >= _value," user's balance not enough ");
        
        ercAllowance[msg.sender][_spender] = _value;
        // return 返回值
        return true;
        // 记录事件
        emit Approval(msg.sender, _spender, _value);
        }
        
    function allowance(address _owner, address _spender)override external view returns (uint256 remaining){
        remaining = ercAllowance[_owner][_spender];
    }
   

    function mint(address _to,uint256 _value)public{
        // 只有管理员才能进行空头
        require(msg.sender == owner," only ower can do");
        // to的地址不能为空
        require(address(0) != _to," address didn't null");
        require(_value > 0 ,"_value must > 0");

        ercBalance[_to] += _value;
        ercTotalSupply  += _value;
        // 记录空投事件   空地址代表系统 
        emit Transfer(address(0), _to, _value);
    }

}
   



