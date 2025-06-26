import 'package:initial_test/helper/locator.dart';
import 'package:initial_test/services/firebase_database.dart';

import '../../models/user_model.dart';

class ApiServiceImpl implements IApiService {
  final IFirebaseDatabase _db = locator<IFirebaseDatabase>();

  ApiServiceImpl();

  static const _usercollection = 'users';

  @override
  Future<void> addUser(UserModel user) async {
    await _db.setDocument(
      collection: _usercollection,
      docId: user.id,
      data: user.toJson(),
    );
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _db.updateDocument(
      collection: _usercollection,
      docId: user.id,
      data: user.toJson(),
    );
  }

  @override
  Future<void> deleteUser(String id) async {
    await _db.deleteDocument(
      collection: _usercollection,
      docId: id,
    );
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    final data = await _db.getDocumentById(
      collection: _usercollection,
      docId: id,
    );
    return data != null ? UserModel.fromJson(data) : null;
  }

  @override
  Future<List<UserModel>> getUsersByField(String field, dynamic value) async {
    final list = await _db.queryDocuments(
      collection: _usercollection,
      field: field,
      value: value,
    );
    return list.map((json) => UserModel.fromJson(json)).toList();
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final list = await _db.getAllDocuments(collection: _usercollection);
    return list.map((json) => UserModel.fromJson(json)).toList();
  }
}

sealed class IApiService {
  Future<void> addUser(UserModel user);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String id);
  Future<UserModel?> getUserById(String id);
  Future<List<UserModel>> getUsersByField(String field, dynamic value);
  Future<List<UserModel>> getAllUsers();
}
