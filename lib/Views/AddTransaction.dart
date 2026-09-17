import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maney_management_new/Controllers/CategoryController.dart';
import 'package:maney_management_new/Controllers/TransactionsController.dart';
import 'package:maney_management_new/Controllers/WalletController.dart';
import 'package:maney_management_new/Database/DatabaseHelper.dart';
import 'package:maney_management_new/Modles/Transactions.dart';
import 'package:maney_management_new/Utils/ThousandsSeparator.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  TextEditingController amount = TextEditingController();
  TextEditingController note = TextEditingController();
  final TransactionsController transactionsController = Get.find();
  final WalletController walletController = Get.find();
  final CategoryController categoryController = Get.find();
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  int? selectedWalletID;
  int? selectedCategoryID;
  String transactionType = 'expense';
  String? categoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("اضافة عملية جديده"), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTypeButton("مصروف", 'expense', Colors.red),
                SizedBox(width: 20),
                buildTypeButton("دخل", 'income', Colors.green),
              ],
            ),
            SizedBox(height: 25),
            TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandsSeparatorInputFormatter(),
              ],
              decoration: InputDecoration(
                labelText: "المبلغ",
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 20),
            GetX<CategoryController>(
              builder: (categoryController) {
                return DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: "اختر التصنيف",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  items: categoryController.category.map((f) {
                    return DropdownMenuItem(
                      value: f.id,
                      onTap: () {
                        categoryName = f.name;
                      },
                      child: Row(
                        children: [
                          Icon(f.iconData, color: Colors.blueGrey),
                          SizedBox(width: 10),
                          Text(f.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => selectedCategoryID = val);
                  },
                );
              },
            ),
            SizedBox(height: 20),
            GetX<WalletController>(
              builder: (walletController) {
                return DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: "اختر المحفظة",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  items: walletController.wallets.map((f) {
                    return DropdownMenuItem(value: f.id, child: Text(f.name));
                  }).toList(),
                  onChanged: (val) {
                    setState(() => selectedWalletID = val);
                  },
                );
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: note,
              decoration: InputDecoration(
                labelText: "ملاحظة (اختياري)",
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () async {
                String cleanAmount = amount.text.replaceAll(',', '').trim();
                double? newAmount = double.tryParse(cleanAmount);
                if (validateData()) {
                  if (transactionType == 'expense' &&
                      transactionsController.verificationBalance(
                        selectedWalletID!,
                        newAmount!,
                      )) {
                    Get.snackbar(
                      "تحذير",
                      "المبلغ المطلوب اكبر من المتوفر لديك",
                      backgroundColor: Colors.red[100],
                    );
                    return;
                  }
                  Transactions newTrans = Transactions(
                    amount: newAmount!,
                    note: note.text,
                    date: DateTime.now(),
                    type: transactionType,
                    categoryId: selectedCategoryID!,
                    walletId: selectedWalletID!,
                    categoryName: categoryName,
                  );
                  await transactionsController.addTransaction(newTrans);
                  transactionsController.updateExpenseTotal();
                  transactionsController.updateIncomeTotal();
                  walletController.updateWalletBalance(
                    selectedWalletID!,
                    newAmount,
                    transactionType,
                  );
                  Get.back();
                  if (transactionType == 'income') {
                    Get.snackbar(
                      "نجاح",
                      "تمت العملية واضافة المبلغ الى المحفظة",
                    );
                    Get.back();
                  } else {
                    Get.snackbar("نجاح", "تمت العملية وخصم المبلغ من المحفظ");
                  }
                }
              },
              child: Text(
                "حفظ العملية",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTypeButton(String title, String type, Color color) {
    bool isSelected = transactionType == type;
    return GestureDetector(
      onTap: () {
        setState(() => transactionType = type);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          title,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  bool validateData() {
    if (amount.text.isEmpty ||
        selectedWalletID == null ||
        selectedCategoryID == null) {
      Get.snackbar("تنبية", "يرجى اكمال كافة البيانات");
      return false;
    }
    return true;
  }
}
