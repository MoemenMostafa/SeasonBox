import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheManager {
  static const key = 'seasonBoxImageCache';

  static CacheManager instance = CacheManager(
    kIsWeb
        ? Config(
            key,
            stalePeriod: const Duration(days: 30),
            maxNrOfCacheObjects: 200,
            fileService: HttpFileService(),
          )
        : Config(
            key,
            stalePeriod: const Duration(days: 30),
            maxNrOfCacheObjects: 200,
            repo: JsonCacheInfoRepository(databaseName: key),
            fileService: HttpFileService(),
          ),
  );
}
