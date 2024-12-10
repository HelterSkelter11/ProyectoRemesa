import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'abi_loader.dart';

class InfuraApi {
  final String _infuraUrl;
  final String _contractAddress;

  late Web3Client _client;

  InfuraApi(this._infuraUrl, this._contractAddress);

  Future<void> connect() async {
    _client = Web3Client(_infuraUrl, Client());
  }

  Future<DeployedContract> getContract() async {
    final abi = await loadAbiFromAssets();
    final contract = DeployedContract(
      ContractAbi.fromJson(abi, 'Remesas'),
      EthereumAddress.fromHex(_contractAddress),
    );
    return contract;
  }

  Future<String> getChainId() async {
    final chainId = await _client.getChainId();
    return chainId.toString();
  }

  Future<String> getBalance(String address) async {
    EtherAmount balance = await _client.getBalance(EthereumAddress.fromHex(address));

    BigInt balanceInWei = balance.getInWei;
    return balanceInWei.toString();
  }

  Future<void> buyTokens(String privateKey) async {
  final contract = await getContract();
  final function = contract.function('buyTokens');

  final credentials = EthPrivateKey.fromHex(privateKey);

  await _client.sendTransaction(
    credentials,
    Transaction.callContract(
      contract: contract,
      function: function,
      parameters: [],
    ),
    chainId: 42161,
  );

  //probando cosas aqui,
  //hacer aqui las interacciones y enviarlas a las api porque de ahi se saca la informacion
}
}
