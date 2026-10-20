import 'package:mobile_zpi/features/geozones/data/models/geozone.dart';
import 'package:mobile_zpi/features/geozones/data/repository/geozones_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'geozones_controller.g.dart';

@riverpod
class GeozonesController extends _$GeozonesController {
  @override
  Future<List<Geozone>> build(String seniorId) =>
      ref.watch(geozonesRepositoryProvider).getGeozones(seniorId);
}
