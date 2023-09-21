import 'dart:convert';

import 'package:hs_socket/src/events/event1.dart';
import 'package:hs_socket/src/events/event2.dart';
import 'package:hs_socket/src/sockets/data_packet.dart';
import 'package:hs_socket/src/sockets/hs_websocket.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HsWebsocketServer {
  String get newClientId => Uuid().v4();
  Map<String, HsWebsocket> _clients = {};

  Event2<HsWebsocket, DataPacket> onClientPacket  = Event2();
  Event1<HsWebsocket> onClientDisconnected        = Event1();
  Event1<HsWebsocket> onClientConnected           = Event1();

  Future<void> accept(WebSocketChannel channel) async {
    var newClient = await HsWebsocket().accept(channel, newClientId);
    print('Novo Cliente: ${newClientId}');
    _addClient(newClient);
  }

  void _addClient(HsWebsocket client) {
    _clients.addAll({client.serverId : client});
    print('Cliente ${client.serverId} adiiconado a lista de clientes');
    _attachClientEvents(client.serverId, client);
  }

  void _attachClientEvents(String clientId, HsWebsocket client) {
    client.onDisconnect +=() {
      onClientDisconnected.call(client);
      print('Cliente ${client.serverId} desconectado');
      _removeClient(clientId);
    };

    client.onPacket += (DataPacket packet) {
      onClientPacket.call(client, packet);
      print('------------------------------------------------------');
      if(packet.from.isNotEmpty && packet.to.isNotEmpty) {
        print('Cliente ${client.serverId}: Recebeu um pacote do cliente: ${packet.from}');
      } else {
        print('Cliente ${client.serverId}: Recebeu um pacote: ');
      }
      print(JsonEncoder.withIndent('  ').convert(packet.payLoad));
      print('------------------------------------------------------');
      if(packet.to.isNotEmpty) {
        var clientTo = _getClientById(packet.to);
        if(clientTo != null) {
          var newPacket = DataPacket.create(packet.rawData);
          newPacket.update(from: client.serverId, to: clientTo.serverId);
          clientTo.sendPacket(packet);
        }
        
      }
    };
  }

  void _removeClient(String clientId) async {   
    print('Cliente $clientId removido da lista de clientes');
    _clients.removeWhere((key, value) => key == clientId);
  }
  
  HsWebsocket? _getClient(HsWebsocket client) {
    return _clients[client.serverId];
  }

  HsWebsocket? _getClientById(String clientId) {
    return _clients[clientId];
  }

}