import 'package:flutter/material.dart';
import 'package:wasslni_plus/models/user/user_model.dart';
import 'package:wasslni_plus/services/firestore_service.dart';
import 'package:wasslni_plus/generated/l10n.dart';

class AssignCourierDialog extends StatefulWidget {
  final String parcelId;

  const AssignCourierDialog({super.key, required this.parcelId});

  @override
  State<AssignCourierDialog> createState() => _AssignCourierDialogState();
}

class _AssignCourierDialogState extends State<AssignCourierDialog> {
  final _firestoreService = FirestoreService();
  final _searchController = TextEditingController();
  List<UserModel> _couriers = [];
  List<UserModel> _filteredCouriers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCouriers();
  }

  Future<void> _fetchCouriers() async {
    try {
      final couriers = await _firestoreService.getUsersByRole('courier');
      if (mounted) {
        setState(() {
          _couriers = couriers;
          _filteredCouriers = couriers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading couriers: $e')),
        );
      }
    }
  }

  void _filterCouriers(String query) {
    setState(() {
      _filteredCouriers = _couriers
          .where((courier) =>
              courier.name.toLowerCase().contains(query.toLowerCase()) ||
              courier.phoneNumber.contains(query))
          .toList();
    });
  }

  Future<void> _assignCourier(UserModel courier) async {
    final tr = S.of(context);
    try {
      if (courier.uid != null) {
        await _firestoreService.assignCourierToParcel(
            widget.parcelId, courier.uid!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr.courier_assigned_success)),
          );
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${tr.error}: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return AlertDialog(
      title: Text(tr.assign_courier),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: tr.general_serach_hint,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: _filterCouriers,
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_filteredCouriers.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(tr.no_couriers_found),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredCouriers.length,
                  itemBuilder: (context, index) {
                    final courier = _filteredCouriers[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundImage: (courier.profilePhotoUrl != null &&
                                courier.profilePhotoUrl!.isNotEmpty)
                            ? NetworkImage(courier.profilePhotoUrl!)
                            : null,
                        child: (courier.profilePhotoUrl == null ||
                                courier.profilePhotoUrl!.isEmpty)
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(courier.name),
                      subtitle: Text(courier.phoneNumber),
                      trailing: TextButton(
                        onPressed: () => _assignCourier(courier),
                        child: Text(tr.update), // Or 'Assign' if added
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(tr.cancel),
        ),
      ],
    );
  }
}
