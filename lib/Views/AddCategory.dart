import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:maney_management_new/Controllers/CategoryController.dart';
import 'package:maney_management_new/Modles/Categories.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final CategoryController categoryController = Get.find();
  TextEditingController name = TextEditingController();
  String selectIconKey = 'food';
  final Map<String, IconData> allIcons = {
    // طعام وشراب
    'food': Icons.fastfood,
    'coffee': Icons.coffee,
    'restaurant': Icons.restaurant,
    'grocery': Icons.local_grocery_store,

    // سكن وفواتير
    'home': Icons.home,
    'bills': Icons.receipt_long,
    'water': Icons.water_drop,
    'electricity': Icons.electric_bolt,
    'wifi': Icons.wifi,
    'phone': Icons.phone_android,

    // نقل ومواصلات
    'transport': Icons.directions_car,
    'bus': Icons.directions_bus,
    'fuel': Icons.local_gas_station,
    'repair': Icons.build,
    'travel': Icons.flight,

    // صحة وعناية
    'health': Icons.medical_services,
    'pharmacy': Icons.local_pharmacy,
    'gym': Icons.fitness_center,
    'spa': Icons.spa,

    // تسوق وترفيه
    'shopping': Icons.shopping_bag,
    'gift': Icons.card_giftcard,
    'fun': Icons.sports_esports,
    'movie': Icons.movie,
    'pets': Icons.pets,

    // عمل وتعليم
    'work': Icons.work,
    'education': Icons.school,
    'laptop': Icons.laptop_mac,
    'book': Icons.menu_book,

    // مال واستثمار
    'savings': Icons.savings,
    'bank': Icons.account_balance,
    'money': Icons.payments,
    'investment': Icons.trending_up,
    'debt': Icons.money_off,

    // أخرى
    'charity': Icons.volunteer_activism,
    'family': Icons.family_restroom,
    'celebration': Icons.celebration,
    'security': Icons.security,
    'cleaning': Icons.cleaning_services,
    'laundry': Icons.local_laundry_service,
    'other': Icons.category,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ادارة التصنيفات"), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    TextField(
                      controller: name,
                      decoration: InputDecoration(
                        labelText: "اسم التصنيف الجديد",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    ListTile(
                      onTap: () {
                        showIconPicker();
                      },
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: Text("ايقونة التصنيف"),
                      trailing: CircleAvatar(
                        backgroundColor: Colors.grey[50],
                        child: Icon(
                          allIcons[selectIconKey],
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        if (name.text.isNotEmpty) {
                          categoryController.addCategory(
                            name.text,
                            selectIconKey,
                          );
                          name.clear();
                        }else{
                          Get.snackbar('تنبية', "يرجى ادخال اسم التصنيف اولاً");
                        }
                      },
                      child: Text(
                        "حفظ التصنيف",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(),
          Text(
            "التصنيفات الحالية",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Expanded(
            child: GetX<CategoryController>(
              builder: (categoryController) {
                return ListView.builder(
                  itemCount: categoryController.category.length,
                  itemBuilder: (context, i) {
                    Categories cate = categoryController.category[i];
                    return ListTile(
                      title: Text(cate.name),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[50],
                        child: Icon(allIcons[cate.icon], color: Colors.orange),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          confirmDelete(cate);
                        },
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void confirmDelete(Categories cate) {
    Get.defaultDialog(
      title: "حذف",
      middleText: "هل تريد حذف  '${cate.name}' ؟",
      onConfirm: () {
        categoryController.deleteCategory(cate.id!);
        Get.back();
      },
      textCancel: "تراجع",
      textConfirm: "حذف",
    );
  }

  void showIconPicker() {
    Get.bottomSheet(
      Container(
        // height: 400,
        height: MediaQuery.of(context).size.height * 0.5,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey[300]),
            ),
            SizedBox(height: 15),
            Expanded(
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                ),
                itemCount: allIcons.keys.length,
                itemBuilder: (context, i) {
                  String key = allIcons.keys.elementAt(i);
                  IconData icon = allIcons[key]!;
                  bool isSelected = selectIconKey == key;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectIconKey = key);
                      Get.back();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue[100] : Colors.grey[50],
                        borderRadius: BorderRadius.circular(15),
                        border: BoxBorder.all(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(icon , color: isSelected ? Colors.blue[800] : Colors.grey[600],size: 28,),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
