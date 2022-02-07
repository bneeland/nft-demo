from brownie import SimpleCollectible
from scripts.helpful_scripts import get_account

token_uri = 'https://ipfs.io/ipfs/QmYcBkgTi8Zta8xCkMjrrycDr5RrR3Qs4h4fE3pGBQAq3N?filename=1.json'
OPENSEA_URL = 'https://testnets.opensea.io/assets/{}/{}'

def deploy_and_create():
    account = get_account()
    simple_collectible = SimpleCollectible.deploy({"from": account})
    tx = simple_collectible.createCollectible(token_uri, {"from": account})
    tx.wait(1)
    print(f"NFT deployed at {OPENSEA_URL.format(simple_collectible.address, simple_collectible.tokenCounter() - 1)}")
    print("Wait up to 20 minutes and hit refresh metadata button")

def main():
    deploy_and_create()
