import 'package:act16/services/firebase_services.dart';
import 'package:flutter/material.dart';

class EditUsuario extends StatefulWidget {
  const EditUsuario({super.key});

  @override
  State<EditUsuario> createState() => _EditUsuarioState();
}

class _EditUsuarioState extends State<EditUsuario> {
  TextEditingController nombreController = TextEditingController(text: '');
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController nocuentaController = TextEditingController(text: '');

  late Map arguments;
  bool _cargado = false;

  // Recibimos los argumentos una sola vez (si se hiciera en build,
  // el texto se reiniciaría cada vez que se redibuja la pantalla)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_cargado) {
      arguments = ModalRoute.of(context)!.settings.arguments as Map;
      nombreController.text = arguments['nombre'];
      emailController.text = arguments['email'];
      nocuentaController.text = arguments['noCuenta'];
      _cargado = true;
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    emailController.dispose();
    nocuentaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nocuentaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'No. cuenta',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await editUsuario(
                  arguments['uid'],
                  nombreController.text,
                  emailController.text,
                  nocuentaController.text,
                ).then((_) {
                  if (context.mounted) Navigator.pop(context);
                });
              },
              child: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
