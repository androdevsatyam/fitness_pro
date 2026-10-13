import 'dart:io';

void main() async {
  final port = 8080;
  final buildDir = Directory('build/web');

  if (!buildDir.existsSync()) {
    print('build/web directory not found. Please run flutter build web first.');
    return;
  }

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print('====================================================');
  print(' FitPro Web Prototype Server is LIVE at:');
  print(' http://localhost:$port');
  print('====================================================');

  await for (HttpRequest request in server) {
    try {
      var path = request.uri.path;
      if (path == '/' || path.isEmpty) {
        path = '/index.html';
      }

      var filePath = 'build/web$path';
      var file = File(filePath);

      if (!file.existsSync()) {
        file = File('build/web/index.html');
      }

      final ext = file.path.split('.').last.toLowerCase();
      String contentType = 'application/octet-stream';
      if (ext == 'html') contentType = 'text/html';
      if (ext == 'js') contentType = 'application/javascript';
      if (ext == 'json') contentType = 'application/json';
      if (ext == 'css') contentType = 'text/css';
      if (ext == 'png') contentType = 'image/png';
      if (ext == 'jpg' || ext == 'jpeg') contentType = 'image/jpeg';
      if (ext == 'svg') contentType = 'image/svg+xml';
      if (ext == 'wasm') contentType = 'application/wasm';

      request.response.headers.add('Content-Type', contentType);
      request.response.headers.add('Access-Control-Allow-Origin', '*');
      await request.response.addStream(file.openRead());
      await request.response.close();
    } catch (e) {
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write('Server Error: $e');
      await request.response.close();
    }
  }
}

