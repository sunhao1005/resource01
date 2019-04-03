package ethereum


const  (
	ETH_CONN_ADDRESS="https://ropsten.infura.io/v3/4a74edfffce34c07bc80a78e3eb0874c"   //以太坊网络连接地址（需注册才能允许通行）
	CONTRACT_ADDRESS_OWNER="0x9F70795df0C4E86d5020ab1aC31587Ee4f077498"   //交易所合约地址
	CONTRACT_ADDRESS_ERC20="0xFBAEf3664F77DA12309D3E2a9bb204f557acdAF4"   //token合约地址
	ADDRESS_ME="0x94066127301abf11e1594cCaD1582A4444e51c4d"               //交易所合约部署账户
	ADDRESS_ERC20="0x94066127301abf11e1594cCaD1582A4444e51c4d"            //token合约部署账户
)

const keystore  = `{"address":"94066127301abf11e1594ccad1582a4444e51c4d","crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"259e8835c732247ff24cf2c46700817d"},"ciphertext":"351d82ecea362123085b28be7a1de3fb2ef4fc1d93eb997573604dd2aef40767","kdf":"scrypt","kdfparams":{"dklen":32,"n":65536,"p":1,"r":8,"salt":"a107ebec40763392e747179e137d36755609ed289fa3e0e34d610c916d078104"},"mac":"53f8dd3c8b169b0641ac2cdfd5fbe8e01891fb4a864fa0fd7f691d8c2acac778"},"id":"e79c3a89-a263-4fac-8156-68ddc1f57179","version":3}
`
const password  = "17719317036"  //钱包密码
/*type ethDeposits struct {
	OrderId         uint64
	TradeType       bool
	SellAmount      *big.Int
	SellType        [32]byte
	Price           *big.Int
	BuyAmount       *big.Int
	BuyType         [32]byte
	ContractAddress common.Address
	CreateTime      *big.Int
}*/

/*type ethWithdraw struct {
	OrderId uint64
}*/
/*type ethSubmit struct {
	OrderId      uint64
	To           common.Address
	Sell         *big.Int
	SellCoinType [32]byte
	ContractAddr common.Address
}*/

