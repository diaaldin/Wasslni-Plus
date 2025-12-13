// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_request.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncRequestAdapter extends TypeAdapter<SyncRequest> {
  @override
  final int typeId = 0;

  @override
  SyncRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncRequest(
      collection: fields[0] as String,
      documentId: fields[1] as String?,
      data: (fields[2] as Map).cast<String, dynamic>(),
      action: fields[3] as String,
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SyncRequest obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.collection)
      ..writeByte(1)
      ..write(obj.documentId)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.action)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
