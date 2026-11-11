import 'package:act16/services/firebase_services.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios - Firestore'),
      ),
      body: FutureBuilder(
        future: getUsuarios(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }
          if (snapshot.hasData == false) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay usuarios registrados'));
          }
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: ((context, index) {
              final usuario = snapshot.data![index];
              final String nombre = usuario['nombre'];
              return Dismissible(
                key: Key(usuario['uid']),
                direction: DismissDirection.startToEnd,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  bool? result = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirmación'),
                        content: Text(
                            '¿Estás seguro de querer eliminar a $nombre?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text('Sí'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: const Text('Cancelar',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  );
                  return result ?? false;
                },
                onDismissed: (direction) async {
                  final uid = usuario['uid'];
                  snapshot.data?.removeAt(index);
                  await deleteUsuario(uid);
                },
                child: ListTile(
                  title: Text(nombre),
                  subtitle: Text(
                      '${usuario['email']}  •  No. cuenta: ${usuario['noCuenta']}'),
                  leading: CircleAvatar(
                    child: Text(nombre.isNotEmpty ? nombre.substring(0, 1) : '?'),
                  ),
                  trailing: const Icon(Icons.edit),
                  onTap: () async {
                    await Navigator.pushNamed(context, '/edit', arguments: {
                      'uid': usuario['uid'],
                      'nombre': usuario['nombre'],
                      'email': usuario['email'],
                      'noCuenta': usuario['noCuenta'],
                    });
                    setState(() {});
                  },
                ),
              );
            }),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
