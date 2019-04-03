pragma solidity ^0.4.25;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
 //��ѧ���
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}


contract TokenERC20{
    using SafeMath for uint256;
    //��������
   string public name;
   //���Ҽ��
   string public symbol;
   //С����
   uint  public  decimals=18;
   //���д�������
   uint public totaosupply;
   //�û����
   mapping(address=>uint256) public balanceOf;

   //��Ȩӳ��
   mapping(address=>mapping(address=>uint256))public allowance;

    //���캯��
    constructor (
        uint256 initialsupply,
        string tokenname,
        string tokensymbol
        )public{

            totaosupply =initialsupply * 10 ** decimals;
            balanceOf[msg.sender]=totaosupply;
            name =tokenname;
            symbol=tokensymbol;
    }

    event Transfer (address indexed  _from,address indexed  _to,uint256 indexed  _value);
    event Approval (address indexed  _owner,address indexed  _spender,uint256 indexed  _value);


   function _transfer(address  _from,address _to,uint256 _value) internal{
       require(_to!=address(0));
       require(balanceOf[_from]>=_value);
       balanceOf[_from] = balanceOf[_from].sub(_value);
       balanceOf[_to] = balanceOf[_to].add(_value);
       emit Transfer(_from,_to,_value);
   }

    function transfer(address _to,uint256 _value)public{
      _transfer(msg.sender,_to,_value);
   }

  function transferfrom(address  _from,address _to,uint256 _value)public returns(bool success){
      require(allowance[_from][msg.sender]>=_value);
      allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
      _transfer(_from,_to,_value);
      return true;
  }
   function approve(address _spender,uint256 _value)public returns(bool success){
     allowance[msg.sender][_spender] =_value;
     emit Approval(msg.sender,_spender,_value);
     return true;
   }

}
