pragma solidity^0.4.25;

contract VampireEvent{

  //创建吸血鬼事件
  event creatVampiersEvent(string name,uint32 time,uint32 rarity,uint vamId,uint dna,uint level,uint fatherId);

  //吸血鬼重命名事件
  event renameVampireEvent(uint vamId,string name);

  //吸血鬼战斗胜利事件
  event battleVictory(uint vamId);

  //拍卖事件
  event auction(address addr,uint amount,uint vamId);
}
