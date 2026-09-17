import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:intl/intl.dart';
import 'package:maney_management_new/Controllers/TransactionsController.dart';
import 'package:maney_management_new/Controllers/WalletController.dart';
import 'package:maney_management_new/Modles/Wallet.dart';
import 'package:fl_chart/fl_chart.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final TransactionsController transactionsController = Get.find();
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
      appBar: AppBar(title: Text("التحليل المالي الدقيق"), centerTitle: true),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "ملخص الرصيد الإجمالي (General Summary)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            buildReportBalance(),
            SizedBox(height: 10),
            Text(
              "المحافظ (Wallets Report)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            buildReportWallet(),
            SizedBox(height: 10),
            Text(
              "المخطط البياني لحساب الدخل والخرج",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            buildPieChart(
              transactionsController.totalExpense.value,
              transactionsController.totalIncome.value,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReportBalance() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[900]!, Colors.blue[700]!],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text("اجمالي الدخل", style: TextStyle(color: Colors.white70)),
          SizedBox(height: 10),
          Text(
            formatMoney(transactionsController.totalIncome.value),
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
          SizedBox(height: 10),
          Text("اجمالي المصروفات", style: TextStyle(color: Colors.white70)),
          Text(
            formatMoney(transactionsController.totalExpense.value),
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
          Text("صافي الرصيد الحالي", style: TextStyle(color: Colors.white70)),
          Text(
            formatMoney(walletController.totalBalance),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReportWallet() {
    return GetX<WalletController>(
      builder: (controllerWallet) {
        if(controllerWallet.wallets.isEmpty){
          return Center(child: Text("لاتوجد اي محفظه بعد"),);
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: controllerWallet.wallets.length,
          itemBuilder: (context, i) {
            Wallet wallet = controllerWallet.wallets[i];
            return Card(
              child: ListTile(
                title: Text(
                  "اسم المحفظة",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  wallet.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                trailing: Text(
                  "${formatMoney(wallet.balance)}\$",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildPieChart(double income, double expense) {

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: [
            // قسم الدخل
            PieChartSectionData(
              value: income,
              title: income >= 0 ? 'الدخل' : ' ',
              color: Colors.green,
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            // قسم المصاريف
            PieChartSectionData(
              value: expense,
              title: expense >= 0 ? 'المصاريف' : '',
              color: Colors.red,
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
          // إعدادات التفاعل (اختياري)
          pieTouchData: PieTouchData(enabled: true),
        ),
      ),
    );
  }
}
