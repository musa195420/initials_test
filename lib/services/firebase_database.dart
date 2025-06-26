import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDatabaseImpl implements IFirebaseDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> setDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(docId).set(data);
  }

  @override
  Future<void> updateDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(docId).update(data);
  }

  @override
  Future<void> deleteDocument({
    required String collection,
    required String docId,
  }) async {
    await _firestore.collection(collection).doc(docId).delete();
  }

  @override
  Future<Map<String, dynamic>?> getDocumentById({
    required String collection,
    required String docId,
  }) async {
    final doc = await _firestore.collection(collection).doc(docId).get();
    return doc.exists ? doc.data() : null;
  }

  @override
  Future<List<Map<String, dynamic>>> queryDocuments({
    required String collection,
    required String field,
    required dynamic value,
  }) async {
    final query = await _firestore
        .collection(collection)
        .where(field, isEqualTo: value)
        .get();

    return query.docs.map((e) => e.data()).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getAllDocuments({
    required String collection,
  }) async {
    final query = await _firestore.collection(collection).get();
    return query.docs.map((e) => e.data()).toList();
  }
}

abstract class IFirebaseDatabase {
  Future<void> setDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  });

  Future<void> updateDocument({
    required String collection,
    required String docId,
    required Map<String, dynamic> data,
  });

  Future<void> deleteDocument({
    required String collection,
    required String docId,
  });

  Future<Map<String, dynamic>?> getDocumentById({
    required String collection,
    required String docId,
  });

  Future<List<Map<String, dynamic>>> queryDocuments({
    required String collection,
    required String field,
    required dynamic value,
  });

  Future<List<Map<String, dynamic>>> getAllDocuments({
    required String collection,
  });
}
