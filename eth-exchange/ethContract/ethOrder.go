package main

import (
	"context"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/rlp"
	"github.com/ethereum/go-ethereum/rpc"
	"math/big"
	"sync/atomic"
)

type Client struct {
	c *rpc.Client
}


type ethDeposits struct {
	OrderId   uint64
	TradeType bool
	SellAmount *big.Int
	SellType  [32]byte
	Price     *big.Int
	BuyAmount *big.Int
	BuyType   [32]byte
	ContractAddress common.Address
	CreateTime *big.Int
}

type ethWithdraw struct {
	OrderId   uint64
}

type ethSubmit struct {
	OrderId uint64
	To     common.Address
	Sell   *big.Int
	SellCoinType [32]byte
	ContractAddr common.Address
}


type ethTransaction struct {
	data ethtxdata
	// caches
	hash atomic.Value
	size atomic.Value
	from atomic.Value
}

type ethtxdata struct {

AccountNonce uint64          `json:"nonce"    gencodec:"required"`
Price        *big.Int        `json:"gasPrice" gencodec:"required"`
GasLimit     uint64          `json:"gas"      gencodec:"required"`
Recipient    *common.Address `json:"to"       rlp:"nil"` // nil means contract creation
Amount       *big.Int        `json:"value"    gencodec:"required"`
Payload      []byte          `json:"input"    gencodec:"required"`

// Signature values
V *big.Int `json:"v" gencodec:"required"`
R *big.Int `json:"r" gencodec:"required"`
S *big.Int `json:"s" gencodec:"required"`

// This is only used when marshaling to JSON.
Hash *common.Hash `json:"hash" rlp:"-"`
}

//创建交易
func NewEthTx(nonce uint64, to *common.Address, amount *big.Int, gasLimit uint64, gasPrice *big.Int, data []byte,v *big.Int,r *big.Int,s *big.Int)*ethTransaction  {
	if len(data) > 0 {
		data = common.CopyBytes(data)
	}
	d := ethtxdata{
		AccountNonce: nonce,
		Recipient:    to,
		Payload:      data,
		Amount:       new(big.Int),
		GasLimit:     gasLimit,
		Price:        new(big.Int),
		V:            v,
		R:            r,
		S:            s,
		//Hash:         hash,
	}
	if amount != nil {
		d.Amount.Set(amount)
	}
	if gasPrice != nil {
		d.Price.Set(gasPrice)
	}


	return &ethTransaction{data:d}
}



//发送交易
func (ec *Client) SendTrans(ctx context.Context, tx *ethTransaction) error {
	data, err := rlp.EncodeToBytes(tx)
	if err != nil {
		return err
	}
	return ec.c.CallContext(ctx, nil, "eth_sendRawTransaction", common.ToHex(data))
}




