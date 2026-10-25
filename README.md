# 概要
クリーンアーキテクチャに基づいたアプリケーション機能を実装するためのパッケージです。

ユースケースやリポジトリなどのアーキテクチャを構成する要素同士の依存関係を明確にし、アプリケーション機能のカプセル化と依存性注入を行い、スクリーン生成までを支援します。

# アタッチメント
本パッケージでは、データソース、リポジトリ、ユースケース、ビュービルダーをアーキテクチャの主要な構成要素として扱います。
また、RepositoryAttachment、UsecaseAttachment、ViewBuilderAttachmentの3つのMixinを提供します。
各Mixinをwithで適用することで、モジュールに登録された依存先の構成要素を取得できます。

## データソース
DBやAPIなど外部へのアクセスを担当します。本パッケージでは、データソース専用のアタッチメントは設けず、依存性注入に使用するインターフェースを定義する構成としています。
```
// 以下は構造を示すための簡略化した例です


// 依存性注入用にインターフェースを定義
abstract class ISomeDataSource {
  SomeModel getData();
}

class SomeDataSource implements ISomeDataSource {
  SomeModel getData() {
    // データを取得しModelを生成
    // return ...
  }
}
```

## リポジトリ
モジュールに登録済みのデータソースのインスタンスを取得できます。
```
// 以下は構造を示すための簡略化した例です

import 'package:module_core/module_core.dart';


// 依存性注入用にインターフェースを定義
abstract class ISomeRepository {
  SomeEntity getData();
}

class SomeRepository with RepositoryAttachment implements ISomeRepository {
  SomeEntity getData() {
    // データソースを取得
    final dataSource = getDataSource<ISomeDataSource>();

    // 取得したデータをEntityに変換して返す
    // return ...
  }
}
```

## ユースケース
モジュールに登録済みのリポジトリのインスタンスを取得できます。ユースケースからリポジトリを利用するための依存性注入機能を提供します。
```
// 以下は構造を示すための簡略化した例です

import 'package:module_core/module_core.dart';


class SomeUsecase with UsecaseAttachment {
  void execute() {
    // リポジトリを取得
    final repository = getRepository<ISomeRepository>();
  }
}
```

## ビュービルダー
モジュールに登録済みのユースケースが取得できます。ViewBuilderAttachmentは型パラメータを持つMixinで、生成するスクリーンの型をパラメータに受け取ります。
```
// 以下は構造を示すための簡略化した例です

import 'package:module_core/module_core.dart';


class SomeViewBuilder with ViewBuilderAttachment<Screen> {
  @override
  Screen buildScreen(dynamic args) {
    // ユースケースを取得
    final usecase = getUsecase<SomeUsecase>();

    // すべてのユースケースを取得
    final allUsecases = getUsecaseHolder();

    // usecaseを利用してScreenを生成
    // return ...
  }
}
```

# モジュール
このパッケージでは、データ層、ドメイン層、プレゼンテーション層をそれぞれモジュールとして表現し、それらはリポジトリやユースケースといった構成要素を管理します。以下の実装作業はmodule_core_generatorを利用し自動化できます。

## データモジュール
データソースとリポジトリを管理し、リポジトリからデータソースを取得できるようにします。

定義するには、DataModuleをwithで適用し、外部公開用のインターフェースをimplementsで実装します。registerDataSourcesとregisterRepositoriesをoverrideし、それらのメソッド内でデータソースとリポジトリをそれぞれ登録します。
```
import 'package:module_core/module_core.dart';

// カプセル化用のインターフェース
abstract class ISomeDataModule {}

// DataModuleを適用しデータモジュールを定義
final class SomeDataModule with DataModule implements ISomeDataModule {
  // データソースを登録し、依存性注入を行う
  @override
  void registerDataSources(DataSourceCollection dataSourceCollection) {
    dataSourceCollection.register<IDataSource1>(DataSource1Impl());
    dataSourceCollection.register<IDataSource2>(DataSource2Impl());
  }

  // リポジトリを登録し、依存性注入を行う
  @override
  void registerRepositories(RepositoryCollection repositoryCollection) {
    repositoryCollection.register<IRepository1>(Repository1Impl());
    repositoryCollection.register<IRepository2>(Repository2Impl());
  }
}
```

## ドメインモジュール
ユースケースを管理します。ユースケースからリポジトリを取得できるようにします。

定義するには、DomainModuleをwithで適用し、外部公開用のインターフェースをimplementsで実装します。registerUsecasesをoverrideし、メソッド内でユースケースを登録します。
```
import 'package:module_core/module_core.dart';

// カプセル化用のインターフェース
abstract class ISomeDomainModule {}

// DomainModuleを適用しドメインモジュールを定義
final class SomeDomainModule with DomainModule implements ISomeDomainModule {
  // ユースケースを登録する
  @override
  void registerUsecases(UsecaseCollection collection) {
    collection.register(SomeUsecase1());
    collection.register(SomeUsecase2());
    collection.register(SomeUsecase3());
  }
}
```

## プレゼンテーションモジュール
ビュービルダーを管理します。ビュービルダーからユースケースを取得できるようにします。

定義するには、PresentationModuleをwithで適用し、外部公開用のインターフェースをimplementsで実装します。registerViewBuilderをoverrideし、メソッド内でビュービルダーを登録します。スクリーン生成用のメソッドも定義しインターフェースを通じて外部に公開します。
```
import 'package:module_core/module_core.dart';

// カプセル化用のインターフェース
abstract class ISomePresentationModule {
  Screen1 buildScreen1({dynamic args});
  Screen2 buildScreen2({dynamic args});
  Screen3 buildScreen3({dynamic args});
}

// PresentationModuleを適用しプレゼンテーションモジュールを定義
final class SomePresentationModule with PresentationModule implements ISomePresentationModule {
  // ビュービルダーを登録する
  @override
  void registerViewBuilder(ViewBuilderCollection collection) {
    collection.register(ScreenBuilder1());
    collection.register(ScreenBuilder2());
    collection.register(ScreenBuilder3());
  }

  @override
  Screen1 buildScreen1({dynamic args}) {
    // ビュービルダーを取得しスクリーンを生成
    return getViewBuilder<ScreenBuilder1>().buildScreen(args);
  }

  @override
  Screen2 buildScreen2({dynamic args}) {
    // ビュービルダーを取得しスクリーンを生成
    return getViewBuilder<ScreenBuilder2>().buildScreen(args);
  }

  @override
  Screen3 buildScreen3({dynamic args}) {
    // ビュービルダーを取得しスクリーンを生成
    return getViewBuilder<ScreenBuilder3>().buildScreen(args);
  }
}
```

# コア
Coreは、データモジュール、ドメインモジュール、プレゼンテーションモジュールを統合し、初期化と外部公開用インターフェースを通じたアクセスを管理するクラスです。
```
import 'package:module_core/module_core.dart';

final class SomeModuleProduct
    extends
        // インターフェースを用いてカプセル化
        Core<
          ISomeDataModule,
          ISomeDomainModule,
          ISomePresentationModule
        > {
  SomeModuleProduct()
    : super(
        data: SomeDataModule(),
        domain: SomeDomainModule(),
        presentation: SomePresentationModule(),
      );
}


// アプリケーション機能モジュールのインスタンスを生成
SomeModuleProduct someModule = SomeModuleProduct();

// presentationモジュールからスクリーンを生成
someModule.presentation.buildScreen1();
```