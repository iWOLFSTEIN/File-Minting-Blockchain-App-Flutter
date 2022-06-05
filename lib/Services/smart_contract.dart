import 'package:file_minting_app/Constants/private_keys.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

import '../Constants/networking_fields.dart';

Future<DeployedContract> loadcContract() async {
  String abi = await rootBundle.loadString("assets/.abi.json");
  final contract = DeployedContract(ContractAbi.fromJson(abi, "FileMinter"),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<List<dynamic>> query(
  String functionName,
  List<dynamic> args,
) async {
  final contract = await loadcContract();
  final ethFunction = contract.function(functionName);

  final result = await ethClient.call(
      contract: contract, function: ethFunction, params: args);
  return result;
}

query_transaction(String functionName, List<dynamic> args,
    {credentials}) async {
  final contract = await loadcContract();
  final ethFunction = contract.function(functionName);
  final result = await ethClient.sendTransaction(
    credentials,
    Transaction.callContract(
      // from: ownAddress,
      contract: contract,
      function: ethFunction,
      parameters: args,
      // gasPrice: EtherAmount.inWei(BigInt.one),
      // maxGas: 100000,
      // value: EtherAmount.fromUnitAndValue(EtherUnit.ether, 1),
    ),
    chainId: 4,
  );
  return result;
}

getBalance({required ethClient}) async {
  var credentials = await ethClient.credentialsFromPrivateKey(privateKey);
  EtherAmount balance = await ethClient.getBalance(credentials.address);
  return balance.getValueInUnit(EtherUnit.ether);
}
