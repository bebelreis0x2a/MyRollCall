import 'dart:convert';
import 'package:http/http.dart' as http;

class HorarioApi {
  final bool sucesso;
  final String horaFormatada;
  final int hora;
  final int minuto;
  final String erro;
  final bool origemLocal;

  HorarioApi({
    required this.sucesso,
    this.horaFormatada = '',
    this.hora = 0,
    this.minuto = 0,
    this.erro = '',
    this.origemLocal = false,
  });
}

class ApiService {
  static Future<HorarioApi> obterHorarioOficial() async {
    try {
      // API REST rápida e compatível com Web (Chrome) e Android
      final url = Uri.parse(
        'https://timeapi.io/api/Time/current/zone?timeZone=America/Sao_Paulo',
      );
      final resposta = await http.get(url).timeout(const Duration(seconds: 8));

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);
        final int hora = dados['hour'];
        final int minuto = dados['minute'];
        final horaStr = hora.toString().padLeft(2, '0');
        final minStr = minuto.toString().padLeft(2, '0');

        return HorarioApi(
          sucesso: true,
          horaFormatada: '$horaStr:$minStr',
          hora: hora,
          minuto: minuto,
        );
      } else {
        throw Exception('Erro HTTP: ${resposta.statusCode}');
      }
    } catch (e) {
      // Plano B (Tratamento de erro): se a rede da escola bloquear a API,
      // usa o relógio do dispositivo para não travar a chamada
      final agora = DateTime.now();
      final horaStr = agora.hour.toString().padLeft(2, '0');
      final minStr = agora.minute.toString().padLeft(2, '0');

      return HorarioApi(
        sucesso: true,
        horaFormatada: '$horaStr:$minStr',
        hora: agora.hour,
        minuto: agora.minute,
        origemLocal: true,
        erro: 'API indisponível; usando horário local.',
      );
    }
  }
}