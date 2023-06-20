import 'package:consulte_cep/models/endereco_model.dart';
import 'package:consulte_cep/repositories/Cep_repository.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

class CepRepositoryImpl implements CepRepository {
  @override
  Future<EnderecoModel> getCep(String cep) async {
    try {
      final result = await Dio().get("https://viacep.com.br/ws/$cep/json/");
      return EnderecoModel.fromMap(result.data);
    } on DioError catch (e) {
      log("Erro ao buscar CEP", error: e);
      throw Exception("Erro ao buscar CEP");
    }
  }
}
