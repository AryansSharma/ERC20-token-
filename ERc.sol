// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;
interface A {
    function totalSupply() external view returns (uint256);
    function balanceOf(address tokenOwner) external view returns (uint);
    function allowance(address tokenOwner, address spender)external view returns (uint);
    function transfer(address to, uint tokens) external returns (bool);
    function approve(address spender, uint tokens)  external returns (bool);
    function transferFrom(address from, address to, uint tokens) external returns (bool);
    event Approval(address indexed tokenOwner, address indexed spender,uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event burningToken(address indexed _founder ,uint256 quantity);
}
contract erc{
    string public name = "Block";
    string public symbol="BLK";
    uint public decimal=0;
    uint public totalSupply;
    address public founder;
    mapping(address=>mapping(address=>uint)) allowed;
    mapping(address=>uint)balances;
    mapping(address=>bool) public isFreeze;
    bool stopAllFunction;
    constructor(){
    founder = msg.sender;
    totalSupply = 1000;
    balances[founder]=totalSupply;
     }
     modifier emergencyStatus(){
        require(stopAllFunction==false,"Emergency Declared");
        _;
     }
     modifier FreezeStatus(){
        require(isFreeze[msg.sender]==false,"Your account is Freezed");
        _;
     }
    function balanceOf(address account) external view returns(uint256){
        return balances[account];

    } 
    function transfer(address recepient, uint256 amount)external FreezeStatus() emergencyStatus() returns(bool){
        require(amount>0,"Amount must be greater than zero");
        require(balances[msg.sender]>=amount,"You don't have emough balance");
        balances[msg.sender]-=amount;
        balances[recepient]+=amount;
        emit A.Transfer(msg.sender, recepient, amount);
        return true;
    }
    function allowance(address owner,address spender) external view returns(uint256){
        return allowed[owner][spender];
    }
    function approve(address spender, uint256 amount)external FreezeStatus() emergencyStatus() returns(bool){
        require(amount>0,"Amount must be greater than zero");
        require(balances[msg.sender]>=amount,"You don't have enough balance");
        allowed[msg.sender][spender]=amount;
        emit A.Approval(msg.sender, spender, amount);
        return true;
    }
    function transferFrom(address sender, address recepient, uint256 amount) external FreezeStatus() emergencyStatus() returns(bool){
        require(amount>0,"Amount must be greater than zero");
        require(balances[msg.sender]>=amount,"You don't have enough balance");
        require(allowed[sender][recepient]>=amount,"Not authorised");
        balances[sender]-=amount;
        balances[recepient]+=amount;
        return true;
    }
    function burnig(uint value)public{
        require(msg.sender==founder,"only founder allowed");
        require(value<=totalSupply,"Not enough token");
        balances[founder]-=value;
        totalSupply-=totalSupply;

    }
    function freezAccount(address freezingAddress)public{
        require(msg.sender==founder,"You are not allowed");
        isFreeze[freezingAddress]=true;

    }
    function unFreezAccount(address unfreezingAddress)public{
        require(msg.sender==founder,"Not allowed");
        isFreeze[unfreezingAddress]=false;


    }
    function emergency()public{
        stopAllFunction=true;
    }

}
