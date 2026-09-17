import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:intl/intl.dart';
import 'package:maney_management_new/Controllers/WalletController.dart';
import 'package:maney_management_new/Utils/ThousandsSeparator.dart';

class AddWallet extends StatefulWidget {
  const AddWallet({super.key});

  @override
  State<AddWallet> createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  TextEditingController name = TextEditingController();
  TextEditingController balance = TextEditingController();
  TextEditingController currency = TextEditingController();
  final WalletController walletController = Get.find();

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
    return Scaffold(
      appBar: AppBar(title: Text("إنشاء محفظة جديدة"), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Icon(
                Icons.account_balance_wallet,
                color: Colors.blue,
                size: 80,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: name,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.edit),
                labelText: "اسم المحفظة",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
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
                prefixIcon: Icon(Icons.money),
                labelText: "الرصيد الحالي",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (name.text.isNotEmpty && balance.text.isNotEmpty) {
                  await walletController.addWallet(
                    name.text,
                    double.parse(balance.text.replaceAll(',', '')),
                    currency.text,
                  );
                  Get.back();
                  Get.snackbar("تم الحفظ", "تمت اضافة المحفظة");
                }else{
                  Get.snackbar("تنبية", "يرجى تعبئة البيانات");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                "حفظ البيانات",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
