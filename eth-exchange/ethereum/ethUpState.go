package ethereum

import (
	"fmt"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"strings"
	"github.com/zhouyasong/tbcexchange/log"
)

func(client Client) UpState(orderid uint64) error {
	tokenme,err:=NewExchange(common.HexToAddress(CONTRACT_ADDRESS_OWNER),client.eth)
	if err!=nil {
		fmt.Println("连接交易所合约失败：",err)
		return err
	}
	auth,err:=bind.NewTransactor(strings.NewReader(keystore),password)
	if err!=nil {
		fmt.Println("构建交易失败",err)
		return err
	}

	tx,err:=tokenme.Upstate(auth,orderid)
	if err!=nil {
		fmt.Println("更新订单状态失败",err)
		return  err
	}
	log.Debug("更新订单状态成功：",tx.Hash().String())
	return  nil
}
