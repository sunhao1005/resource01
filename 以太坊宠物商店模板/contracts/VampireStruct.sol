pragma solidity^0.4.25;

contract VampireStruct{

  //一个吸血鬼
  struct Vampire{
    string name;
    uint dna;
    uint level;
    uint fatherID;
    uint power;
    uint32 createTime;
    uint32 rarity;
  }

  //一场拍卖
  struct Bidder{
    address[] addrs;
    uint[] moneys;
    uint money;
    uint32 startTime;
    bool grant;
  }

}
