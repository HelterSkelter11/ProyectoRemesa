import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'abi_loader.dart';

class InfuraApi {
  final String _infuraUrl;
  final String _contractAddress;

  late Web3Client _client;

  InfuraApi(this._infuraUrl, this._contractAddress) {
    connect();
  }

  Future<void> connect() async {
    _client = Web3Client(_infuraUrl, Client());
  }

  Future<DeployedContract> getContract() async {
    print('object');
    final abi = await loadAbiFromAssets();
    print('objectasdad');
    try {
      final contract = DeployedContract(
        ContractAbi.fromJson(abi, 'Remesas'),
        EthereumAddress.fromHex(_contractAddress),
      );
      print('fin object');
      return contract;
    } catch (e) {
      print("Error al crear el contrato: $e");
    }
    print('asdasd');
    throw Exception('No se que poner aqui');
  }

  Future<void> getBalance(String address) async {
    final EthereumAddress userAddress = EthereumAddress.fromHex(address);
    final contract = await getContract();
    final function = contract.function('checkBalance');

    final result = await _client.call(
      contract: contract,
      function: function,
      params: [userAddress],
    );

    print('BALANCEEEE');
    print('Balance: ${result[0]} tokens');
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
    print(chainId.toString());
    return chainId.toString();
  }

  Future<BigInt> checkBalance(String address) async {
    try {
      print('Consultando balance...');

      // Convertir la dirección al formato EthereumAddress
      final EthereumAddress ethereumAddress = EthereumAddress.fromHex(address);
      print(address);
      print(ethereumAddress);

      // Obtener el contrato
      final contract = await getContract();
      final function = contract.function('checkBalance');

      // Llamar a la función del contrato con la dirección Ethereum
      print('lelga aqui pero no fnca');
      final result = await _client.call(
        contract: contract,
        function: function,
        params: [ethereumAddress], // Aquí usamos ethereumAddress
      );
      print('lelga aqui pero no fnca pt2');

      // Verificar el resultado y retornar el balance
      if (result.isNotEmpty && result[0] is BigInt) {
        print(result);
        return result[0] as BigInt;
      } else {
        throw Exception('Error al obtener el balance.');
      }
    } catch (error) {
      print(error);
    }
    throw Exception('no funca aqio');
  }

  Future<String> buyTokens(
      String privateKey, double amount, String currency) async {
    try {
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
        chainId: 11155111,
      );
      print(transactionHash);
      return transactionHash;
    } catch (e) {
      throw Exception('Me quede sin pisto');
    }
  }

  Future<String> transferTokens(
      String privateKey, String recipientAddress, BigInt tokenAmount) async {
    final contract = await getContract();
    final function = contract.function('transferTokens');

    final EthereumAddress to = EthereumAddress.fromHex(recipientAddress);

    final credentials = EthPrivateKey.fromHex(privateKey);

    final transactionHash = await _client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [to, tokenAmount],
      ),
      chainId: 11155111,
    );

    print('Transaction Hash: $transactionHash');
    return transactionHash;
  }

  Future<String> exchangeTokensForLempiras(
      String privateKey, BigInt tokenAmount) async {
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
      chainId: 11155111,
    );

    return transactionHash;
  }

  Future<String> exchangeTokensForUSD(
      String privateKey, BigInt tokenAmount) async {
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
      chainId: 11155111,
    );

    return transactionHash;
  }
}
