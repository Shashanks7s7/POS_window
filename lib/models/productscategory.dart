const String tableProductsCategory="productsCategory";

class ProductsCategoryField{
  static final List<String > values=[
    productCategoryID,categoryName,categoryCode
  ];
  static const String productCategoryID = '_productCategoryID';
  static const String categoryName ='categoryName';
  static const String categoryCode='categoryCode';
  
}

class ProductsCategory{
  final int? productCategoryID;
  final String categoryName;
  final String categoryCode;
  

  ProductsCategory({this.productCategoryID, 
  required this.categoryName, 
  required this.categoryCode
  ,
  });

ProductsCategory copy({int? id,String? categoryName,String? categoryCode,String? products})=>
ProductsCategory(
productCategoryID: id??this.productCategoryID,
categoryName: categoryName??this.categoryName,
categoryCode: categoryCode??this.categoryCode,


);
static ProductsCategory fromJson (Map<String,Object?>json)=>ProductsCategory(
  productCategoryID: json[ProductsCategoryField.productCategoryID] as int?,
  categoryName: json[ProductsCategoryField.categoryName] as String,
  categoryCode: json[ProductsCategoryField.categoryCode] as String,
    
);



  Map<String,Object?> toJson()=>{
    ProductsCategoryField.productCategoryID:productCategoryID ,
    ProductsCategoryField.categoryName: categoryName,
    ProductsCategoryField.categoryCode: categoryCode,
    

  };
  

}