import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  static const String routeName = '/map';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final locationController = Location();
  static const legoStore = LatLng(10.875441247362792, 106.80191659652543);
  //static const mountainView = LatLng(10.880805327119527, 106.80699950625984);

  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdates());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            // child: ElevatedButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   style: ElevatedButton.styleFrom(
            //     shape: const CircleBorder(),
            //     padding: EdgeInsets.zero,
            //     elevation: 0,
            //     backgroundColor: Colors.white,
            //   ),
            //   child: const Icon(
            //     Icons.arrow_back_ios_new,
            //     color: Colors.black,
            //     size: 20,
            //   ),
            // ),
          ),
        ),
        body: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: legoStore,
            zoom: 17,
          ),
          markers: {
            const Marker(
              markerId: MarkerId('currentLocation'),
              icon: BitmapDescriptor.defaultMarker,
              position: legoStore,
              infoWindow: InfoWindow(title: 'Lego Store'),
            ),
            // const Marker(
            //   markerId: MarkerId('sourceLocation'),
            //   icon: BitmapDescriptor.defaultMarker,
            //   position: googlePlex,
            // ),
            // const Marker(
            //   markerId: MarkerId('destinationLocation'),
            //   icon: BitmapDescriptor.defaultMarker,
            //   position: mountainView,
            // )
          },
        ),
      );

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
      }
      print('Current Position: $currentPosition');
    });
  }
}
