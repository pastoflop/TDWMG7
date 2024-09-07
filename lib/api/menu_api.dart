import '../models/producto.dart';
import '../db/database_helper.dart';

class MenuApi {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Producto>> fetchMenu() async {
    return await _dbHelper.getProductos();
  }

  Future<void> addProducto(Producto producto) async {
    await _dbHelper.insertProducto(producto);
  }

  Future<void> editProducto(Producto producto) async {
    await _dbHelper.updateProducto(producto);
  }

  Future<void> deleteProducto(int id) async {
    await _dbHelper.deleteProducto(id);
  }
}
