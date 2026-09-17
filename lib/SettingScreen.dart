import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:maney_management_new/Views/AddCategory.dart';
import 'package:maney_management_new/Views/Reports/Report.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool ss = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "اعدادات التطبيق",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,

        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          const Text(
            "العرض والتقارير",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 10),
          buildSettingItems(
            icon: Icons.pie_chart_rounded,
            color: Colors.redAccent,
            title: "تقارير المصاريف",
            subtitle: "عرض الرسوم البيانية وتحليل البيانات",
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.to(() => Report()),
          ),
          SizedBox(height: 20),
          const Text(
            "ادارة البيانات",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 10),
          buildSettingItems(
            icon: Icons.category_rounded,
            color: Colors.orangeAccent,
            title: "ادارة التصنيفات",
            subtitle: "اضافة او حذف تصنيفات العملية",
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.to(() => AddCategory()),
          ),
          SizedBox(height: 10),
          buildSettingItems(
            icon: Icons.monetization_on_rounded,
            color: Colors.amber,
            title: "العملة",
            subtitle: "الريال اليمني",
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.snackbar(
              "قريباً",
              "ميزة تغيير العملة ستتوفر في التحديث القادم",
            ),
          ),
          SizedBox(height: 10),
          buildSettingItems(
            icon: Icons.security,
            color: Colors.green,
            title: "قفل التطبيق (PIN)",
            subtitle: "غير مفعل",
            trailing: Switch(
              value: ss,
              onChanged: (bool val) {
                if (val) {
                  return;
                } else {
                  return;
                }
              },
            ),
          ),
          //Directionality(textDirection: textDirection, child: child)
          SizedBox(height: 10),
          buildSettingItems(
            icon: Icons.language_outlined,
            color: Colors.blueAccent,
            title: "اللغات",
            subtitle: "اختيار اللغة المفضلة",
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => Get.snackbar(
              "قريباً",
              "ستتوفر ميزة اختيار اللغة في التحديث القادم",
            ),
          ),     
        ],
      ),
    );
  }

  Widget buildSettingItems({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required Widget trailing,
    void Function()? onTap,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        color: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.blueGrey.withAlpha(40),
            child: Icon(icon, color: color),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}
