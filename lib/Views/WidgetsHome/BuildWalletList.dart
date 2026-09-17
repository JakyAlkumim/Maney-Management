import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maney_management_new/Controllers/TransactionsController.dart';
import 'package:maney_management_new/Controllers/WalletController.dart';
import 'package:maney_management_new/Database/DatabaseHelper.dart';
import 'package:maney_management_new/Modles/Wallet.dart';
import 'package:maney_management_new/Utils/ThousandsSeparator.dart';

class BuildWalletList extends StatefulWidget {
  const BuildWalletList({super.key});

  @override
  State<BuildWalletList> createState() => _BuildWalletListState();
}

class _BuildWalletListState extends State<BuildWalletList> {
  final WalletController walletController = Get.find();
  final TransactionsController transactionsController = Get.find();
  DataBaseHelper dataBaseHelper = DataBaseHelper();

  String formatMoney(dynamic amount) {
    try {
      double value = 0.0;

      // إذا كان القادم نصاً، نحوله لرقم
      if (amount is String) {
        // نزيل الفواصل إذا وجدت ثم نحول
        value = double.tryParse(amount.replaceAll(',', '')) ?? 0.0;
      } else if (amount is double) {
        value = amount;
      } else if (amount is int) {
        value = amount.toDouble();
      }

      // التنسيق الآن باستخدام الرقم المؤكد (value)
      final formatter = NumberFormat("#,###.##", "en_US");
      return formatter.format(value);
    } catch (e) {
      return "0.00"; // في حال حدوث أي خطأ غير متوقع
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetX<WalletController>(
      builder: (walletController) {
        if (walletController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if(walletController.wallets.isEmpty){
          return Center(child: Text("لاتوجد اي محفظة"),);
        }
        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 15),
            itemCount: walletController.wallets.length,
            itemBuilder: (context, i) {
              final wallet = walletController.wallets[i];
              return InkWell(
                onLongPress: () {
                  showEditWallet(context, wallet);
                },
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.only(left: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(15),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.blue.shade400],
                      ),
                    ),
                    child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              wallet.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.edit, color: Colors.white, size: 16),
                          ],
                        ),
                        Spacer(),
                        Text(
                          formatMoney(wallet.balance),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showEditWallet(BuildContext context, Wallet wallet) async {
    final String formatBalance = formatMoney(wallet.balance);
    TextEditingController name = TextEditingController(text: wallet.name);
    TextEditingController balance = TextEditingController(text: formatBalance);

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "تعديل المحفظة",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      confirmDelete(wallet);
                    },
                    icon: Icon(Icons.delete_forever_rounded, color: Colors.red),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "اسم الحفظة",
                  prefixIcon: Icon(Icons.account_balance_wallet),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: balance,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  ThousandsSeparatorInputFormatter(),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "الرصيد الحالي",
                  suffixText: "ريال",
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () async {
                  String cleanAmount = balance.text.replaceAll(',', '');
                  double newBalance = double.parse(cleanAmount);

                  wallet.name = name.text;
                  wallet.balance = newBalance;

                  await dataBaseHelper.updateWallet(wallet);
                  walletController.wallets.refresh();
                  Get.back();
                  Get.snackbar(
                    "نجاح",
                    "تم تعديل بيانات المحفظة بنجاح",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.shade50,
                  );
                },
                child: Text(
                  "حفظ التعديلات",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  void confirmDelete(Wallet wallet) async {
    Get.defaultDialog(
      title: "حذف",
      middleText:
          "سيتم حذف المحفظة '${wallet.name}' وكافة العمليات المرتبطة بها نهائياً!",
      textConfirm: "نعم؛ احذف",
      textCancel: "تراجع",
      buttonColor: Colors.red,
      onConfirm: () async {
        try {
          await dataBaseHelper.deleteWallet(wallet.id!);
          walletController.wallets.removeWhere((w) => w.id == wallet.id);
          transactionsController.trans1.removeWhere(
            (t) => t.walletId == wallet.id,
          );
          walletController.wallets.refresh();
          transactionsController.trans1.refresh();
          Get.back();
          Get.back();
          Get.snackbar(
            "تم الحذف",
            "تم حذف المحفظة بنجاح",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[100],
          );
        } catch (e) {
          print("خطاء في الحذف $e");
          Get.snackbar("خطاء", "حدث خطاء اثنا محاولة الحذف");
        }
      },
    );
  }
}
