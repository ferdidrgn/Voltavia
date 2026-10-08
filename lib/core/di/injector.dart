import 'package:get_it/get_it.dart';

import '../../data/stations/station_repository.dart';
import '../../domain/stations/station_catalog.dart';

final GetIt injector = GetIt.instance;

void setupInjector() {
  if (injector.isRegistered<StationCatalog>()) return;
  injector.registerLazySingleton<StationCatalog>(StationRepository.new);
}
