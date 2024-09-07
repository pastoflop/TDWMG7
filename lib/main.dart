import 'package:flutter/material.dart';
import 'models/producto.dart';
import 'api/menu_api.dart';
import 'pages/add_producto_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurante Menu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuPage(),
    );
  }
}

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuApi _menuApi = MenuApi();
  late Future<List<Producto>> _menu;

  @override
  void initState() {
    super.initState();
    _menu = _menuApi.fetchMenu();
  }

  Future<void> mostrarDialogoEdicion(BuildContext context, Producto producto) async {
    final _formKey = GlobalKey<FormState>();
    String _nombreProducto = producto.nombreProducto;
    double _valor = producto.valor;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Producto'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: _nombreProducto,
                  decoration: InputDecoration(labelText: 'Nombre del Producto'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un nombre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nombreProducto = value!;
                  },
                ),
                TextFormField(
                  initialValue: _valor.toString(),
                  decoration: InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese un valor';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _valor = double.parse(value!);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Guardar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  
                  Producto updatedProducto = Producto(
                    id: producto.id,
                    nombreProducto: _nombreProducto,
                    valor: _valor,
                    disponibilidad: producto.disponibilidad,
                  );

                  _menuApi.editProducto(updatedProducto).then((_) {
                    setState(() {
                      _menu = _menuApi.fetchMenu();
                    });
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú de Restaurante'),
      ),
      body: FutureBuilder<List<Producto>>(
        future: _menu,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No hay productos en el menú');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final producto = snapshot.data![index];
                return ListTile(
                  title: Text(producto.nombreProducto),
                  subtitle: Text('Valor: \$${producto.valor.toString()}'),
                  trailing: Switch(
                    value: producto.disponibilidad,
                    onChanged: (bool newValue) {
                      setState(() {
                        producto.disponibilidad = newValue;
                        _menuApi.editProducto(producto);
                      });
                    },
                  ),
                  onTap: () {
                    mostrarDialogoEdicion(context, producto);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductoPage()),
          ).then((_) {
            setState(() {
              _menu = _menuApi.fetchMenu();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
