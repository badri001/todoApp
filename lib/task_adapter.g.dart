// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapterAdapter extends TypeAdapter<TaskAdapter> {
  @override
  final int typeId = 0;

  @override
  TaskAdapter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskAdapter(
      title: fields[0] as String?,
      completed: fields[1] as bool?,
      subTasks: (fields[2] as List).cast<String?>(),
      isDone: (fields[3] as List).cast<bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, TaskAdapter obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.completed)
      ..writeByte(2)
      ..write(obj.subTasks)
      ..writeByte(3)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
