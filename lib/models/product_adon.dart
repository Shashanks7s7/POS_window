const String tableProductAdon='productAdon';

class ProductAdonField{
  static final List<String > values=[
    productAdonID,adonName,adonCode,localAdonName,rate
  ];
  static const String productAdonID = '_productAdonID';
  static const String adonName ='adonName';
  static const String adonCode='adonCode';
   static const String localAdonName='localAdonName';
    static const String rate='rate';
}

class ProductAdon{
  final int? productAdonID;
  final String adonName;
  final String adonCode;
  final String localAdonName;
  final double rate;

  ProductAdon({this.productAdonID,required this.adonName,required this.adonCode, required this.localAdonName,required this.rate});

 ProductAdon copy({int? id,String? adonName,String? adonCode,String? localAdonName ,double? rate})=>
ProductAdon(
productAdonID: id??this.productAdonID,
adonName: adonName??this.adonName,
adonCode: adonCode??this.adonCode,
localAdonName: localAdonName??this.localAdonName,
rate: rate??this.rate,


);
static ProductAdon fromJson (Map<String,Object?>json)=>ProductAdon(
  productAdonID: json[ProductAdonField.productAdonID] as int?,
  adonName: json[ProductAdonField.adonName] as String,
  adonCode: json[ProductAdonField.adonCode] as String,
   localAdonName: json[ProductAdonField.localAdonName] as String,
    rate: json[ProductAdonField.rate] as double,
);

  Map<String,Object?> toJson()=>{
ProductAdonField.productAdonID:productAdonID ,
ProductAdonField.adonName: adonName,
ProductAdonField.adonCode: adonCode,
ProductAdonField.localAdonName: localAdonName,
ProductAdonField.rate: rate

  };
}