// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NoUsefulToken is ERC721, Ownable {
    uint256 public _tokenIdCounter = 1;

    constructor(address initialOwner)
        ERC721("NoUseful", "NOUSE")
        Ownable(initialOwner)
    {}

    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter;
        _safeMint(to, tokenId);
        _tokenIdCounter += 1;
    }
}

contract HWToken is ERC721, Ownable {

    uint256 public _tokenIdCounter = 1;

    constructor(address initialOwner)
        ERC721("HW_Token", "HW_TOKEN")
        Ownable(initialOwner)
    {}

    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter;
        _safeMint(to, tokenId);
        _tokenIdCounter += 1;
    }

    function tokenURI(uint256 tokenId) public view override virtual returns (string memory) {
        _requireOwned(tokenId);

        string memory baseURI = _baseURI();
        return baseURI;
    }

    function _baseURI() internal view override virtual returns (string memory) {
        return "ipfs://QmejLcxdzpbMkuvdR3zMoMyPPgYZrv3aTUQwkckW1pZv5n/";
    }
}

contract NFTReceiver is IERC721Receiver {
    address public HWTokenContract;
    address public NoUseTokenContract;

    constructor(address HWTokenAddress, address NoUseTokenAddress) {
        HWTokenContract = HWTokenAddress;
        NoUseTokenContract = NoUseTokenAddress;
    }

    function onERC721Received( address operator, address from, uint256 tokenId, bytes calldata data ) public override returns (bytes4) {
        //Check the msg.sender is the same as HWTokenContract or not.
        if (msg.sender != HWTokenContract) {

            // If not, transfer the NoUseful Token back to the original owner.
            ERC721(NoUseTokenContract).transferFrom(address(this), from, tokenId);

            // Mint a HW_Token for the original owner.
            (bool success,) = HWTokenContract.call(abi.encodeWithSignature("safeMint(address)", from));
            require(success, "HWTokenContract mint fail");
        }

        return this.onERC721Received.selector;
    }
}