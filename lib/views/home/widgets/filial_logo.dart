part of '../home_view.dart';

class _FilialLogo extends StatelessWidget {
  const _FilialLogo({required this.filialController});

  final FilialController filialController;

  Uint8List? _decodeImage(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return null;
    final normalized = v.startsWith('data:') && v.contains(',')
        ? v.split(',').last
        : v;
    try {
      final bytes = base64Decode(normalized);
      return bytes.isEmpty ? null : bytes;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: filialController,
      builder: (context, _) {
        final bytes = _decodeImage(filialController.selecionado.imagem);
        if (bytes == null) {
          return const Icon(
            Icons.warehouse_outlined,
            size: 48,
            color: Colors.white,
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            bytes,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.warehouse_outlined,
              size: 48,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
