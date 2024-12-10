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

  Future<String> buyTokens(String privateKey, double amount, String currency) async {
  final contract = await getContract();
  final function = contract.function('buyTokens');

  BigInt amountInWei;
  if (currency == 'USD') {
    double usdToEtherRate = 0.0006;
    amountInWei = BigInt.from(amount / usdToEtherRate * 1e18);
  } else if (currency == 'HNL') {
    double hnlToEtherRate = 0.000024;
    amountInWei = BigInt.from(amount / hnlToEtherRate * 1e18);
  } else {
    throw Exception('Moneda no soportada');
  }

  final credentials = EthPrivateKey.fromHex(privateKey);

  final transactionHash = await _client.sendTransaction(
    credentials,
    Transaction.callContract(
      contract: contract,
      function: function,
      parameters: [],
      value: EtherAmount.inWei(amountInWei),
    ),
    chainId: 421614,
  );

  return transactionHash; 
}


}
