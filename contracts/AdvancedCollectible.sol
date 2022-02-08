// SPDX-License-Identified MIT
pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract AdvancedCollectible is ERC721, VRFConsumerBase {
  uint256 public tokenCounter;
  bytes32 public keyhash;
  uint256 public fee;
  enum Picture{EVENING, SNOW, MOUNTAIN}
  mapping(uint256 => Picture) public tokenIdToPicture;
  mapping(bytes32 => address) public requestIdToSender;
  event requestedCollectible(bytes32 indexed requestId, address requester);
  event pictureAssigned(uint256 indexed tokenId, Picture picture);

  constructor(
    address _vrfCoordinator,
    address _linkToken,
    bytes32 _keyhash,
    uint256 _fee
  ) public
    VRFConsumerBase(_vrfCoordinator, _linkToken)
    ERC721("Evening", "EVN")
  {
    tokenCounter = 0;
    keyhash = _keyhash;
    fee = _fee;
  }

  function createCollectible() public returns (bytes32) { // No input parameters on createCollectible since there is no tokenURI initially created
    bytes32 requestId = requestRandomness(keyhash, fee); // https://docs.chain.link/docs/get-a-random-number/
    requestIdToSender[requestId] = msg.sender;
    emit requestedCollectible(requestId, msg.sender);
  }

  function fulfillRandomness(bytes32 requestId, uint256 randomNumber) internal override {
    Picture picture = Picture(randomNumber % 3); // Because we have 3 different picture types
    uint256 newTokenId = tokenCounter;
    tokenIdToPicture[newTokenId] = picture;
    emit pictureAssigned(newTokenId, picture);
    address owner = requestIdToSender[requestId];
    _safeMint(owner, newTokenId);
    tokenCounter = tokenCounter + 1;
  }

  function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
    // Only owner of tokenID can update the tokenURI
    require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not owner or approved"); // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
    _setTokenURI(tokenId, _tokenURI);
  }
}
