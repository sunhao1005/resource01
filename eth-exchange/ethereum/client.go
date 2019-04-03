package ethereum

import (
	"context"
	"github.com/ethereum/go-ethereum/rlp"
	"math/big"

	"github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/ethereum/go-ethereum/rpc"
)

type Client struct {
	*rpc.Client
	eth *ethclient.Client
}

func NewClient(url string) (*Client, error) {
	client, err := rpc.Dial(url)
	if err != nil {
		return nil, err
	}
	return &Client{
		Client: client,
		eth:    ethclient.NewClient(client),
	}, nil
}



//发送交易
func (client *Client) SendSignedTransaction(ctx context.Context, tx *ethTransaction) error {
	data, err := rlp.EncodeToBytes(tx)
	if err != nil {
		return err
	}
	return client.CallContext( ctx,nil, "eth_sendRawTransaction", common.ToHex(data))
}


/*func (client *Client) SendSignedTransaction(signedTx string) (string, error) {
	var hash *common.Hash
	err := client.Call(hash, "eth_sendRawTransaction", padHexPrefix(signedTx))
	if err != nil {
		return "", err
	}
	return hash.String(), nil
}*/

func (client *Client) GetGasPrice() (string, error) {
	b, err := client.eth.SuggestGasPrice(context.Background())
	if err != nil {
		return "", err
	}
	return b.String(), nil
}

func (client *Client) EstimateGas(msg ethereum.CallMsg) (uint64, error) {
	return client.eth.EstimateGas(context.Background(), msg)
}

func (client *Client) GetBlockNumber() (string, error) {
	var b *big.Int
	err := client.Call(b, "eth_blockNumber")
	if err != nil {
		return "", err
	}
	return b.String(), nil
}

func padHexPrefix(str string) string {
	if len(str) >= 2 && str[0] == '0' && (str[1] == 'x' || str[1] == 'X') {
		return str
	} else {
		return "0x" + str
	}
}
