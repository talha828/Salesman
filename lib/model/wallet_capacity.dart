import 'package:flutter/cupertino.dart';

class WalletCapacity extends ChangeNotifier {
  double capacity =0.001;
  double usedBalance=0.0001;
  double availableBalance=0.0001;

  WalletCapacity({this.capacity, this.usedBalance, this.availableBalance});

  setWalletCapacity(double capacityValue, double usedBalanceValue,
      double availableBalanceValue) {
    capacity = capacityValue;
    usedBalance = usedBalanceValue;
    availableBalance = availableBalanceValue;
    notifyListeners();
  }
}
