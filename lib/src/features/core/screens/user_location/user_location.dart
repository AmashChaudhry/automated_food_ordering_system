import 'package:automated_food_ordering_system/src/features/authentication/models/user_model.dart';
import 'package:automated_food_ordering_system/src/features/core/controllers/profile_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UserLocation extends StatefulWidget {
  const UserLocation({Key? key}) : super(key: key);

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  final TextEditingController _locationController = TextEditingController();
  final Set<Marker> _markers = {};

  static const LatLng sourceLocation = LatLng(0, 0);
  late GoogleMapController _mapController;
  late LatLng _currentLocation;
  String _locationText = '';

  final controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }

  Future<void> updateRecord(
      String documentId, String address, GeoPoint location) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(documentId)
          .update({
        'Address': address,
        'Location': location,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating document: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: const Text('Location'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      initialCameraPosition: const CameraPosition(
                        target: sourceLocation,
                        zoom: 0,
                      ),
                      markers: _markers,
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high,
                      );
                      final List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                        position.latitude,
                        position.longitude,
                      );
                      final Placemark placemark = placemarks.first;
                      final String address =
                          '${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}';
                      setState(() {
                        _currentLocation =
                            LatLng(position.latitude, position.longitude);
                        _locationText = address;
                        _markers.clear();
                        _markers.add(
                          Marker(
                            markerId: const MarkerId('current_location'),
                            position: _currentLocation,
                            infoWindow: const InfoWindow(
                              title: 'Current Location',
                            ),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueOrange),
                          ),
                        );
                      });
                      _mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _currentLocation,
                            zoom: 16,
                          ),
                        ),
                      );
                      _locationController.text = address;
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.my_location,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 10),
                          Text('Use my current location'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _locationController,
                            onChanged: (value) {
                              setState(
                                () {
                                  _locationText = value;
                                },
                              );
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter Your Location',
                              filled: true,
                              isCollapsed: true,
                              prefixIcon: const Icon(Icons.location_on),
                              prefixIconConstraints: const BoxConstraints(minWidth: 45),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.transparent),
                              ),
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            final List<Location> locations =
                                await locationFromAddress(
                                    _locationController.text);
                            if (locations.isNotEmpty) {
                              final LatLng latLng = LatLng(
                                  locations.first.latitude,
                                  locations.first.longitude);
                              setState(() {
                                _currentLocation = latLng;
                                _locationText = _locationController.text;
                                _markers.clear();
                                _markers.add(Marker(
                                  markerId: const MarkerId('searched_location'),
                                  position: _currentLocation,
                                  infoWindow: const InfoWindow(
                                    title: 'Searched Location',
                                  ),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueOrange),
                                ));
                              });
                              _mapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: _currentLocation,
                                    zoom: 16,
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            backgroundColor: Colors.orange,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Icon(Icons.search_rounded),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel user = snapshot.data as UserModel;
                  final id = TextEditingController(text: user.id);
                  return Container(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              GeoPoint location = GeoPoint(
                                  _currentLocation.latitude,
                                  _currentLocation.longitude);
                              await updateRecord(
                                id.text,
                                _locationText,
                                location,
                              );
                              Get.back(
                                  result: [_locationText, _currentLocation]);
                            },
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Save Address',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text('Something went wrong'));
                }
              } else {
                return Container(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
