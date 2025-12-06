import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wasslni_plus/models/parcel_model.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class CourierRouteMap extends StatefulWidget {
  final List<ParcelModel> parcels;

  const CourierRouteMap({
    super.key,
    required this.parcels,
  });

  @override
  State<CourierRouteMap> createState() => _CourierRouteMapState();
}

class _CourierRouteMapState extends State<CourierRouteMap> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  Position? _currentPosition;
  bool _isLoadingLocation = true;
  bool _showRoute = false;
  final Set<Polyline> _polylines = {};

  // Default location (Jerusalem)
  static const LatLng _defaultLocation = LatLng(31.7683, 35.2137);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _createMarkersForParcels();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      // Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      // Add current location marker
      _addCurrentLocationMarker();

      // Move camera to current location
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          13.0,
        ),
      );
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      debugPrint('Error getting location: $e');
    }
  }

  void _addCurrentLocationMarker() {
    if (_currentPosition == null) return;

    final marker = Marker(
      markerId: const MarkerId('current_location'),
      position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: InfoWindow(
        title: S.of(context).current_location,
      ),
    );

    setState(() {
      _markers.add(marker);
    });
  }

  Future<void> _createMarkersForParcels() async {
    final markers = <Marker>{};

    for (int i = 0; i < widget.parcels.length; i++) {
      final parcel = widget.parcels[i];

      // Try to geocode the address
      LatLng? location;
      try {
        // Parse address to get coordinates
        // Note: For production, you should store lat/lng in Firestore
        // This is a fallback that tries to geocode the address
        final addresses = await geocoding.locationFromAddress(
          '${parcel.deliveryAddress}, Palestine',
        );

        if (addresses.isNotEmpty) {
          location =
              LatLng(addresses.first.latitude, addresses.first.longitude);
        }
      } catch (e) {
        debugPrint('Error geocoding address: $e');
        // Use default location with slight offset for each parcel
        location = LatLng(
          _defaultLocation.latitude + (i * 0.01),
          _defaultLocation.longitude + (i * 0.01),
        );
      }

      if (location != null) {
        final marker = Marker(
          markerId: MarkerId(parcel.id ?? 'parcel_$i'),
          position: location,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _getMarkerColor(parcel.status),
          ),
          infoWindow: InfoWindow(
            title: '#${parcel.barcode}',
            snippet: '${parcel.recipientName}\n${parcel.deliveryAddress}',
          ),
          onTap: () => _onMarkerTapped(parcel),
        );

        markers.add(marker);
      }
    }

    setState(() {
      _markers.addAll(markers);
    });
  }

  double _getMarkerColor(ParcelStatus status) {
    switch (status) {
      case ParcelStatus.delivered:
        return BitmapDescriptor.hueGreen;
      case ParcelStatus.outForDelivery:
      case ParcelStatus.enRouteDistributor:
        return BitmapDescriptor.hueOrange;
      case ParcelStatus.returned:
      case ParcelStatus.cancelled:
        return BitmapDescriptor.hueRed;
      default:
        return BitmapDescriptor.hueYellow;
    }
  }

  void _onMarkerTapped(ParcelModel parcel) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildParcelDetailsSheet(parcel),
    );
  }

  Widget _buildParcelDetailsSheet(ParcelModel parcel) {
    final tr = S.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '#${parcel.barcode}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(parcel.status).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(parcel.status, tr),
                  style: TextStyle(
                    color: _getStatusColor(parcel.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.person, tr.recipient, parcel.recipientName),
          _buildInfoRow(Icons.phone, tr.phone_number, parcel.recipientPhone),
          _buildInfoRow(Icons.location_on, tr.address, parcel.deliveryAddress),
          _buildInfoRow(Icons.attach_money, tr.delivery_fee,
              '₪${parcel.deliveryFee.toStringAsFixed(2)}'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _openNavigation(parcel);
              },
              icon: const Icon(Icons.navigation),
              label: Text(tr.navigate),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyles.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openNavigation(ParcelModel parcel) {
    // In production, this should open Google Maps or Waze
    // For now, we'll just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${S.of(context).navigate} to ${parcel.deliveryAddress}'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  Color _getStatusColor(ParcelStatus status) {
    switch (status) {
      case ParcelStatus.awaitingLabel:
      case ParcelStatus.readyToShip:
        return Colors.orange;
      case ParcelStatus.atWarehouse:
        return Colors.blue;
      case ParcelStatus.outForDelivery:
      case ParcelStatus.enRouteDistributor:
        return AppStyles.primaryColor;
      case ParcelStatus.delivered:
        return Colors.green;
      case ParcelStatus.returned:
        return Colors.red;
      case ParcelStatus.cancelled:
        return Colors.grey;
    }
  }

  String _getStatusText(ParcelStatus status, S tr) {
    switch (status) {
      case ParcelStatus.awaitingLabel:
        return 'Awaiting Label';
      case ParcelStatus.readyToShip:
        return tr.pending_pickup;
      case ParcelStatus.atWarehouse:
        return 'At Warehouse';
      case ParcelStatus.outForDelivery:
      case ParcelStatus.enRouteDistributor:
        return tr.in_transit;
      case ParcelStatus.delivered:
        return tr.completed;
      case ParcelStatus.returned:
        return 'Returned';
      case ParcelStatus.cancelled:
        return 'Cancelled';
    }
  }

  void _toggleRoute() {
    setState(() {
      _showRoute = !_showRoute;
      if (_showRoute) {
        _createRoute();
      } else {
        _polylines.clear();
      }
    });
  }

  void _createRoute() {
    if (_currentPosition == null || widget.parcels.isEmpty) return;

    // Create a simple route connecting all delivery points
    // In production, you would use Google Directions API
    final points = <LatLng>[
      LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
    ];

    // Add all parcel locations (using default locations for demo)
    for (int i = 0; i < widget.parcels.length; i++) {
      points.add(LatLng(
        _defaultLocation.latitude + (i * 0.01),
        _defaultLocation.longitude + (i * 0.01),
      ));
    }

    final polyline = Polyline(
      polylineId: const PolylineId('delivery_route'),
      points: points,
      color: AppStyles.primaryColor,
      width: 4,
      patterns: [PatternItem.dash(20), PatternItem.gap(10)],
    );

    setState(() {
      _polylines.add(polyline);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.route_map),
        backgroundColor: AppStyles.primaryColor,
        actions: [
          IconButton(
            icon: Icon(_showRoute ? Icons.layers_clear : Icons.layers),
            tooltip: _showRoute ? tr.hide_route : tr.show_route,
            onPressed: _toggleRoute,
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: tr.current_location,
            onPressed: () {
              if (_currentPosition != null) {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(_currentPosition!.latitude,
                        _currentPosition!.longitude),
                    14.0,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition != null
                  ? LatLng(
                      _currentPosition!.latitude, _currentPosition!.longitude)
                  : _defaultLocation,
              zoom: 12.0,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: false,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          if (_isLoadingLocation)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      Icons.local_shipping,
                      tr.delivery_points,
                      widget.parcels.length.toString(),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                    _buildStatItem(
                      Icons.check_circle,
                      tr.completed,
                      widget.parcels
                          .where((p) => p.status == ParcelStatus.delivered)
                          .length
                          .toString(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppStyles.primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
