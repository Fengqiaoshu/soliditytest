// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7;

import"./ERC165";

/**
 * @dev ERC721标准接口.
 */

// IERC721 继承 ERC165 
interface IERC721 is IERC165 {
    // 事件 
    // 当发生转账是记录事件 from to tokenId
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    // 当发生授权时记录事件 owner授权地址  approved 被授权地址 tokenId
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    // 当批量授权时记录事件 owner授权地址  approved 被授权地址 approved 授权与否
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    // 返回nft持有量
    function balanceOf(address owner) external view returns (uint256 balance);
    // 返回某tokenid 的主人 owener
    function ownerOf(uint256 tokenId) external view returns (address owner);
    // 安全转账的重载函数，参数里面包含了data
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
    // 安全转账（如果接收方是合约地址，会要求实现
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    // ，参数为转出地址from，接收地址to和tokenId
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
    // 授权另一个地址使用你的NFT。参数为被授权地址approve和tokenId
    function approve(address to, uint256 tokenId) external;
    // 将自己持有的该系列NFT批量授权给某个地址operator
    function setApprovalForAll(address operator, bool _approved) external;
    // 查询tokenId被批准给了哪个地址
    function getApproved(uint256 tokenId) external view returns (address operator);
    // 查询某地址的NFT是否批量授权给了另一个operator地址
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    
}