import 'package:hs_socket/src/sockets/enum_packet_direction.dart';
import 'package:hs_socket/src/sockets/enum_packet_type.dart';

class DataPacket {
  String get from => _data['header']['from'] ?? '';
  String get to => _data['header']['to'] ?? '';
  PacketType get type => PacketType.none.fromName(_data['header']['packetType'] ?? 'none');
  PacketDirection get direction => PacketDirection.none.fromName(_data['header']['packetDirection'] ?? 'none');
  Map<String, dynamic> get rawData => _data;

  Map<String, dynamic> _data = 
  {
    "header" : {
      "from" : "",
      "to" : "",
      "packetType" : "none",
      "packetDirection" : "none"
    },
    "payload" : {}
  };

  Map<String, dynamic> get payLoad => _data['payload'] ?? {};
  
  DataPacket.create(Map<String, dynamic> data) : _data = data;

  DataPacket(PacketType type, PacketDirection direction, Map<String, dynamic> payload) {
    _data['payload'] = payload;
    _data['header']['packetType'] = type.name; 
    _data['header']['packetDirection'] = direction.name;
  }

  void update({String? from, String? to}) {
    _data['header']['from'] = from ?? '';
    _data['header']['to'] = to ?? '';
  }

}