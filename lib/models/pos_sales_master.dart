

const String tablePOSSalesMaster = 'POSSalesMaster';

class POSSalesMasterField {
  static final List<String> values = [
    pOSSalesMasterID,
    salesNo,
    customerID,
    orderTypeID,
    isVoid,
    voidReason,
    voidBy,
    voidDate,
    netAmount,
    taxPercentage,
    grandTotal,
    remarks,
    status,
    createdBy,
    createdDate,
    discountType,
    discount,
    salesStatus
  ];
  static const String pOSSalesMasterID = '_pOSSalesMasterID';
  static const String salesNo = 'salesNo';
  static const String customerID = 'customerID';
  static const String orderTypeID = 'orderTypeID';
  static const String isVoid = 'isVoid';
  static const String voidReason = 'voidReason';
  static const String voidBy = 'voidBy';
  static const String voidDate = 'voidDate';
  static const String netAmount = 'netAmount';
  static const String taxPercentage = 'taxPercentage';
  static const String grandTotal = 'grandTotal';
  static const String remarks = 'remarks';
  static const String status = 'status';
  static const String createdBy = 'createdBy';
  static const String createdDate = 'createdDate';
  static const String discountType = 'discountType';
  static const String discount = 'discount';
  static const String salesStatus = 'salesStatus';
}

class POSSalesMaster {
  final int? pOSSalesMasterID;
  final String salesNo;
  final int customerID;
  final int orderTypeID;
  final bool isVoid;
  final String voidReason;
  final String voidBy;
  final String voidDate;
  final double netAmount;
  final double taxPercentage;
  final double grandTotal;
  final String remarks;
  final int status;
  final String createdBy;
  final DateTime createdDate;
  final String discountType;
  final double discount;
  final int salesStatus;

  POSSalesMaster({this.pOSSalesMasterID, required this.salesNo, required this.customerID, required this.orderTypeID, required this.isVoid, required this.voidReason, required this.voidBy, required this.voidDate, required this.netAmount, required this.taxPercentage, required this.grandTotal, required this.remarks, required this.status, required this.createdBy, required this.createdDate, required this.discountType, required this.discount, required this.salesStatus});

  

  POSSalesMaster copy(
          {int? id,
          String? salesNo,
          int? customerID,
          int? orderTypeID,
          bool? isVoid,
          String? voidReason,
          String? voidBy,
   String? voidDate,
   double? netAmount,
   double? taxPercentage,
   double? grandTotal,
   String? remarks,
   int? status,
   String? createdBy,
   DateTime? createdDate,
   String? discountType,
   double? discount,
   int? salesStatus,

          
          
          
          
          }) =>
      POSSalesMaster(
          pOSSalesMasterID: id ?? this.pOSSalesMasterID,
          salesNo: salesNo ?? this.salesNo,
          customerID: customerID ?? this.customerID,
          orderTypeID: orderTypeID ?? this.orderTypeID,
          isVoid: isVoid ?? this.isVoid,
          voidReason: voidReason ?? this.voidReason,
          voidBy: voidBy ?? this.voidBy,
            voidDate: voidDate ?? this.voidDate,
              netAmount: netAmount ?? this.netAmount,
                taxPercentage: taxPercentage ?? this.taxPercentage,
                  grandTotal: grandTotal ?? this.grandTotal,
                    remarks: remarks ?? this.remarks,
                      status: status ?? this.status,
                        createdBy: createdBy ?? this.createdBy,
                          createdDate: createdDate ?? this.createdDate,
                            discountType: discountType ?? this.discountType,
                              discount: discount ?? this.discount,
                                salesStatus: salesStatus ?? this.salesStatus,

          
          );


  static POSSalesMaster fromJson(Map<String, Object?> json) => POSSalesMaster(
        pOSSalesMasterID: json[POSSalesMasterField.pOSSalesMasterID] as int?,
        salesNo: json[POSSalesMasterField.salesNo] as String,
        customerID: json[POSSalesMasterField.customerID] as int,
        orderTypeID: json[POSSalesMasterField.orderTypeID] as int,
        isVoid: json[POSSalesMasterField.isVoid] ==1,
        voidReason: json[POSSalesMasterField.voidReason] as String,
        voidBy: json[POSSalesMasterField.voidBy] as String,
         voidDate:json[POSSalesMasterField.voidDate] as String,
          netAmount: json[POSSalesMasterField.netAmount] as double,
           taxPercentage: json[POSSalesMasterField.taxPercentage] as double,
            grandTotal: json[POSSalesMasterField.grandTotal] as double,
             remarks: json[POSSalesMasterField.remarks] as String,
              status: json[POSSalesMasterField.status] as int,
               createdBy: json[POSSalesMasterField.createdBy] as String,
                createdDate: DateTime.parse(json[POSSalesMasterField.createdDate] as String),
                 discountType: json[POSSalesMasterField.discountType] as String,
                  discount:json[POSSalesMasterField.discount] as double,
                   salesStatus: json[POSSalesMasterField.salesStatus] as int,

      );

  Map<String, Object?> toJson() => {
        POSSalesMasterField.pOSSalesMasterID: pOSSalesMasterID,
        POSSalesMasterField.salesNo: salesNo,
        POSSalesMasterField.customerID: customerID,
        POSSalesMasterField.orderTypeID: orderTypeID,
        POSSalesMasterField.isVoid: isVoid?1:0,
        POSSalesMasterField.voidReason: voidReason,
        POSSalesMasterField.voidBy: voidBy,
        POSSalesMasterField.voidDate: voidDate,
        POSSalesMasterField.netAmount: netAmount,
        POSSalesMasterField.taxPercentage: taxPercentage,
        POSSalesMasterField.grandTotal: grandTotal,
        POSSalesMasterField.remarks: remarks,
        POSSalesMasterField.status: status,
        POSSalesMasterField.createdBy: createdBy,
        POSSalesMasterField.createdDate: createdDate.toIso8601String(),
        POSSalesMasterField.discountType: discountType,
        POSSalesMasterField.discount: discount,
        POSSalesMasterField.salesStatus: salesStatus,
        
      };
}
