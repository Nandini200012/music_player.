// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourites.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class favouritesAdapter extends TypeAdapter<favourites> {
  @override
  final int typeId = 3;

  @override
  favourites read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return favourites(
      songname: fields[0] as String?,
      duration: fields[1] as int?,
      songurl: fields[2] as String?,
      id: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, favourites obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.songname)
      ..writeByte(1)
      ..write(obj.duration)
      ..writeByte(2)
      ..write(obj.songurl)
      ..writeByte(3)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is favouritesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
