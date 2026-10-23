import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_zpi/features/geozones/data/current_position.dart';
import 'package:mobile_zpi/features/geozones/data/models/geozone.dart';
import 'package:mobile_zpi/features/geozones/data/models/walking_route.dart';
import 'package:mobile_zpi/features/geozones/data/repository/geozones_repository.dart';
import 'package:mobile_zpi/features/geozones/data/walking_route_client.dart';

class MockGeozonesRepository implements GeozonesRepository {
  MockGeozonesRepository(this._routingDio);

  final Dio _routingDio;

  final _geozones = <Geozone>[
    Geozone(
      zoneId: '1',
      seniorId: '',
      name: 'PWr – Gmach Główny A-1',
      center: const GeozoneCenter(latitude: 51.10745, longitude: 17.06200),
      radiusMeters: 120,
      isActive: true,
      smsOnExitEnabled: true,
      createdAt: DateTime(2026, 9, 1, 10),
      updatedAt: DateTime(2026, 9, 1, 10),
      version: 1,
    ),
    Geozone(
      zoneId: '2',
      seniorId: '',
      name: 'PWr – Budynek C-13',
      center: const GeozoneCenter(latitude: 51.10920, longitude: 17.05960),
      radiusMeters: 80,
      isActive: true,
      smsOnExitEnabled: false,
      createdAt: DateTime(2026, 9, 2, 9, 30),
      updatedAt: DateTime(2026, 9, 2, 9, 30),
      version: 1,
    ),
    Geozone(
      zoneId: '3',
      seniorId: '',
      name: 'PWr – Geocentrum D-20',
      center: const GeozoneCenter(latitude: 51.11010, longitude: 17.05760),
      radiusMeters: 100,
      isActive: false,
      smsOnExitEnabled: true,
      createdAt: DateTime(2026, 9, 5, 16, 45),
      updatedAt: DateTime(2026, 9, 6, 8, 15),
      version: 2,
    ),
  ];

  static const _delay = Duration(milliseconds: 600);

  @override
  Future<List<Geozone>> getGeozones(String seniorId, {bool? isActive}) async {
    await Future<void>.delayed(_delay);
    return List.unmodifiable(
      _geozones.where((zone) => isActive == null || zone.isActive == isActive),
    );
  }

  @override
  Future<WalkingRoute> getWalkingRoute(LatLng destination) async {
    final origin = await readCurrentPosition();
    return fetchWalkingRoute(_routingDio, origin, destination);
  }
}
