const String tableCustomer='customer';

class CustomerField{
  static final List<String > values=[
    customerID,fullName,address,status,email,phoneNo,createdBy,createdDate,modifiedBy,modifiedDate
  ];
  static const String customerID = '_customerID';
  static const String fullName ='fullName';
  static const String address='address';
  static const String status='status';
  static const String email='email';
  static const String phoneNo='phoneNo';
 
  static const String createdBy='createdBy';
  static const String createdDate='createdDate';
  static const String modifiedBy='modifiedBy';
  static const String modifiedDate='modifiedDate';
  

}

class Customer{
  final int? customerID;
  final String? fullName;
  final String? address;
  final int? status;
  final String? email;
  final String? phoneNo;
  
  final String? createdBy;
  final DateTime createdDate;
  final String? modifiedBy;
  final DateTime modifiedDate;
 

  Customer({this.customerID,required this.fullName,required this.address,required this.status,required this.email,required this.phoneNo,
  
  required this.createdBy,
  required this.createdDate,
  required this.modifiedBy,
  required this.modifiedDate,
 
  
  });

 Customer copy({int? id,String? fullName,String? address,int? status,String? email,String? phoneNo,int? productCategoryID
 ,int? productStatus,String? createdBy,DateTime? createdDate,String? modifiedBy,DateTime? modifiedDate,
 
 })=>
Customer(
customerID: id??this.customerID,
fullName: fullName??this.fullName,
address: address??this.address,
status: status??this.status,
email: email??this.email,
phoneNo: phoneNo??this.phoneNo,

createdBy: createdBy??this.createdBy,
createdDate: createdDate??this.createdDate,
modifiedBy: modifiedBy??this.modifiedBy,
modifiedDate: modifiedDate??this.modifiedDate,



);
static Customer fromJson (Map<String,Object?>json)=>Customer(
  customerID: json[CustomerField.customerID] as int?,
  fullName: json[CustomerField.fullName] as String?,
  address: json[CustomerField.address] as String?,
  status: json[CustomerField.status] as int?,
  email: json[CustomerField.email] as String?,
  phoneNo: json[CustomerField.phoneNo] as String?,
 
     createdBy: json[CustomerField.createdBy] as String?,
      createdDate: DateTime.parse(json[CustomerField.createdDate] as String),
       modifiedBy: json[CustomerField.modifiedBy] as String?,
        modifiedDate: DateTime.parse(json[CustomerField.modifiedDate] as String),
        
  
);

  Map<String,Object?> toJson()=>{
CustomerField.customerID:customerID ,
CustomerField.fullName: fullName,
CustomerField.address: address,
CustomerField.status: status,
CustomerField.email: email,
CustomerField.phoneNo: phoneNo,

CustomerField.createdBy: createdBy,
CustomerField.createdDate: createdDate.toIso8601String(),
CustomerField.modifiedBy: modifiedBy,
CustomerField.modifiedDate: modifiedDate.toIso8601String(),




  };
}