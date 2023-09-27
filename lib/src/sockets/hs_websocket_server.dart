import 'dart:convert';
import 'package:hs_socket/hs_socket.dart';
import 'package:hs_socket/src/events/event1.dart';
import 'package:hs_socket/src/events/event2.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HsWebsocketServer {
  String get newClientId => Uuid().v4();
  Map<String, HsWebsocket> _clients = {};
  Map<String, HsWebsocket> get clients => _clients;

  Event2<HsWebsocket, DataPacket> onClientPacket  = Event2();
  Event1<HsWebsocket> onClientDisconnected        = Event1();
  Event1<HsWebsocket> onClientConnected           = Event1();

  Future<void> accept(WebSocketChannel channel) async {
    String newId = newClientId;
    var newClient = await HsWebsocket().accept(channel, newId);
    print('Novo Cliente: ${newId}');
    _addClient(newClient);
  }

  void _addClient(HsWebsocket client) {
    _clients.addAll({client.serverId : client});
    // print('Cliente ${client.serverId} adicionado a lista de clientes');
    _attachClientEvents(client.serverId, client);
    print('Total de Clientes: ${clients.length}');
    client.sendCommand('initialInfo', {"clientId" : client.serverId});
  }

  Future<void> _sendUsersOnline() async {
     List<Map<String, dynamic>> _users = [];
    _clients.forEach((key, value) {
      _users.add({key : value.userName});
    });
    if(_users.isNotEmpty) {
      for(var user in _clients.entries) {
        if(user.value.isConnected) {
          print('Enviando UsersOnline para ${user.value.serverId}');
          user.value.sendCommand('listUsersOnline', {"usersList" : _users});
        }
      }
    }    
  } 

  void _attachClientEvents(String clientId, HsWebsocket client) {
    client.onDisconnect +=() {
      onClientDisconnected.call(client);
      print('Cliente ${client.serverId} desconectado');
      _removeClient(clientId);
    };

    client.onPacket += (DataPacket packet) {
      if(packet.type == PacketType.command) {
        String command = packet.payLoad['commandType'] ?? 'none';
        print('Client Command: ${packet.payLoad}');
        if(packet.from.isNotEmpty && packet.to.isNotEmpty) {
          _bridgePacket(client, packet);
        } else if(command == 'setUserName'&& packet.payLoad['command'].containsKey('userName')) {
          String? userName = packet.payLoad['command']['userName'] ?? '';
          print('Client Name: $userName (${client.serverId})');
          if(userName!.startsWith('user_')) {
            client.sendCommand('userKick', {
              'message' : 'Você precisa estar logado para usar a ferramenta de suporte.'
            });
          } else {
            client.update(userName: userName);
            _sendUsersOnline();
          }
        }
      }
      onClientPacket.call(client, packet);    
      
    };
  }

  Future<void> _bridgePacket(HsWebsocket clientFrom, DataPacket packet) async {
    if(packet.to.isNotEmpty) {     
      var clientTo = _getClientById(packet.to);
      if(clientTo != null) {
        var newPacket = DataPacket.create(packet.rawData);
        newPacket.update(from: clientFrom.serverId, to: clientTo.serverId);
        clientTo.sendPacket(packet);
        
      } else {
        print('@@@@@@@@@@@@@@@@@@@ CLIENT TO NÃO ENCONTRADO -> ${packet.to}');
      }      
    } else {
      print('@@@@@@@@@@@@@@@@@@@ PACKET.TO VAZIO -> ${packet.to}');
    } 
    print('------------------------------------------------------');   
  }

  void _removeClient(String clientId) async {   
    _clients.removeWhere((key, value) => key == clientId);
    print('Total de Clientes: ${clients.length}');
    _sendUsersOnline();
  }
  
  HsWebsocket? _getClient(HsWebsocket client) {
    return _clients[client.serverId];
  }

  HsWebsocket? _getClientById(String clientId) {
    return _clients[clientId];
  }

}