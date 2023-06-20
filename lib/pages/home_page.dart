import 'package:flutter/material.dart';
import 'package:consulte_cep/models/endereco_model.dart';
import 'package:consulte_cep/repositories/Cep_repository.dart';
import 'package:consulte_cep/cep_repository_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;

  bool loading = false;

  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar CEP"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: cepEC,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "CEP obrigatório";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final valid = formKey.currentState?.validate() ?? false;
                  if (valid) {
                    try {
                      setState(() {
                        loading = true;
                      });
                      final endereco = await cepRepository.getCep(cepEC.text);
                      setState(() {
                        loading = false;
                        enderecoModel = endereco;
                      });
                    } catch (e) {
                      setState(() {
                        loading = false;
                        enderecoModel = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Erro ao buscar endereço"),
                        ),
                      );
                    }
                  }
                },
                child: const Text("Buscar"),
              ),
              Visibility(
                visible: loading,
                child: const CircularProgressIndicator(),
              ),
              Visibility(
                visible: enderecoModel != null,
                child: Text(
                  "${enderecoModel?.logradouro} ${enderecoModel?.complemento} ${enderecoModel?.cep}",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  );
                },
                child: const Text("Ir para a próxima tela"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Obrigado por usar meu APP :)",
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Voltar"),
            ),
          ],
        ),
      ),
    );
  }
}
