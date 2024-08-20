abstract class DataSource<T> {
  Future<List<T>> getall({String searchKeyword});
  Future<T> findById(dynamic id);
  Future<void> deleteAll();
  Future<void> deleteById(dynamic id);
  Future<void> delete(T data);
  Future<T> createOrUpdate(T data);
}
