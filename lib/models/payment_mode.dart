const String tablePaymentMode="paymentMode";

class PaymentModeField{
  static final List<String > values=[
    paymentModeID,name,code
  ];
  static const String paymentModeID = '_paymentModeID';
  static const String name ='name';
  static const String code='code';
}

class PaymentMode{
  final int? paymentModeID;
  final String name;
  final String code;

  PaymentMode({this.paymentModeID, 
  required this.name, 
  required this.code});

PaymentMode copy({int? id,String? name,String? code})=>
PaymentMode(
paymentModeID: id??this.paymentModeID,
name: name??this.name,
code: code??this.code

);
static PaymentMode fromJson (Map<String,Object?>json)=>PaymentMode(
  paymentModeID: json[PaymentModeField.paymentModeID] as int?,
  name: json[PaymentModeField.name] as String,
  code: json[PaymentModeField.code] as String,
);



  Map<String,Object?> toJson()=>{
    PaymentModeField.paymentModeID:paymentModeID ,
    PaymentModeField.name: name,
    PaymentModeField.code: code

  };
  

}