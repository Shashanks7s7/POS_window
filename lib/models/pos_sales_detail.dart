const String tablePosSalesDetails='POSSalesDetail';

class POSSalesDetailField{
  static final List<String > values=[
    pOSSalesDetailID,pOSSalesMasterID,productID,quantity,rate,notes,adonIDs,extraAdonIDs
  ];
  static const String pOSSalesDetailID = '_pOSSalesDetilID';
  static const String pOSSalesMasterID ='pOSSalesMasterID';
  static const String productID='productID';
  static const String quantity='quantity';
  static const String rate='rate';
  static const String notes='notes';
  static const String adonIDs='adonIDs';
   static const String extraAdonIDs='extraAdonIDs';

}

class POSSalesDetail{
  final int? pOSSalesDetailID;
  final int pOSSalesMasterID;
  final int productID;
  final int quantity;
  final String rate;
  final String notes;
  final String adonIDs;
  final String extraAdonIDs;

  POSSalesDetail({this.pOSSalesDetailID,required this.pOSSalesMasterID,required this.productID,required this.quantity,required this.rate,required this.notes,required this.adonIDs,required this.extraAdonIDs});

 POSSalesDetail copy({int? id,int? pOSSalesMasterID,int? productID,int? quantity,String? rate,String? notes,String? adonIDs,String? extraAdonIDs})=>
POSSalesDetail(
pOSSalesDetailID: id??this.pOSSalesDetailID,
pOSSalesMasterID: pOSSalesMasterID??this.pOSSalesMasterID,
productID: productID??this.productID,
quantity: quantity??this.quantity,
rate: rate??this.rate,
notes: notes??this.notes,
adonIDs: adonIDs??this.adonIDs,
extraAdonIDs: extraAdonIDs??this.extraAdonIDs


);
static POSSalesDetail fromJson (Map<String,Object?>json)=>POSSalesDetail(
  pOSSalesDetailID: json[POSSalesDetailField.pOSSalesDetailID] as int?,
  pOSSalesMasterID: json[POSSalesDetailField.pOSSalesMasterID] as int,
  productID: json[POSSalesDetailField.productID] as int,
  quantity: json[POSSalesDetailField.quantity] as int,
  rate: json[POSSalesDetailField.rate] as String,
  notes: json[POSSalesDetailField.notes] as String,
   adonIDs: json[POSSalesDetailField.adonIDs] as String,
    extraAdonIDs: json[POSSalesDetailField.extraAdonIDs] as String,
  
);

  Map<String,Object?> toJson()=>{
POSSalesDetailField.pOSSalesDetailID:pOSSalesDetailID ,
POSSalesDetailField.pOSSalesMasterID: pOSSalesMasterID,
POSSalesDetailField.productID: productID,
POSSalesDetailField.quantity: quantity,
POSSalesDetailField.rate: rate,
POSSalesDetailField.notes: notes,
POSSalesDetailField.adonIDs: adonIDs,
POSSalesDetailField.extraAdonIDs: extraAdonIDs

  };
}