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

  bool isValidPrivateKey(String privateKey) {
  try {
    final credentials = EthPrivateKey.fromHex(privateKey);
    final address = credentials.address.hex;

    print("Clave privada válida. Dirección: $address");
    return true;
  } catch (e) {
    print("Clave privada no válida: $e");
    return false;
  }
}

  Future<String> getChainId() async {
    final chainId = await _client.getChainId();
    return chainId.toString();
  }

Future<BigInt> checkBalance(String address) async {
  final contract = await getContract();
  final function = contract.function('checkBalance');

  final result = await _client.call(
    contract: contract,
    function: function,
    params: [],
    sender: EthereumAddress.fromHex(address),
  );

  return result[0] as BigInt;
}


  Future<String> buyTokens(String privateKey, double amount, String currency) async {
    final contract = await getContract();

    String functionName;
    BigInt amountToSend;

    if (currency == 'USD') {
      functionName = 'buyTokensWithUSD';
      amountToSend = BigInt.from(amount);
    } else if (currency == 'HNL') {
      functionName = 'buyTokensWithLempiras';
      amountToSend = BigInt.from(amount);
    } else {
      throw Exception('Moneda no soportada');
    }

    final function = contract.function(functionName);
    final credentials = EthPrivateKey.fromHex(privateKey);

    EtherAmount value;
    List<dynamic> parameters;

    if (currency == 'USD') {
      value = EtherAmount.fromBigInt(EtherUnit.wei, amountToSend);
      parameters = [];
    } else {
      value = EtherAmount.zero();
      parameters = [amountToSend];
    }

    final transactionHash = await _client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: parameters,
        value: value,
      ),
      chainId: 421614,
    );
    return transactionHash;
  }

  Future<String> transferTokens(String privateKey, String recipientAddress, int tokenAmount) async {
    final contract = await getContract();
    final function = contract.function('transferTokens');

    final EthereumAddress to = EthereumAddress.fromHex(recipientAddress);
    final BigInt amount = BigInt.from(tokenAmount);

    final credentials = EthPrivateKey.fromHex(privateKey);

    final transactionHash = await _client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [to, amount],
      ),
      chainId: 421614,
    );

    return transactionHash;
  }

  Future<String> exchangeTokensForLempiras(String privateKey, BigInt tokenAmount) async {
    final contract = await getContract();
    final function = contract.function('exchangeTokensForLempiras');

    final credentials = EthPrivateKey.fromHex(privateKey);

    final transactionHash = await _client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [tokenAmount],
      ),
      chainId: 421614,
    );

    return transactionHash;
  }

    Future<String> exchangeTokensForUSD(String privateKey, BigInt tokenAmount) async {
    final contract = await getContract();
    final function = contract.function('exchangeTokensForUSD');

    final credentials = EthPrivateKey.fromHex(privateKey);

    final transactionHash = await _client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [tokenAmount],
      ),
      chainId: 421614,
    );

    return transactionHash;
  }
}
