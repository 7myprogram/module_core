import 'package:module_core/module_core.dart';

mixin RepositoryAttachment {
  final _holder = DataSourceHolder();

  set dataSourceCollection(DataSourceCollection dataSourceCollection) {
    _holder.dataSourceCollection = dataSourceCollection;
  }

  DataSource getDataSource<DataSource>() {
    return _holder.getDataSource<DataSource>();
  }
}

mixin UsecaseAttachment {
  final _holder = RepositoryHolder();

  set repositoryCollection(RepositoryCollection repositoryCollection) {
    _holder.repositoryCollection = repositoryCollection;
  }

  Repository getRepository<Repository>() {
    return _holder.getRepository<Repository>();
  }
}

mixin ViewBuilderAttachment<Screen> {
  final _holder = UsecaseHolder();

  // ユースケースコレクションを設定
  set usecaseCollection(UsecaseCollection collection) {
    _holder.usecaseCollection = collection;
  }

  // ユースケースを取得
  Usecase getUsecase<Usecase>() {
    return _holder.getUsecase<Usecase>();
  }

  UsecaseHolder getUsecaseHolder() {
    return _holder;
  }

  void processAfterSetUsecase() {}

  Screen buildScreen(dynamic args);
}
