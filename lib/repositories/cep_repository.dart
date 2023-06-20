import 'package:consulte_cep/models/endereco_model.dart';

abstract class CepRepository {
  Future<EnderecoModel> getCep(String cep);
}
