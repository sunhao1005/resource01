pragma solidity^0.4.25;

import "./ownable.sol";
import "./SafeMath.sol";
import "./VampireEvent.sol";
import "./VampireStruct.sol";

contract ERC721{
  function balanceOf(address _owner)public constant returns(uint balance);

  //所有权相关的接口
  function ownerOf(uint256 _tokenId) public constant returns(address owner);
  function approve(address _to,uint256 _tokenId) public;
  function takeOwnership(uint256 _tokenId) public;
  function transfer(address _to,uint256 _tokenId) public;
  //事件
  event Transfer(address indexed _from,address indexed _to,uint256 _tokenId);
  event Approval(address indexed _owner,address indexed _approved,uint256 _tokenId);
}

contract ERC20{
  uint256 public totalSupply;
  function balanceOf(address _owner) public constant returns (uint256 balance);
  function transfer(address _to,uint256 _value)public returns(bool success);
  function transferFrom(address _from,address _to,uint256 _value)public returns(bool success);

  function approve(address _spender,uint256 _value)public returns(bool success);

  function allowance(address _owner,address _spender) public constant returns(uint256 remaining);

  event Tranfer(address indexed _from,address indexed _to,uint256 _value);
  event Approval(address indexed _owner,address indexed _spender,uint256 _value);
}

