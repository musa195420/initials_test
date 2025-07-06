import 'package:hive/hive.dart';
import 'package:initial_test/models/hive_models/user_profile.dart';
import 'package:initial_test/services/hive_service.dart';

class UserProfileRepo implements IHiveService<UserProfile> {
  late Box<UserProfile> _box;

  @override
  Future<void> init() async {
    Hive.registerAdapter(UserProfileAdapter());
    _box = await Hive.openBox<UserProfile>("UserProfiles");
  }

  @override
  Future<List<UserProfile>> getAllWithPredicate(
      bool Function(UserProfile) predicate) async {
    return _box.values.where(predicate).toList();
  }

  @override
  Future<List<UserProfile>> search(String searchValue) async {
    return _box.values.where((item) => item.email == searchValue).toList();
  }

  @override
  Future<List<UserProfile>> searchAndPaginate(
      String searchValue, int pageNo, int pageSize) async {
    return _box.values
        .where((item) => item.email == searchValue)
        .skip(pageNo * pageSize)
        .take(pageSize)
        .toList();
  }

  @override
  Future<void> add(UserProfile item) async {
    await _box.add(item);
  }

  @override
  Future<void> addOrUpdate(UserProfile item) async {
    if (_box.values.any((element) => item.userId == element.userId)) {
      var bar = await getFirst(item.userId.toString());
      update(bar?.key, item);
    } else {
      await add(item);
    }
  }

  @override
  Future<void> addOrUpdateRange(List<UserProfile> items) async {
    for (var item in items) {
      if (_box.values.any((element) => item.userId == element.userId)) {
        var bar = await getFirst(item.userId.toString());
        update(bar?.key, item);
      } else {
        await add(item);
      }
    }
  }

  @override
  Future<void> deleteAllAndAdd(UserProfile item) async {
    await _box.clear();
    await _box.add(item);
  }

  @override
  Future<void> deleteAllAndAddRange(List<UserProfile> items) async {
    await _box.clear();
    await _box.addAll(items);
  }

  @override
  Future<void> addRange(List<UserProfile> items) async {
    await _box.addAll(items);
  }

  @override
  Future<UserProfile> get(dynamic key) async {
    return _box
        .get(key)!; // Make sure to handle null according to your app's needs
  }

  @override
  Future<UserProfile?> getFirst(String id) async {
    for (var element in _box.values) {
      if (element.userId == id) return element;
    }
    return null;
  }

  @override
  Future<UserProfile?> getFirstOrDefault() async {
    if (_box.values.isNotEmpty) {
      return _box.values.first;
    }
    return null;
  }

  @override
  Future<List<UserProfile>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<List<UserProfile>> getAllAndPaginate(int pageNo, int pageSize) async {
    return _box.values.skip(pageNo * pageSize).take(pageSize).toList();
  }

  @override
  Future<void> update(dynamic key, UserProfile updatedItem) async {
    await _box.put(key, updatedItem);
  }

  @override
  Future<void> delete(dynamic key) async {
    await _box.delete(key);
  }

  @override
  Future<void> deleteAll() async {
    await _box.clear();
  }

  @override
  int get length => _box.length;

  @override
  Future<void> close() async {
    if (_box.isOpen) {
      await _box.close();
    }
  }

  @override
  Future<void> reOpenBox() async {
    if (_box.isOpen) {
      await close();
    }
    _box = await Hive.openBox<UserProfile>("UserProfiles");
  }
}
