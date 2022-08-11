const String tableProduct='product';

class ProductField{
  static final List<String > values=[
    productID,productName,productCode,unitPrice,image,localName,productCategoryID,productStatus,productCategoryName,productAdons,nonProductAdons,productAdonIds,productAdonNames
  ];
  static const String productID = '_productID';
  static const String productName ='productName';
  static const String productCode='productCode';
  static const String unitPrice='unitPrice';
  static const String image='image';
  static const String localName='localName';
  static const String productCategoryID='productCategoryID';
  static const String productStatus='productStatus';
  static const String productCategoryName='productCategoryName';
  static const String productAdons='productAdons';
  static const String nonProductAdons='nonProductAdons';
  static const String productAdonIds='productAdonIds';
  static const String productAdonNames='productAdonNames';

}

class Product{
  final int? productID;
  final String? productName;
  final String? productCode;
  final double? unitPrice;
  final String? image;
  final String? localName;
  final int? productCategoryID;
  final int? productStatus;
  final String? productCategoryName;
  final String? productAdons;
  final String? nonProductAdons;
  final String? productAdonIds;
  final String? productAdonNames;

  Product({this.productID,required this.productName,required this.productCode,required this.unitPrice,required this.image,required this.localName,required this.productCategoryID,
  required this.productStatus,
  required this.productCategoryName,
  required this.productAdons,
  required this.nonProductAdons,
  required this.productAdonIds,
  required this.productAdonNames
  
  });

 Product copy({int? id,String? productName,String? productCode,double? unitPrice,String? image,String? localName,int? productCategoryID
 ,int? productStatus,String? productCategoryName,String? productAdons,String? nonProductAdons,String? productAdonIds, String? productAdonNames
 
 })=>
Product(
productID: id??this.productID,
productName: productName??this.productName,
productCode: productCode??this.productCode,
unitPrice: unitPrice??this.unitPrice,
image: image??this.image,
localName: localName??this.localName,
productCategoryID: productCategoryID??this.productCategoryID,
productStatus: productStatus??this.productStatus,
productCategoryName: productCategoryName??this.productCategoryName,
productAdons: productAdons??this.productAdons,
nonProductAdons: nonProductAdons??this.nonProductAdons,
productAdonIds: productAdonIds??this.productAdonIds,
productAdonNames: productAdonNames??this.productAdonNames,


);
static Product fromJson (Map<String,Object?>json)=>Product(
  productID: json[ProductField.productID] as int?,
  productName: json[ProductField.productName] as String?,
  productCode: json[ProductField.productCode] as String?,
  unitPrice: json[ProductField.unitPrice] as double?,
  image: json[ProductField.image] as String?,
  localName: json[ProductField.localName] as String?,
   productCategoryID: json[ProductField.productCategoryID] as int?,
    productStatus: json[ProductField.productStatus] as int?,
     productCategoryName: json[ProductField.productCategoryName] as String?,
      productAdons: json[ProductField.productAdons] as String?,
       nonProductAdons: json[ProductField.nonProductAdons] as String?,
        productAdonIds: json[ProductField.productAdonIds] as String?,
         productAdonNames: json[ProductField.productAdonNames] as String?,
  
);

  Map<String,Object?> toJson()=>{
ProductField.productID:productID ,
ProductField.productName: productName,
ProductField.productCode: productCode,
ProductField.unitPrice: unitPrice,
ProductField.image: image,
ProductField.localName: localName,
ProductField.productCategoryID: productCategoryID,
ProductField.productStatus: productStatus,
ProductField.productCategoryName: productCategoryName,
ProductField.productAdons: productAdons,
ProductField.nonProductAdons: nonProductAdons,
ProductField.productAdonIds: productAdonIds,
ProductField.productAdonNames: productAdonNames,



  };
}