import 'package:get/get.dart';
import 'package:maney_management_new/Controllers/WalletController.dart';
import 'package:maney_management_new/Database/DatabaseHelper.dart';
import 'package:maney_management_new/Modles/Transactions.dart';
import 'package:maney_management_new/Modles/Wallet.dart';

class TransactionsController extends GetxController {
  RxList<Transactions> trans1 = <Transactions>[].obs;
  RxBool isLoading = true.obs;
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  final WalletController walletController = Get.find();

  @override
  void onInit() {
    loadTransaction();
    updateExpenseTotal();
    updateIncomeTotal();
    super.onInit();
  }

  Future<void> loadTransaction() async {
    try {
      isLoading.value = true;
      List<Transactions> data = await dataBaseHelper.getAllTransaction();
      trans1.assignAll(data);
    } catch (e) {
      print("Error in Transaction ===========");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTransaction(Transactions newTrans) async {
    await dataBaseHelper.insertTransaction(newTrans);
    loadTransaction();
  }

  Future<void> deleteTransaction(Transactions trans) async {
    try {
      await dataBaseHelper.deleteTransaction(trans.id!);
      trans1.removeWhere((w) => w.id == trans.id);
      trans1.refresh();
      String reverseType = (trans.type == 'expense') ? 'income' : 'expense';
      walletController.updateWalletBalance(
        trans.walletId,
        trans.amount,
        reverseType,
      );
      Get.snackbar("تنبية", "تم حذف العملية وتعديل رصيد المحفظة");
    } catch (e) {
      print("خطاء في الحذف  $e");
    }
  }

  RxDouble totalExpense = 0.0.obs;
  RxDouble totalIncome = 0.0.obs;
  RxDouble total = 0.0.obs;

  void updateExpenseTotal() async {
    double result = await dataBaseHelper.getTotalExpenses();
    totalExpense.value = result;
  }

  void updateIncomeTotal() async {
    double result = await dataBaseHelper.getTotalIncome();
    totalIncome.value = result;
  }

  bool verificationBalance(int walletID, double amount) {
    Wallet wallet = walletController.wallets.firstWhere(
      (w) => w.id == walletID,
    );
    if (wallet.balance > amount) {
      return false;
    }
    return true;
  }

  RxString selectFilter = 'all'.obs;

  void changeFilter(String filter) {
    selectFilter.value = filter;
    trans1.refresh();
  }

  List<Transactions> get filterTrans {
    DateTime now = DateTime.now();
    if (selectFilter.value == 'today') {
      return trans1
          .where(
            (tx) =>
                tx.date.day == now.day &&
                tx.date.month == now.month &&
                tx.date.year == now.year,
          )
          .toList();
    } else if (selectFilter.value == 'month') {
      return trans1
          .where((tx) => tx.date.month == now.month && tx.date.year == now.year)
          .toList();
    }
    return trans1;
  }
}
