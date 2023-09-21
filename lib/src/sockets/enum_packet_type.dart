enum PacketType {
  none(0),
  command(101);

  final int code;
  const PacketType(this.code);

  PacketType fromName(String name) => PacketType.values
    .firstWhere((e) => e.name.toLowerCase() == name.toLowerCase(), orElse: () => PacketType.none);
}