part of '../home_view.dart';

class _FilialDropdown extends StatelessWidget {
  const _FilialDropdown({
    required this.controller,
    required this.idFilialParametro,
  });

  final FilialController controller;
  final int idFilialParametro;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const SizedBox(
        height: 36,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    if (controller.itens.isEmpty) {
      return const SizedBox.shrink();
    }

    final codigoAtivo = controller.selecionado.codigo != 0
        ? controller.selecionado.codigo
        : idFilialParametro;

    final selecionado = controller.itens.firstWhere(
      (f) => f.codigo == codigoAtivo,
      orElse: () => controller.itens.first,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.store_outlined, color: Colors.white70, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<FilialModel>(
              value: selecionado,
              dropdownColor: AppColors.primaryDark,
              iconEnabledColor: Colors.white,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              items: controller.itens
                  .map(
                    (f) => DropdownMenuItem(
                      value: f,
                      child: Text(f.fantasia.isNotEmpty ? f.fantasia : f.nome),
                    ),
                  )
                  .toList(),
              onChanged: (f) {
                if (f != null) controller.selecionar(f);
              },
            ),
          ),
        ],
      ),
    );
  }
}
