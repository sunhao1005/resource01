package main

import (
	"fmt"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
	"math/big"
	"strings"
	"time"
)

const  (
	ETH_CONN_ADDRESS="https://ropsten.infura.io/v3/4a74edfffce34c07bc80a78e3eb0874c"   //以太坊网络连接地址（需注册才能允许通行）
	CONTRACT_ADDRESS_OWNER="0x9F70795df0C4E86d5020ab1aC31587Ee4f077498"   //交易所合约地址
	CONTRACT_ADDRESS_ERC20="0xFBAEf3664F77DA12309D3E2a9bb204f557acdAF4"   //token合约地址
	ADDRESS_ME="0x94066127301abf11e1594cCaD1582A4444e51c4d"               //交易所合约部署账户
	ADDRESS_ERC20="0x94066127301abf11e1594cCaD1582A4444e51c4d"            //token合约部署账户
)

//账户keystore
const keystore  = `{"address":"94066127301abf11e1594ccad1582a4444e51c4d","crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"259e8835c732247ff24cf2c46700817d"},"ciphertext":"351d82ecea362123085b28be7a1de3fb2ef4fc1d93eb997573604dd2aef40767","kdf":"scrypt","kdfparams":{"dklen":32,"n":65536,"p":1,"r":8,"salt":"a107ebec40763392e747179e137d36755609ed289fa3e0e34d610c916d078104"},"mac":"53f8dd3c8b169b0641ac2cdfd5fbe8e01891fb4a864fa0fd7f691d8c2acac778"},"id":"e79c3a89-a263-4fac-8156-68ddc1f57179","version":3}
`
const password  = "17719317036"  //钱包密码

func tmain()  {
	//通过已注册地址连接以太坊网络
	conn,err:=ethclient.Dial(ETH_CONN_ADDRESS)
	if err!=nil {
		fmt.Println("连接以太坊失败:",err)
		return
	}
	fmt.Println("连接成功",conn)


	//根据合约地址连接合约
	tokenErc,err:=NewERC20(common.HexToAddress(CONTRACT_ADDRESS_ERC20),conn)
	if err!=nil {
		fmt.Println("连接合约失败：",err)
		return
	}
	fmt.Println("连接合约成功：",tokenErc)

	//调用token合约去给交易所合约授权代币交易
	errs:=txTest(tokenErc,password,CONTRACT_ADDRESS_OWNER,10000)
	if errs!=nil {
		return
	}


	//根据合约地址连接合约
	tokenMe,err:=NewExchange(common.HexToAddress(CONTRACT_ADDRESS_OWNER),conn)
	if err!=nil {
		fmt.Println("连接合约失败：",err)
		return
	}
	fmt.Println("连接合约成功：",tokenMe)

	//上币
    eer:=addToken(tokenMe,password)
	if eer!=nil {
		return
	}

	//提交订单
    errss:=DepositOrder(tokenMe,password,newDepositOrder(10001,10000,10000,CONTRACT_ADDRESS_OWNER))
	if errss!=nil {
		return
	}
	//提交submit
   errsss:= SubmitOrder(tokenMe,password,newSubmit(10001,5000,"",CONTRACT_ADDRESS_ERC20))
	if errsss!=nil {
		return
	}
	//撤销订单
    ers:=withdrawOrder(tokenMe,password,uint64(10001))
	if ers!=nil {
		return
	}
}

//调用token合约去给交易所合约授权代币交易
func txTest(token *ERC20,password string,toaddr string ,value int64) error{
auth,err:=bind.NewTransactor(strings.NewReader(keystore),password)
	if err!=nil {
		fmt.Println("构建交易失败",err)
		return err
	}
fmt.Println("构建交易成功",auth)
auth.GasPrice=big.NewInt(2000000)
auth.GasLimit=uint64(3000000)
//auth.Value=big.NewInt(100) //调用合约时给合约转eth
tx,err:=token.Approve(auth,common.HexToAddress(toaddr),big.NewInt(value))
	if err!=nil {
		fmt.Println("交易授权失败",err)
		return err
	}
fmt.Println("交易授权成功",tx.Hash())
return nil
}

