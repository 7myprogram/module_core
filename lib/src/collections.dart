import 'package:module_core/module_core.dart';

// インスタンスの実態を管理
class InstanceCollection {
  // インスタンスマップ
  final Map<Type, dynamic> _instances = {};

  // インスタンスを登録
  void register<T>(T instance) {
    _instances.putIfAbsent(T, () => instance);
  }

  // インスタンスを取得
  T getInstance<T>() {
    if (!_instances.containsKey(T)) {
      throw StateError("InstanceCollectionにインスタンスが登録されていません。");
    }
    return _instances[T] as T;
  }
}

// データソースの実態を管理
class DataSourceCollection extends InstanceCollection {}

// リポジトリの実態を管理
class RepositoryCollection extends InstanceCollection {
  // リポジトリをコレクションに登録
  @override
  void register<T>(T instance) {
    // RepositoryAttachmentを継承しているクラスのみ許可
    if (instance is! RepositoryAttachment) {
      throw TypeError();
    }
    super.register(instance);
  }

  // 登録済みのリポジトリにデータソースコレクションを設定
  void setDataSourceCollection(DataSourceCollection collection) {
    _instances.forEach((type, repository) {
      final temp = repository as RepositoryAttachment;
      temp.dataSourceCollection = collection;
    });
  }
}

// ユースケースの実態を管理
class UsecaseCollection extends InstanceCollection {
  // ユースケースをコレクションに登録
  @override
  void register<T>(T instance) {
    // UsecaseAttachmentを継承したクラスのみ許可
    if (instance is! UsecaseAttachment) {
      throw TypeError();
    }
    super.register<T>(instance);
  }

  // 設定済みのユースケースにリポジトリコレクションを登録
  void setRepositoryCollection(RepositoryCollection collection) {
    _instances.forEach((type, usecase) {
      final temp = usecase as UsecaseAttachment;
      temp.repositoryCollection = collection;
    });
  }
}

// ビュービルダーの実態を管理
class ViewBuilderCollection extends InstanceCollection {
  // ユースケースをコレクションに登録
  @override
  void register<T>(T instance) {
    // ViewBuilderAttachmentを継承したクラスのみ許可
    if (instance is! ViewBuilderAttachment) {
      throw TypeError();
    }
    super.register<T>(instance);
  }

  // 設定済みのビュービルダーにユースケースコレクションを登録
  void setUsecaseCollection(UsecaseCollection collection) {
    _instances.forEach((type, usecase) {
      final temp = usecase as UsecaseHolder;
      temp.usecaseCollection = collection;
    });
  }
}
