import 'package:flutter/material.dart';

// ignore: camel_case_types
class Mi_Billetera extends StatefulWidget {
  const Mi_Billetera({Key? key}) : super(key: key);

  @override
  _MiBilleteraState createState() => _MiBilleteraState();
}

class _MiBilleteraState extends State<Mi_Billetera> {
  String selectedPaymentMethod = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elige tu método de pago'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PaymentOption(
                  icon: Icons.attach_money,
                  name: 'Efectivo',
                  onChanged: () {
                    onPaymentMethodChanged('Efectivo');
                  },
                  isSelected: selectedPaymentMethod == 'Efectivo',
                ),
                PaymentOption(
                  icon: Icons.credit_card,
                  name: 'Tarjeta',
                  onChanged: () {
                    onPaymentMethodChanged('Tarjeta');
                  },
                  isSelected: selectedPaymentMethod == 'Tarjeta',
                ),
                PaymentOption(
                  icon: Icons.payment,
                  name: 'Yape',
                  onChanged: () {
                    onPaymentMethodChanged('Yape');
                  },
                  isSelected: selectedPaymentMethod == 'Yape',
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: () {
                // Navegar a la pantalla para agregar tarjeta
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AgregarTarjetaScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Color de fondo
                onPrimary: Colors.white, // Color del texto
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Agregar Tarjeta',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onPaymentMethodChanged(String paymentMethod) {
    setState(() {
      selectedPaymentMethod = paymentMethod;
    });
  }
}

class PaymentOption extends StatelessWidget {
  final IconData icon;
  final String name;
  final Function onChanged;
  final bool isSelected;

  const PaymentOption({
    Key? key,
    required this.icon,
    required this.name,
    required this.onChanged,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      trailing: Checkbox(
        value: isSelected,
        onChanged: (value) {
          onChanged();
        },
      ),
      onTap: onChanged as void Function()?,
    );
  }
}

class AgregarTarjetaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Tarjeta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'XXXX XXXX XXXX XXXX',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MM/YY',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Text(
                        'Nombre Apellido',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Número de Tarjeta',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Fecha de Caducidad',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Nombre de Titular',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    items: [
                      DropdownMenuItem(
                        value: 'DNI',
                        child: Text('DNI'),
                      ),
                      DropdownMenuItem(
                        value: 'Pasaporte',
                        child: Text('Pasaporte'),
                      ),
                      // Agrega más opciones según sea necesario
                    ],
                    decoration: InputDecoration(
                      labelText: 'Tipo Documento',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onChanged: (value) {
                      // Puedes manejar el cambio de selección aquí
                    },
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Número de Documento',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Lógica para guardar la tarjeta
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Guardar Tarjeta',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
