pragma solidity >=0.4.0 <0.7.0;
//*************************
//abigent 0.4.25
//SafeMath库
library SafeMath {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface ERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender)
    external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value)
    external returns (bool);

  function transferFrom(address from, address to, uint256 value)
    external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

contract exchange{
   using SafeMath for uint256;

   //contract owner
   address   public contractOwner;

   //start contract
   bool public startContract;

   //contract balance
   uint256 public contrace_balance;

   //the contract mutex
   bool contractMutex =false;

   //user struct
   struct users{
       uint64  order_id; //transcation txid
       address user_address; //user address
       bool trade_type; // trade type
       uint256 sell_amount; //amount of seel token
       bytes32 sell_type ; //sell coin type
       uint256 price; //price=seel/buy
       uint256 buy_amount;  //amount of want to buy
       bytes32 buy_type; //buy the type of coin
       address contract_address; // contract address
       uint256 fees;   //
       bool withdrawalable; //Determine if the user can widthdrawal
       bool ex_success;
       uint256 create_at;
       uint256 update_at;
   }



   //mapping of exchange
   mapping(uint64 => users)public  orderidToUsers;
  //
   mapping(address => bool) contractTypeAddress;

   //init data
   constructor()public payable{
      contractOwner=msg.sender;
      startContract=true;
      contrace_balance=address(this).balance;
   }

   //event listing

   event Deposits(uint64 orderid,
                      bool tradetype,
                      uint256 sellamount,
                      bytes32 selltype,
                      uint256 price,
                      uint256 buyamount,
                      bytes32 buytype,
                      address contractaddress,
                      uint256 createTime);
   event Withdrawl(uint64 txid);
   event Submitinner(uint64 txid,address to,uint256 sell,bytes32 sellcointype,address contractAddr);
   event Submiouter(uint64 txid,address  to,uint256 sell,bytes32 sellcointype);
   event GetMoney(address owner,uint256 money,uint256 time);

    //deposits
    function deposits(uint64 orderid,
                      bool tradetype,
                      uint256 sellamount,
                      bytes32 selltype,
                      uint256 price,
                      uint256 buyamount,
                      bytes32 buytype,
                      address contractaddress,
                      uint256 createTime
                      ) payable public returns(bool) {

       require(startContract==true);
       require(checkDepositsSafe(sellamount,msg.value,contractaddress,msg.sender));
       if(contractaddress!=address(0)){
           require(contractTypeAddress[contractaddress]==true);
       }

       users memory user = users(
       orderid,
       msg.sender,
       tradetype,
       sellamount,
       selltype,
       price,
       buyamount,
       buytype,
       contractaddress,
       0,
       true,
       false,
       createTime,
       0);

       //addressToOrderid[msg.sender].push(orderid);
       orderidToUsers[orderid]=user;
       //

       emit Deposits(orderid,tradetype,sellamount,selltype,price,buyamount,buytype,contractaddress,createTime);
       return true;
    }

    //withdrawal
    function withdrawal(uint64 txid)payable public returns(bool){
       require(startContract==true);
       require(orderidToUsers[txid].user_address==msg.sender);
       uint256 money=orderidToUsers[txid].sell_amount;
       require(orderidToUsers[txid].withdrawalable==true && orderidToUsers[txid].ex_success!=true &&money>0);
       require(!contractMutex);
        if(orderidToUsers[txid].contract_address!=address(0)){

            contractMutex=true;
            ERC20(orderidToUsers[txid].contract_address).transferFrom(msg.sender,msg.sender,money);
            contractMutex=false;

            if(orderidToUsers[txid].buy_amount==0){
                delete(orderidToUsers[txid]);
            }else{
                orderidToUsers[txid].sell_amount=0;
                orderidToUsers[txid].withdrawalable=false;
                orderidToUsers[txid].ex_success=true;
                orderidToUsers[txid].update_at=now;
            }

            emit Withdrawl(txid);
            return true;
        }else{
           contractMutex=true;
           (msg.sender).transfer(money);
           contractMutex=false;

            if(orderidToUsers[txid].buy_amount==0){
                delete(orderidToUsers[txid]);
            }else{
                orderidToUsers[txid].sell_amount=0;
                orderidToUsers[txid].withdrawalable=false;
                orderidToUsers[txid].ex_success=true;
                orderidToUsers[txid].update_at=now;
            }

            emit Withdrawl(txid);
            return true;
        }

    }

    //update status
    function upstate(uint64 txid)public checkowner(msg.sender) {
        require(startContract==true);
        bool status =orderidToUsers[txid].withdrawalable;
        require(orderidToUsers[txid].ex_success!=true);
        if(status ==true){
            orderidToUsers[txid].withdrawalable=false;
        }else{
            orderidToUsers[txid].withdrawalable=true;
        }
    }

    //submit chain inner
    function submit(uint64 txid,address to,uint256 sell,bytes32 sellcointype,address contractAddr)
    checkowner(msg.sender) payable public returns(bool) {
         require(startContract==true);
         require(to!=address(0));
         require(ERC20(contractAddr).allowance(orderidToUsers[txid].user_address,address(this))==orderidToUsers[txid].sell_amount);
         require(orderidToUsers[txid].sell_amount>=sell&&sell>0);
         require(orderidToUsers[txid].sell_type==sellcointype);
         require(contractTypeAddress[contractAddr]==true);
         require(orderidToUsers[txid].contract_address==contractAddr);

         uint256 sellAmount=orderidToUsers[txid].sell_amount;

              ERC20(contractAddr).transferFrom(orderidToUsers[txid].user_address,to,sell.mul(999).div(1000));
              ERC20(contractAddr).transferFrom(orderidToUsers[txid].user_address,contractOwner,sell.mul(1).div(1000));

              orderidToUsers[txid].sell_amount= sellAmount.sub(sell);
              orderidToUsers[txid].fees=orderidToUsers[txid].fees.add(sell.mul(1).div(1000));
              orderidToUsers[txid].buy_amount=orderidToUsers[txid].buy_amount.add(sell.div(orderidToUsers[txid].price));
              orderidToUsers[txid].update_at=now;

              if(sellAmount==sell){
                orderidToUsers[txid].withdrawalable=false;
                orderidToUsers[txid].ex_success=true;
              }else{
                orderidToUsers[txid].withdrawalable=true;
              }

              emit Submitinner(txid,to,sell,sellcointype,contractAddr);
              return true;


    }


    //submit chain out
    function submit(uint64 txid,address  to,uint256 sell,bytes32 sellcointype)
      checkowner(msg.sender) payable public returns(bool){
      require(startContract==true);
      require(to!=address(0));
      require(orderidToUsers[txid].sell_amount>=sell&&sell>0);
      require(orderidToUsers[txid].sell_type==sellcointype);

      uint256 sellAmount=orderidToUsers[txid].sell_amount;

              (to).transfer(sell.mul(999).div(1000));

              orderidToUsers[txid].sell_amount= sellAmount.sub(sell);
              orderidToUsers[txid].buy_amount=orderidToUsers[txid].buy_amount.add(sell.div(orderidToUsers[txid].price));
              orderidToUsers[txid].fees=orderidToUsers[txid].fees.add(sell.mul(1).div(1000));
              orderidToUsers[txid].update_at=now;

              if(sellAmount==sell){
                orderidToUsers[txid].withdrawalable=false;
                orderidToUsers[txid].ex_success=true;
              }else{
                orderidToUsers[txid].withdrawalable=true;
              }

              emit Submiouter(txid,to,sell,sellcointype);
              return true;

    }

    //func check your contract balance

    function getContractBalance()checkowner(msg.sender) public{
        contrace_balance=address(this).balance;
    }

    //func of get money
    function getMoney(uint256 money) checkowner(msg.sender) public{
      require(money>0&&address(this).balance>=money);
      get_money_eth(money);
      emit GetMoney(msg.sender,money,now);
    }

    //func pause contract

    function pauseContract()checkowner(msg.sender) public{
       require(startContract==true);
       startContract=false;
    }
    //func restart contract
    function restartContract()checkowner(msg.sender) public{
       require(startContract==false);
       startContract=true;
    }

    //func of destory contract

    function destoryContract()checkowner(msg.sender) public{
       selfdestruct(contractOwner);
    }

    function get_money_eth(uint256 money)  internal  {
       contractOwner.transfer(money);
    }

    function changeContractAddress(address addr,bool chnageType)checkowner(msg.sender)public{
       if(chnageType==true){
           contractTypeAddress[addr]=true;
       }else{
           delete(contractTypeAddress[addr]);
       }
    }



    //utils
    function checkDepositsSafe(uint256 sell,uint256 money,address tokencontracts,address userddr)view internal returns(bool){
     if(tokencontracts!=address(0)){
         if(ERC20(tokencontracts).allowance(userddr,address(this))==sell){
             return true;
         }else{
             return false;
         }
     }else{
         if(sell==money){
          return true;
         }else{
             return false;
         }
     }
   }

   //submit safe check
    modifier checkowner(address addr){
       require(contractOwner==addr);
       _;
    }



}