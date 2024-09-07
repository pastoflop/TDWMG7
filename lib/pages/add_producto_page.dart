import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../api/menu_api.dart';

class AddProductoPage extends StatefulWidget {
  @override
  _AddProductoPageState createState() => _AddProductoPageState();
}

class _AddProductoPageState extends State<AddProductoPage> {
  final _formKey = GlobalKey<FormState>();
  String _nombreProducto = '';
  double _valor = 0.0;
  bool _disponibilidad = true;
  final MenuApi _menuApi = MenuApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
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
              SwitchListTile(
                title: Text('Disponible'),
                value: _disponibilidad,
                onChanged: (bool value) {
                  setState(() {
                    _disponibilidad = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Producto newProducto = Producto(
                      nombreProducto: _nombreProducto,
                      valor: _valor,
                      disponibilidad: _disponibilidad,
                    );
                    _menuApi.addProducto(newProducto).then((_) {
                      Navigator.pop(context);
                    });
                  }
                },
                child: Text('Agregar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
