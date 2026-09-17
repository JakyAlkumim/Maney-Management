import 'package:get/get.dart';
import 'package:maney_management_new/Database/DatabaseHelper.dart';
import 'package:maney_management_new/Modles/Categories.dart';

class CategoryController extends GetxController {
  @override
  void onInit() {
    loadCategory();
    super.onInit();
  }

  DataBaseHelper dataBaseHelper = DataBaseHelper();

  RxList<Categories> category = <Categories>[].obs;
  RxBool isLoading = true.obs;

  Future<void> loadCategory() async {
    try {
      isLoading.value = true;
      List<Categories> data = await dataBaseHelper.getAllCategory();
      if(data.isEmpty){
        await insertDefaultCategories();
        data = await dataBaseHelper.getAllCategory();
      }
      category.assignAll(data);
    } catch (e) {
      print("Error in Category");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> insertDefaultCategories() async {
    List<Categories> defaultCats = [
      Categories(name: "طعام", icon: "food"),
      Categories(name: "تسوق", icon: "shopping"),
      Categories(name: "فواتير", icon: "bills"),
      Categories(name: "صحة", icon: "health"),
      Categories(name: "نقل", icon: "transport"),
    ];
    for (var cat in defaultCats) {
      await dataBaseHelper.insertCategory(cat);
    }
  }

  Future<void> addCategory(String name, String icon) async {
    Categories newCategory = Categories(name: name, icon: icon);
    await dataBaseHelper.insertCategory(newCategory);
    await loadCategory();
  }

  Future<void> deleteCategory(int id) async {
    await dataBaseHelper.deleteCategory(id);
    loadCategory();
  }
}
