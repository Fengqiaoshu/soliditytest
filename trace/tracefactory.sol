// SPDX-License-Identifier: Apache-2.0
pragma solidity^0.8.7;


import "./category.sol";

contract TraceFactory{
    struct GoodsCategory{
        Category categoryData;
        bool isExists;                  //是否存在
    }

    mapping(bytes32=>GoodsCategory) goodsCategorys;

    event NewCateGory(address _operator,bytrs32 _category);
    
    
    //创建商品种类
   function newCatrgory(bytes32 _category)public returns(Category){
        require(!goodsCategorys[_category],isExists," category already exists ");

        Category catrgory = new Category(_category);
        goodsCategorys[_category].isExists = true;
        goodsCategorys[_category].categoryData = catrgory;
        emit NewCateGory(msg.sender,_category);
        return catrgory;
   }
    // 创建商品
   function newGoods(bytes32 _category,uint256 _goodID) public returns(Goods) {
     Category catrgory = getCategory(_category);  
     return category.createGoods(_goodID);
   }

   function getCategory(bytes32 _category) public view returns(Category){
        return goodsCategorys[_category].categoryData;
   }

   function getStatus(bytes32 _category,uint256 _goodsID) public view returns(uint8) {
        Category catrgory = getCategory(_category);         // 先拿商品种类
        return catrgory.getStatus(_goodID);
   }

   function changeStatus(bytes32 _category,uint256 _goodsID,uint8 _status,string memory _remaek)public returns(bool){
        Category catrgory = getCategory(_category);
        return category.changeStatus(_goodsID,_status,_remaek);
   }
}