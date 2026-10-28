import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/shop_service.dart';
import '../utils/empty_state.dart';
import '../utils/format.dart';
import '../utils/messages.dart';
import '../utils/mybuttons.dart';
import '../utils/product_art.dart';
import '../utils/product_dialog.dart';

/// Add, edit, and delete the products 
class ManageProductsPage extends StatefulWidget {
  const ManageProductsPage({super.key});

  @override
  State<ManageProductsPage> createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _products = ShopService.getProducts();
  }

  void _refresh() {
    setState(() => _products = ShopService.getProducts());
  }

  void _openDialog({Product? product}) {
    final isNew = product == null;
    showDialog(
      context: context,
      builder: (context) => ProductDialog(
        product: product,
        onSave: (saved) async {
          await ShopService.saveProduct(saved);
          if (!mounted) return;
          _refresh();
          showMessage(this.context, isNew ? 'Product added' : 'Product updated');
        },
      ),
    );
  }

  Future<void> _confirmDelete(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete product?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          '"${product.name}" will be removed from the shop, your cart, and '
          'your favorites. Past orders are not affected.',
        ),
        actions: [
          MyButtons(
            text: 'Cancel',
            onPressed: () => Navigator.of(context).pop(false),
          ),
          MyButtons(
            text: 'Delete',
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await ShopService.deleteProduct(product.id);
    if (!mounted) return;
    _refresh();
    showMessage(context, 'Product deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Products')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openDialog(),
        child: Icon(Icons.add),
      ),
      body: _products.isEmpty
          ? EmptyState(
              icon: Icons.inventory_2_outlined,
              message: 'No products yet.\nTap the + button to add one.',
            )
          : ListView.builder(
              padding: EdgeInsets.only(top: 8, bottom: 80),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1F000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: ProductArt(
                          category: product.category,
                          iconSize: 24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                       SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:  TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${product.category}  •  ${formatMoney(product.price)}',
                              style:  TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _openDialog(product: product),
                        icon:  Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        onPressed: () => _confirmDelete(product),
                        icon:  Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
