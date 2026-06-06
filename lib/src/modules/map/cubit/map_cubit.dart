import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());

  static MapCubit get(context) => BlocProvider.of(context);

  late GoogleMapController gmc;
  void setController(GoogleMapController controller) {
    gmc = controller;
  }

  final initialCameraPosition = const CameraPosition(
    target: LatLng(
      34.733724,
      36.701170,
    ),
    zoom: 12,
  );

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    final codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> setMarkerCustomImage() async {
    final icon = await getBytesFromAsset('assets/images/logo.png', 80);

    mymarker.putIfAbsent(
      "300",
      () => Marker(
        markerId: const MarkerId("1"),
        position: const LatLng(34.736202, 36.701559),
        infoWindow: const InfoWindow(title: "300"),
        icon: BitmapDescriptor.fromBytes(icon),
      ),
    );
    emit(MapChangeNotifier());
  }

  Map<String, Marker> mymarker = {
    "350": const Marker(
      markerId: MarkerId("2"),
      position: LatLng(34.705610, 36.718193),
      infoWindow: InfoWindow(title: "350"),
    ),
    "360": const Marker(
      markerId: MarkerId("3"),
      position: LatLng(34.72924059781802, 36.73820066175546),
      infoWindow: InfoWindow(title: "360"),
    ),
    "370": const Marker(
        markerId: MarkerId("4"),
        position: LatLng(34.7795459703378, 36.260663615340384),
        infoWindow: InfoWindow(title: "370")),
    "380": const Marker(
      markerId: MarkerId("5"),
      position: LatLng(34.85048545996241, 36.72539000555145),
      infoWindow: InfoWindow(title: "380"),
    ),
    "390": const Marker(
      markerId: MarkerId("6"),
      position: LatLng(34.9146741373437, 36.73376004861392),
      infoWindow: InfoWindow(title: "390"),
    ),
  };

  void animateMap(Marker marker) {
    gmc.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          marker.position.latitude,
          marker.position.longitude,
        ),
        zoom: 17.5,
      )),
    );
  }
}
