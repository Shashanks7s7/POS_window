class QrData {
  int? customerID;
  String? name;

  QrData(jsonDecode, {this.customerID, this.name});

  QrData.fromJson(Map<String, dynamic> json) {
    customerID = json['CustomerID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustomerID'] = this.customerID;
    data['Name'] = this.name;
    return data;
  }
} 