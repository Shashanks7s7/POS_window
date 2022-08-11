const String tableOrderType="orderType";

class OrderTypeField{
  static final List<String > values=[
    orderTypeID,orderTypeName,orderTypeCode
  ];
  static const String orderTypeID = '_orderTypeID';
  static const String orderTypeName ='orderTypeName';
  static const String orderTypeCode='orderTypeCode';
}

class OrderType{
  final int? orderTypeID;
  final String orderTypeName;
  final String orderTypeCode;

  OrderType({this.orderTypeID, 
  required this.orderTypeName, 
  required this.orderTypeCode});

OrderType copy({int? id,String? orderTypeName,String? orderTypeCode})=>
OrderType(
orderTypeID: id??this.orderTypeID,
orderTypeName: orderTypeName??this.orderTypeName,
orderTypeCode: orderTypeCode??this.orderTypeCode

);
static OrderType fromJson (Map<String,Object?>json)=>OrderType(
  orderTypeID: json[OrderTypeField.orderTypeID] as int?,
  orderTypeName: json[OrderTypeField.orderTypeName] as String,
  orderTypeCode: json[OrderTypeField.orderTypeCode] as String,
);



  Map<String,Object?> toJson()=>{
    OrderTypeField.orderTypeID:orderTypeID ,
    OrderTypeField.orderTypeName: orderTypeName,
    OrderTypeField.orderTypeCode: orderTypeCode

  };
  

}