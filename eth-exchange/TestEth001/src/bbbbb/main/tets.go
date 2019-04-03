package main

import (
	"fmt"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
	"log"
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
	tot,eer:=token.TotalSupply(nil)
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





	}


