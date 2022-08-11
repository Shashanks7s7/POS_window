import 'package:flutter/cupertino.dart';

class PayAdd {
  final int paymentid;
  final String title;
  final double amount;
  PayAdd({required this.paymentid, required this.title, required this.amount});
}

class PayA with ChangeNotifier {
  Map<String, PayAdd> _items = {};
  Map<String, PayAdd> get items {
    return {..._items};
  }

  double total = 0.000;
  String? payamt;

  String get ramain {
    late double remaning;
    double sum = 0.000;
    _items.forEach((key, value) {
      sum += value.amount;
    });
    remaning = total - sum;
    payamt = remaning.toStringAsFixed(2);

    return remaning.toStringAsFixed(2);
  }

  additems(
    int paymodeid,
    String title,
    double amount,
  ) {
    if (_items.containsKey(title)) {
      return false;
    } else {
      _items.putIfAbsent(title,
          () => PayAdd(paymentid: paymodeid, title: title, amount: amount));
    }
    notifyListeners();
  }

  void removeItem(String title) {
    _items.remove(title);
    notifyListeners();
  }

  void clear() {
    _items = {};

    notifyListeners();
  }
}
