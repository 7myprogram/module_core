import 'package:module_core/module_core.dart';

// エイリアス
typedef RepositoryAttachment = DataSourceHolder;
typedef UsecaseAttachment = RepositoryHolder;

abstract class ViewBuilderAttachment<Screen> with UsecaseHolder {
  void afterGetUsecase() {}
  Screen buildScreen(dynamic args);
}
