import 'package:module_core/module_core.dart';

// 各層をまとめる親モジュール
class ModuleCore<Data, Domain, Presentation> {
  final Data data;
  final Domain domain;
  final Presentation presentation;

  ModuleCore({
    required Data data,
    required Domain domain,
    required Presentation presentation,
  }) : data = data,
       domain = domain,
       presentation = presentation {
    if (data is! DataModule ||
        domain is! DomainModule ||
        presentation is! PresentationModule) {
      throw TypeError();
    }

    final tempData = data as DataModule;
    final tempDomain = domain as DomainModule;
    final tempPresentation = presentation as PresentationModule;

    // データ層を初期化
    tempData._initialization();

    // ドメイン層を初期化
    tempDomain._initialization(tempData._repositoryCollection);

    // プレゼンテーション層を初期化
    tempPresentation._initialization(tempDomain._usecaseCollection);
  }
}

// データ層を形成するモジュールのアダプター
mixin DataModule {
  final _dataSourceCollection = DataSourceCollection();
  final _repositoryCollection = RepositoryCollection();

  void _initialization() {
    // データソースインスタンスをコレクションに登録
    registerDataSources(_dataSourceCollection);

    // リポジトリインスタンスをコレクションに登録
    registerRepositories(_repositoryCollection);

    // リポジトリコレクションに登録されたすべてのリポジトリにデータソースコレクションを設定
    _repositoryCollection.setDataSourceCollection(_dataSourceCollection);
  }

  // DataSource登録処理実装の強制
  void registerDataSources(DataSourceCollection dataSourceCollection);

  // Repository登録処理実装の強制
  void registerRepositories(RepositoryCollection repositoryCollection);

  // リポジトリを取得
  T getRepository<T extends RepositoryAttachment>() {
    return _repositoryCollection.getInstance<T>();
  }
}

// ドメイン層を形成するモジュールのアダプター
mixin DomainModule {
  final _usecaseCollection = UsecaseCollection();

  // 初期化処理
  void _initialization(RepositoryCollection repositoryCollection) {
    // ユースケースをコレクションに登録
    registerUsecases(_usecaseCollection);

    _usecaseCollection.setRepositoryCollection(repositoryCollection);
  }

  // Usecase登録処理実装の強制
  void registerUsecases(UsecaseCollection usecaseRegister);
}

// プレゼンテーション層を形成するモジュールのアダプター
mixin PresentationModule {
  late final UsecaseCollection _usecaseCollection;

  // 初期化処理
  void _initialization(UsecaseCollection collection) {
    // ユースケースコレクションを設定
    _usecaseCollection = collection;

    afterInitialization();
  }

  void afterInitialization() {}

  void takeUsecases(UsecaseHolder holder) {
    holder.usecaseCollection = _usecaseCollection;
  }
}
