import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:inventorymanagement/pages/historypage.dart';
import 'package:inventorymanagement/utils/dialogbox.dart';
import 'package:inventorymanagement/utils/mybuttons.dart';
import 'package:inventorymanagement/utils/producttile.dart';
import 'package:inventorymanagement/utils/statcard.dart';
import 'package:inventorymanagement/utils/stockdialog.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final productBox = Hive.box("products");
  final historyBox = Hive.box("history");

  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final quantityController = TextEditingController();
  final minStockController = TextEditingController();
  final priceController = TextEditingController();

  final stockController = TextEditingController();
  final searchController = TextEditingController();

  final productFormKey = GlobalKey<FormState>();
  final stockFormKey = GlobalKey<FormState>();

  String searchText = "";
  String selectedFilter = "All";

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    quantityController.dispose();
    minStockController.dispose();
    priceController.dispose();
    stockController.dispose();
    searchController.dispose();
    super.dispose();
  }

  // ---------- gagmay na helpers ----------

  void showMessage(String text, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: TextStyle(color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void clearProductControllers() {
    nameController.clear();
    categoryController.clear();
    quantityController.clear();
    minStockController.clear();
    priceController.clear();
  }

  // ---------- ADD product ----------

  void addNewProduct() {
    clearProductControllers();
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          title: "Add Product",
          formKey: productFormKey,
          nameController: nameController,
          categoryController: categoryController,
          quantityController: quantityController,
          minStockController: minStockController,
          priceController: priceController,
          quantityEnabled: true,
          onSave: saveNewProduct,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  Future<void> saveNewProduct() async {
    // stop if field error
    if (!productFormKey.currentState!.validate()) {
      return;
    }

    await productBox.add({
      "name": nameController.text.trim(),
      "category": categoryController.text.trim(),
      "quantity": int.parse(quantityController.text.trim()),
      "minStock": int.parse(minStockController.text.trim()),
      "price": double.parse(priceController.text.trim()),
    });

    if (!mounted) return;
    Navigator.of(context).pop();
    setState(() {});
    showMessage("Product added");
  }

  // ---------- EDIT product ----------

  void editProduct(dynamic key) {
    final product = productBox.get(key);

    // fill the text fields with the saved values
    nameController.text = "${product['name']}";
    categoryController.text = "${product['category']}";
    quantityController.text = "${product['quantity']}";
    minStockController.text = "${product['minStock']}";
    priceController.text = "${product['price']}";

    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          title: "Edit Product",
          formKey: productFormKey,
          nameController: nameController,
          categoryController: categoryController,
          quantityController: quantityController,
          minStockController: minStockController,
          priceController: priceController,
          quantityEnabled: false, // quantity only changes with Stock In / Out
          onSave: () => saveEditedProduct(key),
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  Future<void> saveEditedProduct(dynamic key) async {
    if (!productFormKey.currentState!.validate()) {
      return;
    }

    final oldProduct = productBox.get(key);

    await productBox.put(key, {
      "name": nameController.text.trim(),
      "category": categoryController.text.trim(),
      "quantity": oldProduct["quantity"], // keep the current stock
      "minStock": int.parse(minStockController.text.trim()),
      "price": double.parse(priceController.text.trim()),
    });

    if (!mounted) return;
    Navigator.of(context).pop();
    setState(() {});
    showMessage("Product updated");
  }

  // ---------- DELETE product ----------

  void confirmDelete(dynamic key, String name) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.yellow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Delete product?", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Are you sure you want to delete \"$name\"? This cannot be undone."),
          actions: [
            MyButtons(
              text: "Delete",
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () => deleteProduct(key, name),
            ),
            MyButtons(text: "Cancel", onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  Future<void> deleteProduct(dynamic key, String name) async {
    await productBox.delete(key);

    if (!mounted) return;
    Navigator.of(context).pop();
    setState(() {});
    showMessage("\"$name\" deleted");
  }

  // ---------- STOCK IN / OUT ----------
  // type is "in" (adding stock) or "out" (removing stock)

  void openStockDialog(dynamic key, String type) {
    final product = productBox.get(key);
    stockController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return StockDialog(
          formKey: stockFormKey,
          controller: stockController,
          productName: "${product['name']}",
          currentQuantity: product["quantity"],
          type: type,
          onSave: () => saveStock(key, type),
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  Future<void> saveStock(dynamic key, String type) async {
    if (!stockFormKey.currentState!.validate()) {
      return;
    }

    final amount = int.parse(stockController.text.trim());
    final product = Map.from(productBox.get(key)); // a copy we can change

    if (type == "in") {
      product["quantity"] = product["quantity"] + amount;
    } else {
      product["quantity"] = product["quantity"] - amount;
    }

    await productBox.put(key, product);

    // save a record so it shows in the History page
    await historyBox.add({
      "productName": product["name"],
      "type": type,
      "quantity": amount,
      "date": DateTime.now().toIso8601String(),
    });

    if (!mounted) return;
    Navigator.of(context).pop();
    setState(() {});

    bool isLow = product["quantity"] <= product["minStock"];
    if (isLow) {
      showMessage("Saved. \"${product['name']}\" is low on stock!", color: Colors.orange.shade800);
    } else {
      showMessage("Stock updated");
    }
  }

  // ---------- LOW STOCK warning (bell icon) ----------

  void showLowStockWarning() {
    final lowItems = productBox.values.where((p) => p["quantity"] <= p["minStock"]).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.yellow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange.shade900),
              SizedBox(width: 8),
              Text("Low stock", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: lowItems.isEmpty
              ? Text("All products are well stocked.")
              : SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final p in lowItems)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text("${p['name']}", style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Left: ${p['quantity']}  (minimum ${p['minStock']})"),
                        ),
                    ],
                  ),
                ),
          actions: [
            MyButtons(text: "Close", onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    );
  }

  // ---------- parts of the screen ----------

  Widget buildHeader(int totalProducts, int totalUnits, int lowCount) {
    final filters = ["All", "Low stock", "Out of stock"];

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // dashboard cards
          Row(
            children: [
              Expanded(
                child: StatCard(
                  label: "Products",
                  value: "$totalProducts",
                  icon: Icons.inventory_2,
                  color: Colors.yellow,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  label: "Total units",
                  value: "$totalUnits",
                  icon: Icons.layers,
                  color: Colors.amber.shade200,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: StatCard(
                  label: "Low stock",
                  value: "$lowCount",
                  icon: Icons.warning_amber_rounded,
                  color: lowCount > 0 ? Colors.orange.shade300 : Colors.green.shade200,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // search bar
          TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Search name or category",
              prefixIcon: Icon(Icons.search),
              suffixIcon: searchText.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          searchText = "";
                        });
                      },
                    ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 12),

          // filter chips
          Wrap(
            spacing: 8,
            children: [
              for (final label in filters)
                ChoiceChip(
                  label: Text(label),
                  selected: selectedFilter == label,
                  showCheckmark: false,
                  selectedColor: Colors.yellow,
                  backgroundColor: Colors.white,
                  onSelected: (value) {
                    setState(() {
                      selectedFilter = label;
                    });
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildEmptyState() {
    return Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 70, color: Colors.black38),
          SizedBox(height: 12),
          Text(
            productBox.isEmpty
                ? "No products yet.\nTap \"Add Product\" to get started."
                : "No products match your search.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // read every saved product (key + data)
    final entries = productBox.toMap().entries.toList();

    // dashboard numbers
    int totalUnits = 0;
    int lowCount = 0;
    for (final e in entries) {
      totalUnits += e.value["quantity"] as int;
      if (e.value["quantity"] <= e.value["minStock"]) {
        lowCount++;
      }
    }

    // apply search + filter
    final items = entries.where((e) {
      final p = e.value;
      final text = "${p['name']} ${p['category']}".toLowerCase();
      bool matchesFilter = true;
      if (selectedFilter == "Low stock") {
        matchesFilter = p["quantity"] <= p["minStock"];
      } else if (selectedFilter == "Out of stock") {
        matchesFilter = p["quantity"] == 0;
      }
      return text.contains(searchText.toLowerCase().trim()) && matchesFilter;
    }).toList();

    // A to Z by name
    items.sort((a, b) => a.value["name"]
        .toString()
        .toLowerCase()
        .compareTo(b.value["name"].toString().toLowerCase()));

    return Scaffold(
      appBar: AppBar(
        title: Text("Inventory"),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Stock history",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HistoryPage()),
              );
            },
            icon: Icon(Icons.history),
          ),
          IconButton(
            tooltip: "Low stock warnings",
            onPressed: showLowStockWarning,
            icon: Badge(
              isLabelVisible: lowCount > 0,
              label: Text("$lowCount"),
              child: Icon(Icons.notifications),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: addNewProduct,
        icon: Icon(Icons.add),
        label: Text("Add Product"),
      ),

      body: ListView.builder(
        padding: EdgeInsets.only(bottom: 90),
        // +1 because the first row is the header (cards, search, chips)
        itemCount: items.isEmpty ? 2 : items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return buildHeader(entries.length, totalUnits, lowCount);
          }
          if (items.isEmpty) {
            return buildEmptyState();
          }

          final key = items[index - 1].key;
          final p = items[index - 1].value;

          return ProductTile(
            name: "${p['name']}",
            category: "${p['category']}",
            quantity: p["quantity"],
            minStock: p["minStock"],
            price: (p["price"] as num).toDouble(),
            onStockIn: () => openStockDialog(key, "in"),
            onStockOut: () => openStockDialog(key, "out"),
            onEdit: () => editProduct(key),
            onDelete: () => confirmDelete(key, "${p['name']}"),
          );
        },
      ),
    );
  }
}
