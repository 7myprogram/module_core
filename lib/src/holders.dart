import 'package:module_core/module_core.dart';

// DataSourceCollectionを受け取り、それを保持する。
mixin class DataSourceHolder {
  late final DataSourceCollection _dataSourceCollection;

  set dataSourceCollection(DataSourceCollection dataSourceCollection) {
    _dataSourceCollection = dataSourceCollection;
  }

  DataSource getDataSource<DataSource>() {
    return _dataSourceCollection.getInstance<DataSource>();
  }
}

// RepositoryCollectionを受け取り、それを保持する。
mixin class RepositoryHolder {
  late final RepositoryCollection _repositoryCollection;

  set repositoryCollection(RepositoryCollection repositoryCollection) {
    _repositoryCollection = repositoryCollection;
  }

  Repository getRepository<Repository>() {
    return _repositoryCollection.getInstance<Repository>();
  }
}

// UsecaseCollectionを受け取り、それを保持する。
mixin class UsecaseHolder {
  late final UsecaseCollection _usecaseCollection;

  // ユースケースコレクションを設定
  set usecaseCollection(UsecaseCollection collection) {
    _usecaseCollection = collection;
  }

  // ユースケースを取得
  Usecase getUsecase<Usecase>() {
    return _usecaseCollection.getInstance<Usecase>();
  }

  UsecaseHolder copyUsecaseHolder() {
    final holder = UsecaseHolder();
    holder.usecaseCollection = _usecaseCollection;
    return holder;
  }
}
