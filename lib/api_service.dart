import 'dart:convert';
import 'package:http/http.dart' as http;

class HorarioApi {
  final bool sucesso;
  final String horaFormatada;
  final int hora;
  final int minuto;
  final String erro;

  HorarioApi({
    required this.sucesso,
    this.horaFormatada = '',
    this.hora = 0,
    this.minuto = 0,
    this.erro = '',
  });
}

class ApiService {
  static Future<HorarioApi> obterHorarioOficial() async {
    try {
      final url = Uri.parse('https://worldtimeapi.org/api/timezone/America/Sao_Paulo');
      final resposta = await http.get(url).timeout(const Duration(seconds: 6));

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);
        final DateTime dataHora = DateTime.parse(dados['datetime']);
        final horaStr = dataHora.hour.toString().padLeft(2, '0');
        final minStr = dataHora.minute.toString().padLeft(2, '0');

        return HorarioApi(
          sucesso: true,
          horaFormatada: '$horaStr:$minStr',
          hora: dataHora.hour,
          minuto: dataHora.minute,
        );
      } else {
        throw Exception('Erro no servidor: ${resposta.statusCode}');
      }
    } catch (e) {
      return HorarioApi(
        sucesso: false,
        erro: 'Não foi possível validar o horário online. Verifique sua conexão.',
      );
    }
  }
}