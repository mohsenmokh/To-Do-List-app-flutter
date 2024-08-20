// ignore_for_file: file_names

import 'package:flutter_application_2/data/data.dart';
import 'package:flutter_application_2/data/source/source.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveTaskDataSource implements DataSource<Task> {
  final Box<Task> box;

  HiveTaskDataSource(this.box);

  @override
  Future<Task> createOrUpdate(Task data) async {
    if (data.isInBox) {
      data.save();
    } else {
      data.id = await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete(Task data) {
    return data.delete();
  }

  @override
  Future<void> deleteAll() {
    return box.clear();
  }

  @override
  Future<void> deleteById(id) {
    return box.delete(id);
  }

  @override
  Future<Task> findById(id) async {
    return box.values.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<Task>> getall({String searchKeyword = ''}) async {
    if (searchKeyword.isNotEmpty) {
      return box.values
          .where((task) => task.name.contains(searchKeyword))
          .toList();
    } else {
      return box.values.toList();
    }
  }
}
