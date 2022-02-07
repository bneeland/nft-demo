// SPDX-License-Identified MIT

pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Similar to code in:
// https://docs.openzeppelin.com/contracts/3.x/erc721
contract SimpleCollectible in ERC721 {
  uint256 public tokenCounter;

  constructor () public ERC721 ("Evening", "EVN") { // https://docs.openzeppelin.com/contracts/3.x/erc721
    tokenCounter = 0;
  }

  function createCollective(string memory tokenURI) public returns (uint256) {
    uint256 newTokenId = tokenCounter;
    _safeMint(msg.sender, newTokenId); // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
    _setTokenURI(newTokenId, tokenURI)
    tokenCounter = tokenCounter + 1;
    return newTokenId;
  }
}
