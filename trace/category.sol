// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7;

import "./goods.sol";


contract Category{
    struct GoodsData{
        Goods traceData;
        bool isExists;                  //是否存在
    }
    byte32 currentCategory;             // 商品種類
    mapping(uint256 =>GoodsData) goods;

    event NewGoods(address _operator,uint256 _goodsID);
    constructor(bytes32 _category){
        currentCategory = _category;
    }

    //創建
    function createGoods(uint256 _goodsID)public returns(Goods){
        require(!goods[_goodsID].isExists," goodsID already exists");

        goods[_goodsID].isExists = true;
        Goods _goods = new Goods(_goodsID);
        goods[_goodsID].traceData = _goods;

        emit NewGoods(msg.sender, _goodsID);
        return goods;
    }

    function getStatus(uint256 _goodID)public view returns(uint8){
        if(!goods[_goodID].isExists){
            return Goods.;
        }
        return goods[_goodID].traceData.getStatus();
    }
}