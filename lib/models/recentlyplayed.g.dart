// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recentlyplayed.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentlyPlayedAdapter extends TypeAdapter<RecentlyPlayed> {
  @override
  final int typeId = 2;

  @override
  RecentlyPlayed read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentlyPlayed(
      songname: fields[0] as String?,
      duration: fields[1] as int?,
      songurl: fields[2] as String?,
      id: fields[3] as int?,
      index: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, RecentlyPlayed obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.songname)
      ..writeByte(1)
      ..write(obj.duration)
      ..writeByte(2)
      ..write(obj.songurl)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentlyPlayedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
