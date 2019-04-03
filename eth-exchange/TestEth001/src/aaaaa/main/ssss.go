package main

import (
	"fmt"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
	"log"
	"math/big"
	"strings"
)

func main(){
	//通过节点访问以太坊
	conn,eer:= ethclient.Dial("https://rinkeby.infura.io/v3/4a74edfffce34c07bc80a78e3eb0874c")
	if eer!=nil {
		log.Fatalf("连接以太坊失败")
	}
	fmt.Println("连接成功",conn)

	//获取token信息
	token,eer:=NewTokenERC20(common.HexToAddress("0x3a22A64698b2aB3C776847145E24964e4228D0f6"),conn)
	if eer!=nil {
		log.Fatalf("获取token失败",eer)
	}
	fmt.Println("获取成功",token)
	//获取token的name
	name,eer :=token.Name(nil)
	if eer!=nil {
		log.Fatalf("获取name失败",eer)
	}
	fmt.Println("获取成功",name)

	//获取token的totalsupply
	tot,eer:=token.Totaosupply(nil)
	if eer!=nil {
		log.Fatalf("获取totalsupply失败",eer)
	}
	fmt.Println("获取成功",tot)

	//获取token的deicmals
	dec,eer:=token.Decimals(nil);
	if eer!=nil {
		log.Fatalf("获取decimals失败",eer)
	}
	fmt.Println("获取成功",dec)
	balance,eer:=token.BalanceOf(nil,common.HexToAddress("0x94066127301abf11e1594cCaD1582A4444e51c4d"))
	if eer!=nil {
		log.Fatalf("获取balanceof失败",eer)
	}
	fmt.Println("获取成功",balance)

	MyTransfer(token,"17719317036","0x2daF64B86d5b4aa224852EC0B7C1142557ad15fb",1)


}

const key  = `{"address":"94066127301abf11e1594ccad1582a4444e51c4d","crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"259e8835c732247ff24cf2c46700817d"},"ciphertext":"351d82ecea362123085b28be7a1de3fb2ef4fc1d93eb997573604dd2aef40767","kdf":"scrypt","kdfparams":{"dklen":32,"n":65536,"p":1,"r":8,"salt":"a107ebec40763392e747179e137d36755609ed289fa3e0e34d610c916d078104"},"mac":"53f8dd3c8b169b0641ac2cdfd5fbe8e01891fb4a864fa0fd7f691d8c2acac778"},"id":"e79c3a89-a263-4fac-8156-68ddc1f57179","version":3}
`

func MyTransfer(token *TokenERC20,password string,toaddr string ,value int64)  {
//构建合法交易
	auth, eer := bind.NewTransactor(strings.NewReader(key), password)
	if eer!=nil {
		log.Fatalf("构建交易失败",eer)
	}
	fmt.Println("交易成功",auth)
	auth.GasPrice=big.NewInt(1000000000);
    //发起交易，给一个账号发送token
	tx, eer := token.Transfer(auth, common.HexToAddress(toaddr), big.NewInt(value))
	if eer!=nil {
		log.Fatalf("构建交易Transfer失败",eer)
	}
	fmt.Println("交易成功",tx.Hash())

}
