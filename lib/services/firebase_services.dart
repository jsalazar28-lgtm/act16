import 'package:cloud_firestore/cloud_firestore.dart';

// Instancia de Firestore
FirebaseFirestore db = FirebaseFirestore.instance;

// LEER: trae todos los documentos de la colección "usuarios"
Future<List> getUsuarios() async {
  List usuarios = [];
  CollectionReference collectionReferenceUsuarios = db.collection('usuarios');
  QuerySnapshot queryUsuarios = await collectionReferenceUsuarios.get();

  for (var documento in queryUsuarios.docs) {
    final Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    final usuario = {
      'uid': documento.id,
      'nombre': data['nombre'] ?? '',
      'email': data['email'] ?? '',
      'noCuenta': data['noCuenta'] ?? '',
    };
    usuarios.add(usuario);
  }
  return usuarios;
}

// CREAR: agrega un documento con ID automático
Future<void> agregarUsuario(String nNombre, String nEmail, String nCuenta) async {
  await db.collection('usuarios').add({
    'nombre': nNombre,
    'email': nEmail,
    'noCuenta': nCuenta,
  });
}

// ACTUALIZAR: reemplaza los campos del documento con ese uid
Future<void> editUsuario(
    String uid, String eNombre, String eMail, String eCuenta) async {
  await db.collection('usuarios').doc(uid).set({
    'nombre': eNombre,
    'email': eMail,
    'noCuenta': eCuenta,
  });
}

// ELIMINAR: borra el documento con ese uid
Future<void> deleteUsuario(String uid) async {
  await db.collection('usuarios').doc(uid).delete();
}
