const String tablePOSSalesPayment='POSSalesPayment';

class POSSalesPaymentField{
  static final List<String > values=[
    pOSSalesPaymentID,pOSSalesMasterID,paymentModeID,amount,status,createdBy,createdDate
  ];
  static const String pOSSalesPaymentID = '_pOSSalesPaymentID';
  static const String pOSSalesMasterID ='pOSSalesMasterID';
  static const String paymentModeID='paymentModeID';
  static const String amount='amount';
  static const String status='status';
  static const String createdBy='createdBy';
  static const String createdDate='createdDate';
  
}

class POSSalesPayment{
  final int? pOSSalesPaymentID;
  final int pOSSalesMasterID;
  final int paymentModeID;
  final double amount;
  final int status;
  final String createdBy;
  final DateTime createdDate;
  

  POSSalesPayment({this.pOSSalesPaymentID,required this.pOSSalesMasterID,required this.paymentModeID,required this.amount,required this.status,required this.createdBy,required this.createdDate});

 POSSalesPayment copy({int? id,int? pOSSalesMasterID,int? paymentModeID,double? amount,int? status,String? createdBy,DateTime? createdDate})=>
POSSalesPayment(
pOSSalesPaymentID: id??this.pOSSalesPaymentID,
pOSSalesMasterID: pOSSalesMasterID??this.pOSSalesMasterID,
paymentModeID: paymentModeID??this.paymentModeID,
amount: amount??this.amount,
status: status??this.status,
createdBy: createdBy??this.createdBy,
createdDate: createdDate??this.createdDate,



);
static POSSalesPayment fromJson (Map<String,Object?>json)=>POSSalesPayment(
  pOSSalesPaymentID: json[POSSalesPaymentField.pOSSalesPaymentID] as int?,
  pOSSalesMasterID: json[POSSalesPaymentField.pOSSalesMasterID] as int,
  paymentModeID: json[POSSalesPaymentField.paymentModeID] as int,
  amount: json[POSSalesPaymentField.amount] as double,
  status: json[POSSalesPaymentField.status] as int,
  createdBy: json[POSSalesPaymentField.createdBy] as String,
   createdDate:DateTime.parse( json[POSSalesPaymentField.createdDate] as String),
  
  
);

  Map<String,Object?> toJson()=>{
POSSalesPaymentField.pOSSalesPaymentID:pOSSalesPaymentID ,
POSSalesPaymentField.pOSSalesMasterID: pOSSalesMasterID,
POSSalesPaymentField.paymentModeID: paymentModeID,
POSSalesPaymentField.amount: amount,
POSSalesPaymentField.status: status,
POSSalesPaymentField.createdBy: createdBy,
POSSalesPaymentField.createdDate: createdDate.toIso8601String(),


  };
}