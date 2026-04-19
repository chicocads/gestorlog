import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/numero_formatar.dart';
import '../../../../core/widgets/info_row.dart';
import '../../../../models/cadastro/produto_model.dart';

class ProdutoCard extends StatelessWidget {
  const ProdutoCard({
    super.key,
    required this.produto,
    this.onTap,
  });

  final ProdutoModel produto;
  final VoidCallback? onTap;

  bool get _temWms => produto.wmsrua > 0;

  String get _wmsFormatado {
    final partes = <String>[
      if (produto.wmsrua != 0) 'Rua: ${produto.wmsrua}',
      if (produto.wmsblc != 0) 'Blc: ${produto.wmsblc}',
      if (produto.wmsmod != 0) 'Mod: ${produto.wmsmod}',
      if (produto.wmsniv != 0) 'Niv: ${produto.wmsniv}',
      if (produto.wmsapt != 0) 'Apt: ${produto.wmsapt}',
      if (produto.wmsgvt != 0) 'Gvt: ${produto.wmsgvt}',
    ];
    return partes.join(' | ');
  }

  Uint8List? _imagemBytes() {
    final imagem = produto.imagem.trim();
    if (imagem.isEmpty) return null;
    try {
      final bytes = base64Decode(imagem);
      if (bytes.isEmpty) return null;
      return bytes;
    } catch (_) {
      return null;
    }
  }

  void _abrirImagemAmpliada(BuildContext context, Uint8List bytes) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.9,
            maxHeight: MediaQuery.sizeOf(context).height * 0.55,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(bytes, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  Widget _buildImagemProduto(BuildContext context) {
    final bytes = _imagemBytes();
    if (bytes == null) return _buildImagemPlaceholder();

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _abrirImagemAmpliada(context, bytes),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          bytes,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _buildImagemPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildImagemPlaceholder() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.inventory_2_outlined,
        color: AppColors.textSecondary,
        size: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final saldo = NumeroFormatar.qtde(produto.saldo, decQtde: 2);
    final preco = NumeroFormatar.moeda(produto.precovenda.toString());
    const tituloCampoStyle = TextStyle(
      fontSize: 9,
      color: AppColors.textSecondary,
    );

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImagemProduto(context),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          produto.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InfoRow(
                      label: 'EAN',
                      labelWidth: 34,
                      labelStyle: tituloCampoStyle,
                      valueStyle: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                      value: produto.codigoalfa.isNotEmpty
                          ? produto.codigoalfa
                          : 'Não informado',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InfoRow(
                      label: 'DUN14',
                      labelWidth: 46,
                      labelStyle: tituloCampoStyle,
                      valueStyle: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                      value: produto.dun14.isNotEmpty
                          ? produto.dun14
                          : 'Não informado',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: InfoRow(
                      label: 'Marca',
                      labelWidth: 42,
                      labelStyle: tituloCampoStyle,
                      value: produto.marca.isNotEmpty
                          ? produto.marca
                          : 'Não informada',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InfoRow(
                      label: 'Seção',
                      labelWidth: 40,
                      labelStyle: tituloCampoStyle,
                      value: '${produto.secao}/${produto.grupo}/${produto.sgrupo}',
                    ),
                  ),
                ],
              ),
              InfoRow(
                label: 'Local',
                labelWidth: 42,
                labelStyle: tituloCampoStyle,
                value: _temWms
                    ? _wmsFormatado
                    : (produto.localizacao.trim().isNotEmpty
                          ? produto.localizacao
                          : 'Não informado'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.scale_outlined,
                      label: 'Saldo',
                      value: '$saldo ${produto.undvenda}',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetricTile(
                      icon: Icons.attach_money_outlined,
                      label: 'Preço',
                      value: preco,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
