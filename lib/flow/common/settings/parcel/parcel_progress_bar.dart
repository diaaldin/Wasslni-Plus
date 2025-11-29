import 'package:flutter/material.dart';

class ParcelProgressBar extends StatelessWidget {
  final String currentStatus;
  final String? returnReason;

  ParcelProgressBar({
    super.key,
    required this.currentStatus,
    this.returnReason,
  });

  final List<Map<String, dynamic>> packagingStages = [
    {'label': 'بانتظار الملصق', 'icon': Icons.qr_code_2_outlined},
    {'label': 'جاهز للارسال', 'icon': Icons.inventory_2_outlined},
    {'label': 'في الطريق للموزع', 'icon': Icons.local_shipping_outlined},
  ];

  final List<Map<String, dynamic>> deliveryStages = [
    {'label': 'مخزن الموزع', 'icon': Icons.store_outlined},
    {'label': 'في الطريق للزبون', 'icon': Icons.delivery_dining_outlined},
    {'label': 'تم التوصيل', 'icon': Icons.check_circle_outline},
  ];

  final Map<String, dynamic> returnStage = {
    'label': 'طرد راجع',
    'icon': Icons.undo_outlined,
  };

  bool get isReturned => currentStatus == 'طرد راجع';

  Widget buildStageRow(List<Map<String, dynamic>> stages, int currentIndex) {
    return Row(
      children: List.generate(stages.length * 2 - 1, (index) {
        if (index.isEven) {
          final stage = stages[index ~/ 2];
          final isCompleted = index ~/ 2 <= currentIndex;
          return Column(
            children: [
              Icon(
                stage['icon'],
                color: isCompleted ? Colors.green : Colors.grey.shade400,
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 60,
                child: Text(
                  stage['label'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: isCompleted ? Colors.black : Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          );
        } else {
          final isActive = (index ~/ 2) < currentIndex;
          return Container(
            width: 30,
            height: 2,
            color: isActive ? Colors.green : Colors.grey.shade300,
          );
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isReturned) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          const Icon(Icons.undo_outlined, size: 36, color: Colors.red),
          const SizedBox(height: 6),
          const Text(
            'هذا الطرد تم إرجاعه',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          if (returnReason != null && returnReason!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'السبب: $returnReason',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ],
        ],
      );
    }

    final allStages = [...packagingStages, ...deliveryStages];
    final currentIndex =
        allStages.indexWhere((stage) => stage['label'] == currentStatus);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('تحضير وتوصيل الطرد:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Divider(thickness: 1.2),
          const SizedBox(height: 12),
          buildStageRow(packagingStages, currentIndex),
          const SizedBox(height: 12),
          const Divider(thickness: 1.2),
          const SizedBox(height: 12),
          buildStageRow(deliveryStages, currentIndex - packagingStages.length),
        ],
      ),
    );
  }
}
