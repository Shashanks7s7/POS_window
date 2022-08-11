const String tableProductAdonMappingInfo="productAdonMappingInfo";

class ProductAdonMappingInfoField{
  static final List<String > values=[
    productAdonMappingID, productID,productAdonID
  ];
  static const String productAdonMappingID = '_productAdonMappingID';
   
  static const String productID = 'productID';
  static const String productAdonID ='productAdonID';
  
 
}

class ProductAdonMappingInfo{
  final int? productAdonMappingID;
  final int productID;
  final int productAdonID;
  

  ProductAdonMappingInfo({ this.productAdonMappingID,required this.productID, 
  required this.productAdonID, 
 });

ProductAdonMappingInfo copy({int? id,int? productID ,int? productAdonID,   })=>
ProductAdonMappingInfo(
  productAdonMappingID: id??this.productAdonMappingID,
productID: productID??this.productID,
productAdonID: productAdonID??this.productAdonID,


);
static ProductAdonMappingInfo fromJson (Map<String,Object?>json)=>ProductAdonMappingInfo(
 productAdonMappingID: json[ProductAdonMappingInfoField.productAdonMappingID] as int?,
  productID: json[ProductAdonMappingInfoField.productID] as int,
  productAdonID: json[ProductAdonMappingInfoField.productAdonID] as int,


);



  Map<String,Object?> toJson()=>{
   ProductAdonMappingInfoField.productAdonMappingID:productAdonMappingID,
    ProductAdonMappingInfoField.productID:productID ,
    ProductAdonMappingInfoField.productAdonID: productAdonID,
    
  
    

  };
  

}