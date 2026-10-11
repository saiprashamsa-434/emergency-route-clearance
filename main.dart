import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:async';

final ValueNotifier<String?> activeEmergencyHospital = ValueNotifier<String?>(
  null,
);

final ValueNotifier<bool> isEmergencyActive = ValueNotifier<bool>(false);

final ValueNotifier<Position?> ambulancePosition = ValueNotifier<Position?>(
  null,
);

void main() {
  runApp(const EmergencyRouteApp());
}

Future<Position?> getAmbulanceLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return null;
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return null;
  }

  return await Geolocator.getCurrentPosition();
}

class EmergencyRouteApp extends StatelessWidget {
  const EmergencyRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emergency Route',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emergency Route',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),

            const Icon(Icons.local_hospital, size: 90, color: Colors.red),

            const SizedBox(height: 20),

            const Text(
              'Emergency Ambulance',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              'Clear the route. Save valuable time.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 45),

            // Ambulance Driver Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AmbulanceDriverPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.local_hospital),
                label: const Text(
                  'AMBULANCE DRIVER',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Police Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PoliceOfficerPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.local_police),
                label: const Text(
                  'POLICE / TRAFFIC OFFICER',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AmbulanceDriverPage extends StatefulWidget {
  const AmbulanceDriverPage({super.key});

  @override
  State<AmbulanceDriverPage> createState() => _AmbulanceDriverPageState();
}

class _AmbulanceDriverPageState extends State<AmbulanceDriverPage> {
  String? selectedHospital;

  final List<String> hospitals = [
    'City Hospital',
    'Government General Hospital',
    'Apollo Hospital',
    'Care Hospital',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambulance Driver'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emergency Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            const Text(
              'Select Destination Hospital',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.local_hospital),
                hintText: 'Choose hospital',
              ),
              value: selectedHospital,
              items: hospitals.map((hospital) {
                return DropdownMenuItem(value: hospital, child: Text(hospital));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedHospital = value;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: selectedHospital == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RouteSelectionPage(hospital: selectedHospital!),
                          ),
                        );
                      },
                icon: const Icon(Icons.route),
                label: const Text(
                  'CONTINUE TO ROUTE',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RouteSelectionPage extends StatelessWidget {
  final String hospital;

  const RouteSelectionPage({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Selection'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emergency Route',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            const Text(
              'Destination Hospital',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_hospital, color: Colors.red),
                  const SizedBox(width: 12),
                  Text(hospital, style: const TextStyle(fontSize: 17)),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 70, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'Route Map',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text('Map will be added later'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  activeEmergencyHospital.value = hospital;
                  isEmergencyActive.value = true;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EmergencyActivePage(hospital: hospital),
                    ),
                  );
                },
                icon: const Icon(Icons.warning),
                label: const Text(
                  'SEND EMERGENCY SIGNAL',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyActivePage extends StatefulWidget {
  final String hospital;

  const EmergencyActivePage({super.key, required this.hospital});

  @override
  State<EmergencyActivePage> createState() => _EmergencyActivePageState();
}

class _EmergencyActivePageState extends State<EmergencyActivePage> {
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _positionSubscription;

  Position? _currentPosition;
  String _locationStatus = 'Waiting for GPS location...';

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  Future<void> _startLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (mounted) {
        setState(() {
          _locationStatus = 'Please enable device location.';
        });
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() {
          _locationStatus = 'Location permission was not granted.';
        });
      }
      return;
    }

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            if (!mounted) return;

            setState(() {
              _currentPosition = position;
              _locationStatus = 'GPS location updating';
              ambulancePosition.value = position;
            });

            _mapController.move(
              LatLng(position.latitude, position.longitude),
              15,
            );
          },
          onError: (error) {
            if (mounted) {
              setState(() {
                _locationStatus = 'Unable to get GPS location.';
              });
            }
          },
        );
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Active'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.red, size: 35),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EMERGENCY ACTIVE',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Demo status — no real police alert is sent.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              'Destination Hospital',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_hospital, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.hospital,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Ambulance Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_locationStatus)),
                    ],
                  ),
                  if (_currentPosition != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Latitude: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                    ),
                    Text(
                      'Longitude: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(Icons.route, color: Colors.blue),
                      SizedBox(width: 10),
                      Expanded(child: Text('Live GPS tracking demo')),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 280,
              width: double.infinity,
              child: FlutterMap(
                mapController: _mapController,
                options: const MapOptions(
                  initialCenter: LatLng(17.3850, 78.4867),
                  initialZoom: 13,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.emergency_route_clea',
                  ),
                  MarkerLayer(
                    markers: [
                      if (_currentPosition != null)
                        Marker(
                          point: LatLng(
                            _currentPosition!.latitude,
                            _currentPosition!.longitude,
                          ),
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.local_shipping,
                            color: Colors.blue,
                            size: 40,
                          ),
                        ),
                      const Marker(
                        point: LatLng(17.3850, 78.4867),
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.local_hospital,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.check_circle),
                label: const Text('Clear Emergency'),
                onPressed: () {
                  isEmergencyActive.value = false;
                  activeEmergencyHospital.value = null;
                  ambulancePosition.value = null;
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PoliceOfficerPage extends StatefulWidget {
  const PoliceOfficerPage({super.key});

  @override
  State<PoliceOfficerPage> createState() => _PoliceOfficerPageState();
}

class _PoliceOfficerPageState extends State<PoliceOfficerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Police Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Traffic Police Dashboard',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isEmergencyActive.value
                    ? Colors.red.shade50
                    : Colors.grey.shade100,
                border: Border.all(
                  color: isEmergencyActive.value ? Colors.red : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isEmergencyActive.value
                        ? Icons.warning
                        : Icons.notifications_none,
                    color: isEmergencyActive.value ? Colors.red : Colors.grey,
                    size: 35,
                  ),

                  const SizedBox(height: 10),
                  Text(
                    isEmergencyActive.value
                        ? 'EMERGENCY ACTIVE'
                        : 'No Active Emergency',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),
                  ValueListenableBuilder<bool>(
                    valueListenable: isEmergencyActive,
                    builder: (context, emergencyActive, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            emergencyActive
                                ? 'Ambulance needs route clearance.'
                                : 'No emergency alerts right now.',
                          ),
                          if (emergencyActive &&
                              activeEmergencyHospital.value != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              'Destination: ${activeEmergencyHospital.value}',
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Ambulance Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ListTile(
              leading: const Icon(Icons.local_hospital, color: Colors.red),
              title: const Text('Destination Hospital'),
              subtitle: ValueListenableBuilder<bool>(
                valueListenable: isEmergencyActive,
                builder: (context, emergencyActive, child) {
                  return Text(
                    emergencyActive && activeEmergencyHospital.value != null
                        ? activeEmergencyHospital.value!
                        : 'No hospital selected',
                  );
                },
              ),
            ),

            const ListTile(
              leading: Icon(Icons.location_on, color: Colors.blue),
              title: Text('Ambulance Location'),
              subtitle: Text('GPS tracking not connected yet'),
            ),

            ListTile(
              leading: const Icon(Icons.route, color: Colors.blue),
              title: const Text('Route Clearance'),
              subtitle: ValueListenableBuilder<bool>(
                valueListenable: isEmergencyActive,
                builder: (context, emergencyActive, child) {
                  return Text(
                    emergencyActive
                        ? 'Emergency route clearance required.'
                        : 'No active route clearance request.',
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 55, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'Traffic Route Map',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Map will be connected later'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
