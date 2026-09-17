import 'package:get/state_manager.dart';
import 'package:maney_management_new/Database/DatabaseHelper.dart';
import 'package:maney_management_new/Modles/Wallet.dart';

class WalletController extends GetxController {
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  RxList<Wallet> wallets = <Wallet>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    loadWallet();
    super.onInit();
  }

  Future<void> loadWallet() async {
    try {
      isLoading.value = true;
      List<Wallet> data = await dataBaseHelper.getAllWallet();
      wallets.assignAll(data);
    } catch (e) {
      print("Error Loading Wallets.....$e");
    } finally {
      isLoading.value = false;
    }
  }

  Future addWallet(String name, double balance, String currency) async {
    Wallet newWallet = Wallet(name: name, balance: balance, currency: currency);
    await dataBaseHelper.insertWallet(newWallet);
    loadWallet();
  }

  Future<void> deleteWallet(int id) async {
    await dataBaseHelper.deleteWallet(id);
    loadWallet();
  }

  //  حساب إجمالي الرصيد في كل المحافظ (مفيد جداً للواجهة الرئيسية)
  double get totalBalance {
    return wallets.fold(0, (sum, item) => sum + item.balance);
  }

  Future<void> updateWalletBalance(
    int walletId,
    double amount,
    String type,
  ) async {
    try {
      int index = wallets.indexWhere((w) => w.id == walletId);
      if (index != -1) {
        Wallet wallet = wallets[index];
        if (type == 'income') {
          wallet.balance += amount;
        } else {
          wallet.balance -= amount;
        }
        wallets[index] = wallet;
        wallets.refresh();
        await dataBaseHelper.updateWallet(wallet);
        print("تم تحديث الرصيد في قاعدة البيانات");
      }
    } catch (e) {
      print("خطاء اثناء تحديث العملية $e");
    }
  }
}
