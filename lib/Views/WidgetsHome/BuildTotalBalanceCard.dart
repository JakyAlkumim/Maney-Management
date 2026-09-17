import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:intl/intl.dart';
import 'package:maney_management_new/Controllers/WalletController.dart';

class BuildTotalBalanceCard extends StatefulWidget {
  const BuildTotalBalanceCard({super.key});

  @override
  State<BuildTotalBalanceCard> createState() => _BuildTotalBalanceCardState();
}

class _BuildTotalBalanceCardState extends State<BuildTotalBalanceCard> {

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
    return GetX<WalletController>(builder: (walletController){
      return Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [Color(0xFF1e3c72), Color(0xFF2a5298)],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.blue.withOpacity(0.3),
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              "اجمالي الرصيد",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "${formatMoney(walletController.totalBalance)}ريال ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    });
  }
}
