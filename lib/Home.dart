import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:maney_management_new/Controllers/TransactionsController.dart';
import 'package:maney_management_new/Controllers/WalletController.dart';
import 'package:maney_management_new/Modles/Transactions.dart';
import 'package:maney_management_new/SettingScreen.dart';
import 'package:maney_management_new/Views/AddCategory.dart';
import 'package:maney_management_new/Views/AddTransaction.dart';
import 'package:maney_management_new/Views/AddWallet.dart';
import 'Views/WidgetsHome/BuildTotalBalanceCard.dart';
import 'Views/WidgetsHome/BuildWalletList.dart';
import 'Views/WidgetsHome/quickActionButton.dart';
import 'Views/WidgetsHome/sectionTitle.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WalletController walletController = Get.find();
  final TransactionsController transactionsController = Get.find();

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
      final formatter = NumberFormat("#,###.##", "ar");
      return formatter.format(value);
    } catch (e) {
      return "0.00"; // في حال حدوث أي خطأ غير متوقع
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "مصروفاتنا",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => SettingScreen());
            },
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          "اضافة عملية",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Get.to(() => AddTransaction());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            BuildTotalBalanceCard(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: quickActionButton(
                      label: "المحافظ",
                      icon: Icons.account_balance_wallet,
                      color: Colors.blue,
                      onTap: () => Get.to(() => AddWallet()),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: quickActionButton(
                      label: "التصنيفات",
                      icon: Icons.category,
                      color: Colors.orangeAccent,
                      onTap: () => Get.to(() => AddCategory()),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            sectionTitle(title: "محافظي"),
            BuildWalletList(),
            SizedBox(height: 10),
            sectionTitle(title: "اخر العمليات"),
            buildFilter(),
            buildRecentTransaction(),
          ],
        ),
      ),
    );
  }

  Widget buildFilter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          filterChip('الكل', 'all'),
          filterChip('اليوم', 'today'),
          filterChip('هذا الشهر', 'month'),
        ],
      ),
    );
  }

  Widget filterChip(String label, String filterValue) {
    bool isSelected = transactionsController.selectFilter.value == filterValue;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: isSelected ? Colors.blue : Colors.grey,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        checkmarkColor: isSelected ? Colors.white : Colors.transparent,
        onSelected: (val) {
          setState(() {
            transactionsController.changeFilter(filterValue);
          });
        },
      ),
    );
  }

  Widget buildRecentTransaction() {
    return GetX<TransactionsController>(
      builder: (tranController) {
        if (tranController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (tranController.trans1.isEmpty) {
          return Center(child: Text("لاتوجد عمليات بعد"));
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: tranController.filterTrans.length,
          itemBuilder: (context, i) {
            Transactions tx = tranController.filterTrans[i];
            return Dismissible(
              key: Key(tx.id.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.redAccent,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "حذف العملية",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.delete_sweep, color: Colors.white, size: 28),
                  ],
                ),
              ),
              onDismissed: (id) {
                tranController.deleteTransaction(tx);
                tranController.updateIncomeTotal();
                tranController.updateExpenseTotal();
                Get.snackbar(
                  "تم الحذف",
                  "تم مسح العملية وتحديث الرصيد",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red[50],
                );
              },
              child: Card(
                elevation: 1,
                margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tx.type == 'income'
                        ? Colors.green[50]
                        : Colors.red[50],
                    child: Icon(
                      tx.type == 'income'
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: tx.type == 'income' ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text("${tx.note.isEmpty ? tx.categoryName : tx.note}"),
                  subtitle: Text(tx.date.toString().split(' ')[0]),
                  trailing: Text(
                    "${tx.type == 'income' ? '+' : '-'}${formatMoney(tx.amount)}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: tx.type == 'income' ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