//创建订单
func newDepositOrder(orderid int,sellamount int64,buyamount int64,addr string) *ethDeposits  {
	return & ethDeposits{
		OrderId:uint64(orderid),
		TradeType:true,
		SellAmount:big.NewInt(sellamount),
		SellType:[32]byte{000011},
		Price:big.NewInt(sellamount/buyamount),
		BuyAmount:big.NewInt(0),
		BuyType:[32]byte{000012},
		ContractAddress:common.HexToAddress(addr),
		CreateTime:big.NewInt(time.Now().Unix()),
	}

}


//提交订单
func DepositOrder(token *Exchange,password string,deposits *ethDeposits)error  {
	auth,err:=bind.NewTransactor(strings.NewReader(keystore),password)
	if err!=nil {
		fmt.Println("构建交易失败",err)
		return err
	}
	fmt.Println("构建交易成功",auth)
	auth.GasPrice=big.NewInt(2900000)
	auth.GasLimit=uint64(3000000)
	tx,err:=token.Deposits(auth,deposits.OrderId,deposits.TradeType,deposits.SellAmount,deposits.SellType,deposits.Price,deposits.BuyAmount,deposits.BuyType,deposits.ContractAddress,deposits.CreateTime)
	if err!=nil {
		fmt.Println("提价订单失败",err)
		return  err
	}
	fmt.Println("提交订单成功：",tx.Hash())
	return  nil
}
//创建submit
func newSubmit(orderid int,sellamount int64,to string,addr string)*ethSubmit  {
return &ethSubmit{
	OrderId:uint64(orderid),
	To:common.HexToAddress(to),
	Sell:big.NewInt(sellamount),
	SellCoinType:[32]byte{000011},
	ContractAddr:common.HexToAddress(addr),
}
}


//提交submit
func SubmitOrder(token *Exchange,password string,submit *ethSubmit) error {
	auth,err:=bind.NewTransactor(strings.NewReader(keystore),password)
	if err!=nil {
		fmt.Println("构建交易失败",err)
		return err
	}
	fmt.Println("构建交易成功",auth)
	auth.GasPrice=big.NewInt(2900000)
	auth.GasLimit=uint64(3000000)
	tx,err:=token.Submit(auth,submit.OrderId,submit.To,submit.Sell,submit.SellCoinType,submit.ContractAddr)
	if err!=nil {
		fmt.Println("submit订单失败",err)
		return  err
	}
	fmt.Println("submit订单成功：",tx.Hash())
	return  nil
}

//撤销订单
func withdrawOrder(token *Exchange,password string,txid uint64) error {
	auth,err:=bind.NewTransactor(strings.NewReader(keystore),password)
	if err!=nil {
		fmt.Println("构建交易失败",err)
		return err
	}
	fmt.Println("构建交易成功",auth)
	auth.GasPrice=big.NewInt(2900000)
	auth.GasLimit=uint64(3000000)
	tx,err:=token.Withdrawal(auth,txid)
	if err!=nil {
		fmt.Println("撤销订单失败",err)
		return  err
	}
	fmt.Println("撤销订单成功：",tx.Hash())
	return  nil
}

//上币
func addToken(token *Exchange,password string)error  {
	auth,err:=bind.NewTransactor(strings.NewReader(keystore),password)
	if err!=nil {
		fmt.Println("构建交易失败",err)
		return err
	}
	fmt.Println("构建交易成功",auth)
	auth.GasPrice=big.NewInt(2900000)
	auth.GasLimit=uint64(3000000)
	tx,err:=token.ChangeContractAddress(auth,common.HexToAddress(CONTRACT_ADDRESS_ERC20),true)
	if err!=nil {
		fmt.Println("添加token失败",err)
		return  err
	}

	fmt.Println("添加token成功：",tx.Hash())
	return  nil
}


