import 'package:hive/hive.dart';

part 'sync_request.g.dart';

@HiveType(typeId: 0)
class SyncRequest extends HiveObject {
  @HiveField(0)
  final String collection;

  @HiveField(1)
  final String? documentId;

  @HiveField(2)
  final Map<String, dynamic> data;

  @HiveField(3)
  final String action; // 'create', 'update', 'delete', 'set'

  @HiveField(4)
  final DateTime timestamp;

  SyncRequest({
    required this.collection,
    this.documentId,
    required this.data,
    required this.action,
    required this.timestamp,
  });
}
