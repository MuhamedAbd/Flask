import 'dart:convert';
import 'package:http/http.dart' as http;

class WatsonService {
  final String apiKey = "g2T8ZDPY-SWkvB7hGAjUBtCsLkBS9nYxSd1r0bxHhB3p";
  final String assistantId = "48c26008-7d72-4bc7-bb32-a85547d030eb";
  final String url = "https://api.eu-de.assistant.watson.cloud.ibm.com/instances/564d52a8-6362-4cd6-af20-f339b25c37b7";

  Future<String> createSession() async {
    final uri = Uri.parse("$url/v2/assistants/$assistantId/sessions?version=2021-06-14");

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Basic " + base64Encode(utf8.encode("apikey:$apiKey")),
      },
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData["session_id"];
    } else {
      throw Exception("Error: ${response.body}");
    }
  }

  Future<String> sendMessage(String message, String sessionId) async {
    final uri = Uri.parse("$url/v2/assistants/$assistantId/sessions/$sessionId/message?version=2021-06-14");

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Basic " + base64Encode(utf8.encode("apikey:$apiKey")),
      },
      body: jsonEncode({
        "input": {
          "message_type": "text",
          "text": message,
        }
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      var output = responseData["output"]["generic"];
      if (output != null && output.isNotEmpty) {
        return output[0]["text"];
      } else {
        return "No response from Watson";
      }
    } else {
      throw Exception("Error: ${response.body}");
    }
  }
}
