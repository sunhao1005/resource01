package ethereum

import (
	"fmt"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/zhouyasong/tbcexchange/log"
	"math/big"
	"strings"
)

type ethSubmit struct {
	OrderId      uint64    `json:"order_id"`
	To           common.Address  `json:"to"`
	Sell         *big.Int        `json:"sell_amount"`
	SellCoinType [32]byte        `json:"sell_coin_type"`
	ContractAddr common.Address   `json:"contract_address"`
}

//构造submit
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

func (client Client)SubmitOrder(submit *ethSubmit) error {
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

	tx,err:=tokenme.Submit(auth,submit.OrderId,submit.To,submit.Sell,submit.SellCoinType,submit.ContractAddr)
	if err!=nil {
		fmt.Println("submit订单失败",err)
		return  err
	}
	log.Debug("submit订单成功：",tx.Hash().String())
	return  nil

}