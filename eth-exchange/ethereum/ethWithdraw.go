package ethereum

import (
	"context"
	"fmt"
)

type ethWithdraw struct {
	OrderId uint64        `json:"order_id"`
	EthTx           ethTransaction  `json:"eth_transaction"`
}

func(client Client) WithdrawOrder(ctx context.Context,ed ethtxdata) error {
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