contract Vampire is Ownable,VampireEvent,VampireStruct,ERC721{

  using SafeMath for *;

  uint dnaDigits = 20;
  uint dnaModulus = 10 ** dnaDigits ; //dna bits
  uint creatcooling; //制作一个需要多长时间
  uint dayCountMoney; //单个繁殖价格
  uint randNonce = 0; //目前随机数计算值
  uint singMoney;     //登陆礼品数量
  uint renameMoney;   //重命名价格
  uint creatNewVamMoney;//创造新吸血鬼的费用
  uint battleMoney;    //战斗的费用
  uint battleWinMoney; //战斗获胜奖金
  uint startBidderMoney; //拍卖手续费
  uint bidderMoney;    //拍卖费
  uint biddersTime;   //拍卖时间
  uint32 createNewTime; //最后一次吸血时间
  uint32 winBattle;     //胜率
  uint32 battleColling;  //战斗冷却时间
  uint32 lastTimeBattle; //最后战斗时间
  address contractAddress; // 收藏当前合同地址

  ERC20 erc20; //token合约

  VampireStruct.Vampire[] public vampires; //吸血鬼数组
  VampireStruct.Bidder[] public bidder;  //拍卖会数组

  mapping(uint => address) vamToAddr; //吸血鬼编号对应用户
  mapping(address => uint) addrVamCount;//address => count 吸血鬼的数量
  mapping(address => uint) addrToSignCount; //address => count 用户使用天数
  mapping(uint => uint) vamToAuction; //vamID => batter 吸血鬼对应的拍卖会id
  mapping(uint => address) vamApprovals;//erc721 => approval 给予授权

  //必须是僵尸拥有者
  modifier VampireOwner(uint _vampireId){
    require(msg.sender == vamToAddr[_vampireId]);
    _;
  }

  //支付功能开启
  function () public payable{}

  //设置ERC20代币地址
  function setERC20Address(address _erc20)public onlyOwner{
    erc20 = ERC20(_erc20);
  }

  //设置再次制造一个吸血鬼的花费
  function setCreatCooling(uint _time,uint _dayCountMoney)public onlyOwner{
    creatcooling = 1 seconds * _time;
    dayCountMoney=_dayCountMoney;  //单个繁殖价格
  }

  //设置胜率
  function setWinBattle(uint32 _winBattle)public onlyOwner{
    winBattle = _winBattle;
  }

  //设置战斗冷却时间
  function setbattleColling(uint32 _battleColling)public onlyOwner{
    battleColling = _battleColling;
  }

  //设置设置投标时间
  function setBiddingTime(uint _biddersTime)public onlyOwner{
    biddersTime = 1 seconds * _biddersTime;
  }

  //设立委员会
  function setFee(
    uint _singMoney,     //登陆礼品
    uint _renameMoney,  //重命名费用
    uint _creatNewVamMoney, //创建新僵尸费用
    uint _battleMoney,    //战斗费用
    uint _battleWinMoney,  //战斗胜利奖励
    uint _startBidderMoney, //开始拍卖费用
    uint _bidderMoney    //拍卖费
  )public onlyOwner{
    singMoney = _singMoney.mul(1000000000000000000);
    renameMoney = _renameMoney.mul(1000000000000000000);
    creatNewVamMoney = _creatNewVamMoney.mul(1000000000000000000);
    battleMoney = _battleMoney.mul(1000000000000000000);
    battleWinMoney = _battleWinMoney.mul(1000000000000000000);
    startBidderMoney = _startBidderMoney.mul(1000000000000000000);
    bidderMoney = _bidderMoney.mul(1000000000000000000);
  }

  //创建一个新的僵尸数组
  function creatVampires()public{
    //每个用户只能创建一个
    require(addrVamCount[msg.sender] == 0);
    uint32 time = uint32(now);
    uint32 rarity = _getRarity();
    _creatVampiers(time,rarity,1,0);
  }

  //僵尸吃食物，创建一个新的僵尸
  function creatNewVampires(uint _vamId)public VampireOwner(_vamId){
    //判断是否结束冷却时间
    require(now > createNewTime + creatcooling);

    //使用erc20代币当作手续费
    require(erc20.balanceOf(msg.sender) >= creatNewVamMoney);
    erc20.transferFrom(msg.sender,contractAddress,creatNewVamMoney);

    //重置创建新吸血鬼的时间
    createNewTime = uint32(now);
    if(_getRarity() == 1 && _vamId !=0)
    uint32 rarity = _getRarity();
    _creatVampiers(createNewTime,rarity,vampires[_vamId].level,_vamId);
  }

  //创建高级吸血鬼
  function creatVarityVampires(uint32 rarity)public onlyOwner{
    uint32 time = uint32(now);
    _creatVampiers(time,rarity,1,0);
  }

  //创建吸血鬼数组
  function _creatVampiers(
    uint32 time,
    uint32 rarity,
    uint level,
    uint fatherID
  )private{
    uint dna = _generateRandomDna(time);
    //vampires.push
    uint id = vampires.push(VampireStruct.Vampire("%E5%90%B8%E8%A1%80%E9%AC%BC",dna,level,fatherID,100,time,rarity)).sub(1);
    //设置吸血鬼的主人
    vamToAddr[id] = msg.sender;
    //增加此人的僵尸数
    addrVamCount[msg.sender] = addrVamCount[msg.sender].add(1);
    //触发创建吸血鬼事件
    emit creatVampiersEvent("%E5%90%B8%E8%A1%80%E9%AC%BC",time,rarity,id,dna,level,fatherID);
  }

  //计算珍惜度
  function _getRarity()private view returns(uint32){
    //产生一个随机数
    uint random = _getRandom();
    //根据大小获得1-5种不同的稀有程度。
    if(random <= 5)
      return 5;
    else if(random <= 15 && random > 5)
      return 4;
    else if(random <= 30 && random > 15)
      return 3;
    else if(random <=50 && random > 30)
      return 2;
    else
      return 1;
  }

  //获取随机数
  function _getRandom()private returns(uint){
    uint random = uint(keccak256(now,msg.sender,randNonce)) % 100;
    randNonce.add(1);
    return random;
  }

  //得到随机dna，确保dna长度是20字节
  function _generateRandomDna(uint32 time)private view returns(uint){
    uint rand = uint(keccak256(time));
    return rand % dnaModulus;
  }

  //为吸血鬼重命名
  function renameVampiers(string _name,uint _vamId)public VampireOwner(_vamId){
    //使用erc20令牌作为手续费
    require(erc20.balanceOf(msg.sender) >= renameMoney);
    erc20.transferFrom(msg.sender,contractAddress,renameMoney);

    vampires[_vamId].name = _name;
    emit renameVampireEvent(_vamId,_name);
  }

  //吸血鬼战斗，获得一些收益
  function Battle(uint _vamId,uint _otherVamId)public VampireOwner(_vamId){
    require(now > battleColling + lastTimeBattle);
    //使用erc20令牌作为手续费
    require(erc20.balanceOf(msg.sender) >= battleMoney);
    erc20.transferFrom(msg.sender,contractAddress,battleMoney);

    lastTimeBattle = uint32(now);
    //获取一个随机数
    uint random = _getRandom();
    //获胜概率
    if(random > winBattle){
      //计算战斗能力
      vampires[_vamId].power.add(50);
      erc20.transfer(msg.sender,battleWinMoney);
      if(vampires[_otherVamId].power <= 50)
        vampires[_otherVamId].power = 0;
      else
        vampires[_otherVamId].power.sub(50);
      emit battleVictory(_vamId);
    }else{
      //计算战斗能力
      vampires[_otherVamId].power.add(50);
      if(vampires[_vamId].power <= 50)
        vampires[_vamId].power = 0;
      else
        vampires[_vamId].power.sub(50);
      emit battleVictory(_otherVamId);
    }
  }

  //用户登录赠送代币
  function sign()public{
    require(addrToSignCount[msg.sender] <= 14);
    addrToSignCount[msg.sender] = addrToSignCount[msg.sender].add(1);
    erc20.transfer(msg.sender,singMoney);
  }

  //获得某人的所有吸血鬼编号
  function getVampireByOwner(address _owner)public view returns(uint[]){
    uint[] memory result = new uint[](addrVamCount[_owner]);
    uint counter = 0;
    for(uint i=0;i<vampires.length;i++){
      if(vamToAddr[i] == _owner){
        result[counter] = i;
        counter=counter.add(1);
      }
    }
    return result;
  }

  //吸血鬼开始拍卖
  function startBidders(uint money,uint _vamId)public VampireOwner(_vamId){
    //使用erc20令牌作为手续费
    require(erc20.balanceOf(msg.sender) >= startBidderMoney);
    erc20.transferFrom(msg.sender,contractAddress,startBidderMoney);

    address[] addrs;
    uint[] moneys;
    uint id = bidder.push(VampireStruct.Bidder(addrs,moneys,money,uint32(now),false)).sub(1); //添加进拍卖会数组映射
    vamToAuction[id] = _vamId;
  }

  //拍卖方法
  function Bidders(uint money,uint _vamId)public{
    require(now < biddersTime + bidder[vamToAuction[_vamId]].startTime);
    require(money > bidder[vamToAuction[_vamId]].moneys[bidder[vamToAuction[_vamId]].moneys.length.sub(1)]);
    ////使用erc20令牌作为手续费
    require(erc20.balanceOf(msg.sender) >= money.mul(1000000000000000000).add(bidderMoney));
    erc20.transferFrom(msg.sender,contractAddress,money.mul(1000000000000000000).add(bidderMoney));
    //退还用户拍卖费用
    erc20.transfer(bidder[vamToAuction[_vamId]].addrs[0],
      bidder[vamToAuction[_vamId]].moneys[0].mul(1000000000000000000).add(bidderMoney));

    bidder[vamToAuction[_vamId]].addrs[0] = msg.sender;
    bidder[vamToAuction[_vamId]].moneys[0] = money;
    emit auction(msg.sender,money,_vamId);
  }

  //结束拍卖
  function endBidders(uint _vamId)public onlyOwner{
    for(uint i = 0;i<bidder.length;i++){
      if(now > biddersTime + bidder[vamToAuction[_vamId]].startTime &&
          bidder[vamToAuction[_vamId]].grant == false){
        erc20.transfer(vamToAddr[_vamId],bidder[vamToAuction[_vamId]].moneys[0]);
        vamToAddr[_vamId] = bidder[vamToAuction[_vamId]].addrs[0];
        bidder[vamToAuction[_vamId]].grant = true;
      }
    }
  }

  //获取用户余额
  function balanceOf(address _owner)public view returns(uint256 _balance){
    return addrVamCount[_owner];
  }

  //得到吸血鬼的用户
  function ownerOf(uint256 _tokenId)public view returns(address _owner){
    return vamToAddr[_tokenId];
  }

  //交易吸血鬼
  function _transfer(address _from,address _to,uint256 _tokenId)private{
    addrVamCount[_to] = addrVamCount[_to].add(1);
    addrVamCount[msg.sender] = addrVamCount[msg.sender].sub(1);
    vamToAddr[_tokenId] = _to;
    emit Transfer(_from,_to,_tokenId);
  }

  //交易吸血鬼
  function transfer(address _to,uint _vamId)public VampireOwner(_vamId){
    _transfer(msg.sender,_to,_vamId);
  }

  //授权
  function approve(address _to,uint256 _tokenId)public VampireOwner(_tokenId){
    vamApprovals[_tokenId] = _to;
    emit Approval(msg.sender,_to,_tokenId);
  }

  //获得所有权
  function takeOwnership(uint256 _tokenId)public{
    require(vamApprovals[_tokenId] == msg.sender);
    address owner = ownerOf(_tokenId);
    _transfer(owner,msg.sender,_tokenId);
  }

  //撤回
  function withdraw()public onlyOwner{
    owner.transfer(address(this).balance);
  }

  //撤回代币
  function withdrawalToken()public onlyOwner{
    uint256 b = erc20.balanceOf(address(this));
    erc20.transfer(owner,b);
  }

}
