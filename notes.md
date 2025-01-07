# Step - 1

```bash
export impersonation_account=0xf1dA173228fcf015F43f3eA15aBBB51f0d8f1123
export receiver=0x6B175474E89094C44Da98b954EedeAC495271d0F
export DAI=0x6B175474E89094C44Da98b954EedeAC495271d0F
export amount=2581366963101906549127
```

# Step - 2 impersonate

```bash
cast rpc hardhat_impersonateAccount $impersonation_account --rpc-url https://rpc.buildbear.io/mighty-captainamerica-167b8637
```

# Step - 3 Send Tx

```bash
cast send $DAI \
--from $impersonation_account \
 "transfer(address,uint256)(bool)" \
 $receiver \
 $amount \
 --unlocked --rpc-url https://rpc.buildbear.io/mighty-captainamerica-167b8637
```
