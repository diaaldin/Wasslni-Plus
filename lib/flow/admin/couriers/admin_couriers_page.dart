import 'package:flutter/material.dart';
import 'package:wasslni_plus/app_styles.dart';
import 'package:wasslni_plus/generated/l10n.dart';
import 'package:wasslni_plus/models/user/user_model.dart';
import 'package:wasslni_plus/models/user/consts.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/flow/admin/couriers/courier_performance_page.dart';

class AdminCouriersPage extends StatefulWidget {
  const AdminCouriersPage({super.key});

  @override
  State<AdminCouriersPage> createState() => _AdminCouriersPageState();
}

class _AdminCouriersPageState extends State<AdminCouriersPage> {
  final FirestoreService _firestoreService = FirestoreService();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.couriers),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: tr.general_serach_hint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: _firestoreService.streamUsersByRole(UserRole.courier.name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('${tr.error}: ${snapshot.error}'));
          }

          final couriers = snapshot.data ?? [];

          final filteredCouriers = couriers.where((c) {
            final q = _searchQuery.toLowerCase();
            return c.name.toLowerCase().contains(q) ||
                (c.phoneNumber.contains(q));
          }).toList();

          if (filteredCouriers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    tr.no_couriers_found,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: filteredCouriers.length,
            separatorBuilder: (c, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final courier = filteredCouriers[index];
              return _buildCourierCard(context, courier);
            },
          );
        },
      ),
    );
  }

  Widget _buildCourierCard(BuildContext context, UserModel courier) {
    final tr = S.of(context);
    final isOnline =
        courier.availability == true; // Assuming availability field
    final isActive = courier.status == UserStatus.active;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: AppStyles.primaryColor.withOpacity(0.1),
              backgroundImage: (courier.profilePhotoUrl != null &&
                      courier.profilePhotoUrl!.isNotEmpty)
                  ? NetworkImage(courier.profilePhotoUrl!)
                  : null,
              child: (courier.profilePhotoUrl == null ||
                      courier.profilePhotoUrl!.isEmpty)
                  ? const Icon(Icons.person, color: AppStyles.primaryColor)
                  : null,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isOnline ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          courier.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(courier.phoneNumber),
            if (courier.vehicleType != null)
              Text(
                '${courier.vehicleType} - ${courier.vehiclePlate ?? ""}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isActive
                ? tr.active
                : tr.inactive, // Assuming inactive key exists, or use blocked
            style: TextStyle(
              color: isActive ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        onTap: () {
          // TODO: Navigate to details or show actions
          _showCourierActions(context, courier);
        },
      ),
    );
  }

  void _showCourierActions(BuildContext context, UserModel courier) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CourierPerformancePage(courier: courier),
      ),
    );
  }
}
