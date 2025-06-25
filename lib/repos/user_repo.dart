import 'package:hive/hive.dart';
import 'package:initial_test/models/hive_models/hive_user.dart';
import 'package:initial_test/services/hive_service.dart';

class HiveUserRepo implements IHiveService<HiveUser> {
  late Box<HiveUser> _box;

  @override
  Future<void> init() async {
    Hive.registerAdapter(HiveUserAdapter());
    _box = await Hive.openBox<HiveUser>("HiveUsers");
  }

  @override
  Future<List<HiveUser>> getAllWithPredicate(
      bool Function(HiveUser) predicate) async {
    return _box.values.where(predicate).toList();
  }

  @override
  Future<List<HiveUser>> search(String searchValue) async {
    return _box.values.where((item) => item.email == searchValue).toList();
  }

  @override
  Future<List<HiveUser>> searchAndPaginate(
      String searchValue, int pageNo, int pageSize) async {
    return _box.values
        .where((item) => item.email == searchValue)
        .skip(pageNo * pageSize)
        .take(pageSize)
        .toList();
  }

  @override
  Future<void> add(HiveUser item) async {
    await _box.add(item);
  }

  @override
  Future<void> addOrUpdate(HiveUser item) async {
    if (_box.values.any((element) => item.userId == element.userId)) {
      var bar = await getFirst(item.userId.toString());
      update(bar?.key, item);
    } else {
      await add(item);
    }
  }

  @override
  Future<void> addOrUpdateRange(List<HiveUser> items) async {
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
  Future<void> deleteAllAndAdd(HiveUser item) async {
    await _box.clear();
    await _box.add(item);
  }

  @override
  Future<void> deleteAllAndAddRange(List<HiveUser> items) async {
    await _box.clear();
    await _box.addAll(items);
  }

  @override
  Future<void> addRange(List<HiveUser> items) async {
    await _box.addAll(items);
  }

  @override
  Future<HiveUser> get(dynamic key) async {
    return _box
        .get(key)!; // Make sure to handle null according to your app's needs
  }

  @override
  Future<HiveUser?> getFirst(String id) async {
    for (var element in _box.values) {
      if (element.userId == id) return element;
    }
    return null;
  }

  @override
  Future<HiveUser?> getFirstOrDefault() async {
    if (_box.values.isNotEmpty) {
      return _box.values.first;
    }
    return null;
  }

  @override
  Future<List<HiveUser>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<List<HiveUser>> getAllAndPaginate(int pageNo, int pageSize) async {
    return _box.values.skip(pageNo * pageSize).take(pageSize).toList();
  }

  @override
  Future<void> update(dynamic key, HiveUser updatedItem) async {
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
    _box = await Hive.openBox<HiveUser>("HiveUsers");
  }
}
