package ethereum

import (
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"math/big"
)

/*type ethTransaction struct {
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

//创建普通交易（用不上，后端交易主要是合约交易）
func NewEthTransaction(nonce uint64, to common.Address, amount *big.Int, gasLimit uint64, gasPrice *big.Int, data []byte, v *big.Int, r *big.Int, s *big.Int) *ethTransaction {
	return newEthTx(nonce, &to, amount, gasLimit, gasPrice, data, v, r, s)
}

//创建合约交易
func NewEthContractCreation(nonce uint64, amount *big.Int, gasLimit uint64, gasPrice *big.Int, data []byte, v *big.Int, r *big.Int, s *big.Int) *ethTransaction {
	return newEthTx(nonce, nil, amount, gasLimit, gasPrice, data, v, r, s)
}

//创建交易(内部)
func newEthTx(nonce uint64, to *common.Address, amount *big.Int, gasLimit uint64, gasPrice *big.Int, data []byte, v *big.Int, r *big.Int, s *big.Int) *ethTransaction {
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

	return &ethTransaction{data: d}
}
*/
//创建合约交易
func NewEthTx(nonce uint64, to *common.Address, amount *big.Int, gasLimit uint64, gasPrice *big.Int, data []byte, sig []byte) (*types.Transaction, error) {
	var tx *types.Transaction
	if to!=nil {
		tx = types.NewTransaction(nonce,*to,amount,gasLimit,gasPrice,data)
	}else {
		tx= types.NewContractCreation(nonce,amount,gasLimit,gasPrice,data)
	}
	var signer types.Signer

	return  tx.WithSignature(signer,sig)

}
