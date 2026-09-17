import 'package:get/get.dart';
import 'package:maney_management_new/Controllers/CategoryController.dart';
import 'package:maney_management_new/Controllers/TransactionsController.dart';
import 'package:maney_management_new/Controllers/WalletController.dart';

class MyBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(WalletController() , permanent: true);
    Get.put(CategoryController() , permanent: true);
    Get.put(TransactionsController() ,permanent: true);
  }
}