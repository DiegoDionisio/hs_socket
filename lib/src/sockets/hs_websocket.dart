import 'dart:convert';
import 'package:hs_socket/src/events/event.dart';
import 'package:hs_socket/src/events/event1.dart';
import 'package:hs_socket/src/sockets/data_packet.dart';
import 'package:hs_socket/src/sockets/enum_packet_direction.dart';
import 'package:hs_socket/src/sockets/enum_packet_type.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HsWebsocket {

  String _serverId = '';
  String get serverId => _serverId;

  String _authId = '';
  String get authId => _authId;

  bool _isServer = false;
  bool get isServer => _isServer;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  bool _isAutheticated = false;
  bool get isAuthenticated => _isConnected;

  WebSocketChannel? _socket;

  HsWebsocket();

  Event onConnect     = Event();
  Event onDisconnect  = Event();

  Event1<DataPacket> onPacket = Event1();
  Event1<Map<String, dynamic>> onCommandRequest   = Event1();
  Event1<Map<String, dynamic>> onCommandResponse  = Event1();

  Event1<List<int>> onBinary  = Event1();
  
  Future<bool> connect(Uri host) async {
    _socket = WebSocketChannel.connect(host);
    await _socket?.ready;
    _listen();
    return true;
  }

  Future<HsWebsocket> accept(WebSocketChannel channel, String serverId) async {
    _serverId = serverId;
    _socket   = channel; 
    _listen();
    return this;   
  }

  void _listen() {
    _isConnected = true;
    _socket?.stream.listen((data) {
      if(data is List<int>) {
        _onBinaryReceived(data);
      } else {
        var rawData = jsonDecode(data);
        var packet = DataPacket.create(rawData);
        _onPacketReceived(packet);
      }
    },
    onDone: () {
      disconnect();
    },
    onError: (error) {
      disconnect();
    });
    onConnect.call();
  }

  void disconnect() {
    _isConnected = false;
    try {
      _socket?.sink.close();
      _socket = null;
    } catch (e) {
      _log('$e');
    }
    onDisconnect.call();
  }

  void _log(String text) {
    print(text);
  }

  Future<void> _onPacketReceived(DataPacket packet) async {
    onPacket.call(packet);
    if(packet.type == PacketType.command) {
      if(packet.direction == PacketDirection.request) {
        onCommandRequest.call(packet.payLoad);
      } else if(packet.direction == PacketDirection.response) {
        onCommandResponse.call(packet.payLoad);
      }
    }
  }

  Future<void> _onBinaryReceived(List<int> data) async {
    _onBinaryReceived(data);
  }

  Future<void> sendCommand(String command, Map<String, dynamic> payload) async {
    var packet = DataPacket(PacketType.command, PacketDirection.request, {
      "commandType" : command,
      "command" : payload
    }); 
    sendPacket(packet);
  }

  Future<void> sendCommandTo(String to, String command,  Map<String, dynamic> payload) async {
    var packet = DataPacket(PacketType.command, PacketDirection.request, {
      "commandType" : command,
      "command" : payload
    });
    packet.update(from: serverId, to: to);
    sendPacket(packet);
  }

  Future<void> sendPacket(DataPacket packet) async {
    _socket?.sink.add(jsonEncode(packet.rawData));
  }
  
}