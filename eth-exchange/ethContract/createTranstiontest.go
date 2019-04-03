package main

import (
	"context"
	"fmt"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/ethclient"
	"math/big"
	"strings"
)

/*const keystore  = `{"address":"94066127301abf11e1594ccad1582a4444e51c4d","crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"259e8835c732247ff24cf2c46700817d"},"ciphertext":"351d82ecea362123085b28be7a1de3fb2ef4fc1d93eb997573604dd2aef40767","kdf":"scrypt","kdfparams":{"dklen":32,"n":65536,"p":1,"r":8,"salt":"a107ebec40763392e747179e137d36755609ed289fa3e0e34d610c916d078104"},"mac":"53f8dd3c8b169b0641ac2cdfd5fbe8e01891fb4a864fa0fd7f691d8c2acac778"},"id":"e79c3a89-a263-4fac-8156-68ddc1f57179","version":3}
`
const password  = "17719317036"  //钱包密码*/

const ADDRESS_TO  ="0x2daF64B86d5b4aa224852EC0B7C1142557ad15fb"

func main(){
	/*auth,err:=bind.NewTransactor(strings.NewReader(keystore),password)
	if err!=nil {
		fmt.Println("构建交易失败",err)
		return
	}
	fmt.Println("构建交易成功",auth)
	auth.GasPrice=big.NewInt(2900000)
	auth.GasLimit=uint64(3000000)
	auth.Value=big.NewInt(1000)
	fmt.Println( "交易发起者：",auth.From.Hash())
	fmt.Println("发送的以太坊",*auth.Value)
	fmt.Println("gas上限",auth.GasLimit)
	fmt.Println("收取gas",*auth.GasPrice)
	fmt.Println("签名：",auth.Signer)*/

	conn,err:=ethclient.Dial(ETH_CONN_ADDRESS)
	if err!=nil {
		fmt.Println("连接以太坊失败:",err)
		return
	}
	fmt.Println("连接成功",conn)

	auth,err:=bind.NewTransactor(strings.NewReader(keystore),password)
	if err!=nil {
		fmt.Println("构建交易失败",err)
		return
	}
	fmt.Println("构建交易成功",auth)
	nonce,err:=conn.PendingNonceAt(context.Background(),common.HexToAddress(ADDRESS_ME))
	if err!=nil {
		fmt.Println("nonce error:",err)
		return
	}
	auth.GasPrice=big.NewInt(2000000)
	auth.GasLimit=uint64(3000000)
	auth.Value=big.NewInt(10000000)
	auth.From=common.HexToAddress(ADDRESS_ME)
	auth.Nonce=big.NewInt(int64(nonce))


	tx :=types.NewTransaction(nonce,common.HexToAddress(ADDRESS_TO),big.NewInt(10000000),uint64(3000000),big.NewInt(2000000),[]byte{})

	fmt.Println("tx:",tx)
	ss,_:=tx.MarshalJSON()
	fmt.Println(string(ss))
	fmt.Println("#################")
	signedtx,err:=auth.Signer(types.HomesteadSigner{},auth.From,tx)
	if err !=nil{
		fmt.Println("sign error :",err)
		return
	}
	fmt.Println(signedtx)
	fmt.Println("********************")
	ssb,_:=signedtx.MarshalJSON()
	fmt.Println(string(ssb))

	errrs:=conn.SendTransaction(context.Background(),signedtx)
	if err!=nil {
		fmt.Println("send error:",errrs)
		return
	}
	resp,errrrr:=bind.WaitMined(context.Background(),conn,signedtx)
	if errrrr!=nil {
		fmt.Println("wait error:",errrs)
		return
	}
    fmt.Println("成功：",resp.TxHash.String())
}

//打印结果
/*F:\GoWorks\src\github.com\zhouyasong\exchange-contract\ethContract>ethContract.exe
连接成功 &{0xc0000ca200}
构建交易成功 &{[148 6 97 39 48 26 191 17 225 89 76 202 209 88 42 68 68 229 28 77] <nil> 0x667a20 <nil> <nil> 0 <nil>}
tx: &{{37 0xc000150100 3000000 0xc000012300 0xc0001500e0 [] 0xc000150120 0xc000150140 0xc000150160 <nil>} {<nil>} {<nil>} {<nil>}}
{"nonce":"0x25","gasPrice":"0x1e8480","gas":"0x2dc6c0","to":"0x2daf64b86d5b4aa224852ec0b7c1142557ad15fb","value":"0x989680","input":"0x","v":"0x0","r":"0x0","s":"0x0","hash":"0xa34d2bb4ba80b6bec96bd0bc57c3283f8f9bfa4184fe57df59b1d8d1a831637d"}
#################
&{{37 0xc000150100 3000000 0xc000012300 0xc0001500e0 [] 0xc00004a5e0 0xc00004a4a0 0xc00004a4e0 <nil>} {<nil>} {<nil>} {<nil>}}
********************
{"nonce":"0x25","gasPrice":"0x1e8480","gas":"0x2dc6c0","to":"0x2daf64b86d5b4aa224852ec0b7c1142557ad15fb","value":"0x989680","input":"0x","v":"0x1b","r":"0x48fb7b8e2dd1bc10ea2b3714894ed7525173a96c6ef3b4888ce06b8bbe5b4089","s":"0x7435fdabda222e25a512bcf3c462158708a3d74bcff414d940df666db7712dbe","hash":"0x72f3efafcead9a4a3d337ac4621aac1bc43c60f93a4e5a8e635b0bd808bc015c"}
成功： 0x72f3efafcead9a4a3d337ac4621aac1bc43c60f93a4e5a8e635b0bd808bc015c
*/
