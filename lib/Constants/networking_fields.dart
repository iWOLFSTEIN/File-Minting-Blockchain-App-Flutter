import 'package:file_minting_app/Constants/private_keys.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

Client httpClient = Client();
Web3Client ethClient = Web3Client(url, httpClient, socketConnector: () {
  return IOWebSocketChannel.connect(socketUrl).cast<String>();
});
