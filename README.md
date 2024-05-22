# Privacy

Privacy is one of the exercises available on the website [ethernaut.openzeppelin.com](https://ethernaut.openzeppelin.com/level/0x7414CBc5Af9A0A039839bD798D6C209AD89C9Cb4)

###### Introduction
The creator of this contract was careful enough to protect the sensitive areas of its storage.

Unlock this contract to beat the level.

Things that might help:

- Understanding how storage works
- Understanding how parameter parsing works
- Understanding how casting works
 
Tips:
*Remember that metamask is just a commodity. Use another tool if it is presenting problems. Advanced gameplay could involve using remix, or your own web3 provider.*

### Setup

To setup the project you just have to setup your env variable :
```.env
AMOY_RPC_URL=https://polygon-amoy-bor-rpc.publicnode.com
PRIVATE_KEY={YOUR_PRIVATE_KEY}
```

Then you can use `forge test` to run test & 
```bash
forge script script/Privacy.s.sol --rpc-url $AMOY_RPC_URL --private-key $PRIVATE_KEY -vvv --broadcast
```

### Solution

To solve this problem you have to understand the slot system of storage memory.

```solidity
    bool public locked = true;                              // slot 0
    uint256 public ID = block.timestamp;                    // slot 1
    uint8 private flattening = 10;                          // slot 2
    uint8 private denomination = 255;                       // slot 2
    uint16 private awkwardness = uint16(block.timestamp);   // slot 2
    bytes32[3] private data;                                // slot 3-6
```
- `bool public locked` use one byte of the slot 0
- `uint256 public ID` use 32 bytes so it needs a new slot
- `uint8 private flattening` use one byte but the slot 1 is full, so it need a new slot : slot 2
- `uint8 private denomination` use one byte, it can go on slot 2
- `uint16 private awkwardness` use 2 bytes, it can go on slot 2
- `bytes32[3] private data` use 3 slots of 32 bytes each

To unlock the contract we need to found the **third** element of the array *data*

```solidity
function unlock(bytes16 _key) public {
        require(_key == bytes16(data[2]));
        locked = false;
    }
```

data is a three elements array, which start on slot 3.
The third element is on the slot **5**.
