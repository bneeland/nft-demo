from scripts.helpful_scripts import get_account, SimpleCollectible

token_uri = ''

def main():
    account = get_account()
    simple_collective = SimpleCollectible.deploy({"from": account})
