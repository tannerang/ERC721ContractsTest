// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {NoUsefulToken, HWToken, NFTReceiver} from "../src/ERC721Contracts.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract ERC721ContractsTest is Test {

    NoUsefulToken public NoUsefulTokenContract;
    HWToken public HWTokenContract;
    NFTReceiver public NFTReceiverContract;
    address contractOwner = makeAddr("contract owner");
    address operator = makeAddr("operator");

    function setUp() public {
        NoUsefulTokenContract = new NoUsefulToken(contractOwner);
        HWTokenContract = new HWToken(contractOwner);
        NFTReceiverContract = new NFTReceiver(address(HWTokenContract), address(NoUsefulTokenContract));
    }

    function testReceiveRightNFT() public {
        address user1 = makeAddr("user1");
        vm.startPrank(user1);
        HWTokenContract.safeMint(user1);
        HWTokenContract.setApprovalForAll(operator, true);
        
        changePrank(operator);
        console2.log(HWTokenContract.ownerOf(1)); // should be user1
        console2.log(HWTokenContract.balanceOf(user1)); // should be 1

        (bool success,) = address(HWTokenContract).call(abi.encodeWithSignature("safeTransferFrom(address,address,uint256)", user1, address(NFTReceiverContract), 1));
        require(success, "Call safeTransferFrom fails.");
        console2.log(HWTokenContract.ownerOf(1)); // should be NFTReceiverContract
        console2.log(HWTokenContract.balanceOf(user1)); // should be 0

        vm.stopPrank();
    }

    function testReceiveWrongNFT() public {
        address user1 = makeAddr("user1");
        vm.startPrank(user1);
        NoUsefulTokenContract.safeMint(user1);
        NoUsefulTokenContract.setApprovalForAll(operator, true);
        
        changePrank(operator);
        console2.log(NoUsefulTokenContract.ownerOf(1)); // should be user1
        console2.log(HWTokenContract.balanceOf(user1)); // should be 0
        console2.log(HWTokenContract.balanceOf(address(NFTReceiverContract))); // should be 0

        (bool success,) = address(NoUsefulTokenContract).call(abi.encodeWithSignature("safeTransferFrom(address,address,uint256)", user1, address(NFTReceiverContract), 1));
        require(success, "Call safeTransferFrom fails.");
        console2.log(NoUsefulTokenContract.ownerOf(1)); // should be user1
        console2.log(HWTokenContract.balanceOf(user1)); // should be user1
        console2.log(HWTokenContract.ownerOf(1)); // should be 1
        console2.log(HWTokenContract.balanceOf(address(NFTReceiverContract))); // should be 0
        console2.log(NoUsefulTokenContract.balanceOf(address(NFTReceiverContract))); // should be 0

        vm.stopPrank();
    }
}