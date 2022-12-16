// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7;

import"./IERC165";
import"./IERC721";

contract ERC721 is IERC165,IERC721{
    // erc -165  判定是否支持erc165
    mapping(bytes4=>bool) supportsInterfaces;
    // 往mapping内添加内容
    function _registerInterface(bytes4 interfaceID)internal{
        // 定义一个无效的id
        bytes4 invalidID = 0xffffffff;
        // 0x80ac58cd erc721
        // 0x01ffc9a7 erc165
        // supportsInterfaces[interfaceID];
        // 定义常量
        bytes4 constant ERC165_InterfaceID =0x01ffc9a7
    }

    constructor( ) {
        _registerInterface()
    }

    function _registerInterface(bytes4 interfaceID) internal {
        supportsInterfaces[interfaceID] = true;
    }

    function supportsInterface(bytes4 interfaceID) override external view returns(bool){
        require( invalidID != interfaceID," invalid interfaceID ");
        return supportsInterfaces[interfaceID];
    }

    function addres() public view  {
        
    }
} 