import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:monawpaty/src/modules/map/cubit/map_cubit.dart';
import 'package:animated_fab_button_menu/animated_fab_button_menu.dart';
import '../../shared/styles/colors.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapCubit()..setMarkerCustomImage(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocConsumer<MapCubit, MapState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: Padding(
                  padding: const EdgeInsets.only(left: 4.0, bottom: 35.0),
                  child: FabMenu(
                      fabBackgroundColor: primaryColor,
                      elevation: 2.0,
                      fabAlignment: Alignment.bottomLeft,
                      fabIcon: const Icon(FontAwesomeIcons.globe),
                      closeMenuButton: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      overlayOpacity: 0.5,
                      overlayColor: secondaryColor,
                      children: MapCubit.get(context)
                          .mymarker
                          .keys
                          .map((e) => MenuItem(
                                title:
                                    "المركز رقم ${MapCubit.get(context).mymarker[e]!.infoWindow.title!}",
                                onTap: () {
                                  MapCubit.get(context).animateMap(
                                      MapCubit.get(context).mymarker[e]!);
                                  Navigator.pop(context);
                                },
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ))
                          .toList()),
                ),
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  title: const Text("مواقع المراكز"),
                  titleTextStyle: TextStyle(
                      fontFamily: GoogleFonts.cairo().fontFamily,
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  backgroundColor: primaryColor,
                  centerTitle: true,
                ),
                body: GoogleMap(
                  markers: MapCubit.get(context).mymarker.values.toSet(),
                  mapType: MapType.hybrid,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  initialCameraPosition:
                      MapCubit.get(context).initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    MapCubit.get(context).setController(controller);
                  },
                ));
          },
        ),
      ),
    );
  }
}
