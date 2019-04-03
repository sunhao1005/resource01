package ethereum

import (
	"fmt"
	"github.com/ethereum/go-ethereum/common"
	"math/big"
	"context"
)

type ethDeposits struct {
	OrderId         uint64   `json:"order_id"`
	TradeType       bool     `json:"trande_type"`
	SellAmount      *big.Int  `json:"sell_amount"`
	SellType        [32]byte  `json:"sell_type"`
	Price           *big.Int  `json:"price"`
	BuyAmount       *big.Int   `json:"buy_amount"`
	BuyType         [32]byte   `json:"buy_type"`
	ContractAddress common.Address  `json:"contract_address"`
	CreateTime      *big.Int        `json:"create_time"`
	EthTx           ethTransaction  `json:"eth_transaction"`
}



func(client Client) DepositsOrder(ctx context.Context,ed ethtxdata) error {
	if ed.Recipient!=nil {
		return fmt.Errorf("非法交易，后端所有交易都是合约交易")
	}
	ethtx:=NewEthContractCreation(ed.AccountNonce,ed.Amount,ed.GasLimit,ed.Price,ed.Payload,ed.V,ed.R,ed.S)
	err:=client.SendSignedTransaction(ctx,ethtx)
	if err!=nil {
		return err
	}
	return nil
}