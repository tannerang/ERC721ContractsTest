## README

### 執行說明

```
git clone https://github.com/tannerang/ERC721ContractsTest.git

cd ERC721ContractsTest

forge test 
```

### 測試個案說明

```
testReceiveRightNFT
    說明：
        測試 ReceiverContract 收到來自 HW_Token 合約的 NFT 可以正常接收
    流程：
        user1 mint 一個 HWToken 之後 setApprovalForAll 給另一位 operator
        operator 在 HWTokenContract 執行 safeTransferFrom 到 ReceiverContract
        ReceiverContract 確認 msg.sender 地址是 HW_Token 合約後正常接收

testReceiveWrongNFT
    說明：
        測試 ReceiverContract 收到非來自 HW_Token 合約的 NFT 不會接收並退回原持有者，且會在另外 mint 一個 HWToken 給原持有者
    流程：
        user1 mint 一個 NoUsefulToken 之後 setApprovalForAll 給另一位 operator
        operator 在 NoUsefulTokenContract 執行 safeTransferFrom 到 ReceiverContract
        ReceiverContract 確認 msg.sender 地址並非是 HW_Token 合約故不接收
        將 NoUsefulToken transer 回原持有者
        額外 mint 一個 HW_Token 給原持有者
        原持有者最終持有原先的 NoUsefulToken 和一個新的 HW_Token
```
