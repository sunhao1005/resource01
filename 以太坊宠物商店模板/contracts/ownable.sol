pragma solidity^0.4.25;

//Ownable契约有一个所有者地址，并提供基本的授权控制功能，这简化了“用户权限”的实现。
contract Ownable{

  address public owner;

  event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);

  //Ownable构造函数将合同的原始“所有者”设置为发送方帐户。
  constructor()public{
        owner=msg.sender;
  }

  //如果被所有者以外的任何帐户调用，抛出。
  modifier onlyOwner(){
    require(msg.sender == owner);
    _;
  }

  //允许当前所有者将合同的控制权转让给新所有者。
  //参数：将所有权转移到的地址。
  function transferOwnership(address newOwner) public onlyOwner{
    require(newOwner != address(0));
    emit OwnershipTransferred(owner,newOwner);
    owner = msg.sender;
  }
}
