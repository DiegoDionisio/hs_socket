enum PacketDirection {
  none(0),
  request(101),
  response(102);

  final int code;
  const PacketDirection(this.code);

  PacketDirection fromName(String name) => PacketDirection.values
    .firstWhere((e) => e.name.toLowerCase() == name.toLowerCase(), orElse: () => PacketDirection.none);
}