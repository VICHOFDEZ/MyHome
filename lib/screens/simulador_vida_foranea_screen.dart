// lib/screens/simulador_vida_foranea_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kPrimaryColor = Color(0xFF1B4965);

class SimuladorVidaForaneaScreen extends StatefulWidget {
  const SimuladorVidaForaneaScreen({super.key});

  @override
  State<SimuladorVidaForaneaScreen> createState() =>
      _SimuladorVidaForaneaScreenState();
}

class _SimuladorVidaForaneaScreenState
    extends State<SimuladorVidaForaneaScreen> {
  static const _storageKey = 'simulador_vida_foranea_datos';

  final Map<String, TextEditingController> _controllers = {};

  bool _cargando = true;

  // Definimos los campos de cada categoría
  final List<_Campo> _ingresos = const [
    _Campo(id: 'ingreso_beca', label: 'Beca / aporte familiar'),
    _Campo(id: 'ingreso_trabajo', label: 'Sueldo / trabajo part-time'),
    _Campo(id: 'ingreso_otros', label: 'Otros ingresos'),
  ];

  final List<_Campo> _gastosFijos = const [
    _Campo(id: 'gasto_arriendo', label: 'Arriendo'),
    _Campo(id: 'gasto_gastos_comunes', label: 'Gastos comunes'),
    _Campo(id: 'gasto_luz', label: 'Luz'),
    _Campo(id: 'gasto_agua', label: 'Agua'),
    _Campo(id: 'gasto_gas', label: 'Gas'),
    _Campo(id: 'gasto_internet', label: 'Internet / teléfono hogar'),
    _Campo(id: 'gasto_transporte', label: 'Transporte (bip, bencina, etc.)'),
    _Campo(id: 'gasto_universidad', label: 'Universidad (arancel / materiales)'),
    _Campo(id: 'gasto_salud_seguro', label: 'Salud / seguros'),
  ];

  final List<_Campo> _gastosVariables = const [
    _Campo(id: 'gasto_super', label: 'Comida (supermercado)'),
    _Campo(id: 'gasto_comida_fuera', label: 'Comida fuera / delivery'),
    _Campo(id: 'gasto_ocio', label: 'Ocio / carrete'),
    _Campo(id: 'gasto_otros', label: 'Otros gastos'),
  ];

  final List<_Campo> _metas = const [
    _Campo(id: 'meta_ahorro_mensual', label: 'Meta de ahorro mensual'),
    _Campo(id: 'meta_objetivo_grande', label: 'Meta grande (ej: viaje, computador)'),
  ];

  @override
  void initState() {
    super.initState();
    _initControllers();
    _cargarDatos();
  }

  void _initControllers() {
    for (final c in [..._ingresos, ..._gastosFijos, ..._gastosVariables, ..._metas]) {
      _controllers[c.id] = TextEditingController();
    }
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_storageKey);

    if (data != null) {
      final map = jsonDecode(data) as Map<String, dynamic>;
      map.forEach((key, value) {
        if (_controllers.containsKey(key)) {
          _controllers[key]!.text = value.toString();
        }
      });
    }

    if (mounted) {
      setState(() {
        _cargando = false;
      });
    }
  }

  Future<void> _guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, String> data = {};
    _controllers.forEach((key, controller) {
      final text = controller.text.trim();
      if (text.isNotEmpty) {
        data[key] = text;
      }
    });
    await prefs.setString(_storageKey, jsonEncode(data));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos del simulador guardados')),
    );
  }

  double _getValor(String id) {
    final text = _controllers[id]?.text.trim() ?? '';
    if (text.isEmpty) return 0;
    return double.tryParse(text.replaceAll(',', '.')) ?? 0;
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Cálculos
    final totalIngresos = _ingresos
        .map((c) => _getValor(c.id))
        .fold<double>(0, (a, b) => a + b);

    final totalGastosFijos = _gastosFijos
        .map((c) => _getValor(c.id))
        .fold<double>(0, (a, b) => a + b);

    final totalGastosVariables = _gastosVariables
        .map((c) => _getValor(c.id))
        .fold<double>(0, (a, b) => a + b);

    final totalGastos = totalGastosFijos + totalGastosVariables;
    final saldo = totalIngresos - totalGastos;
    final saldoPositivo = saldo > 0 ? saldo : 0;

    final ratioFijo =
        totalIngresos > 0 ? totalGastosFijos / totalIngresos : 0.0;


    final sueldoDia = saldoPositivo / 30.0;

    // Metas
    final metaMensual = _getValor('meta_ahorro_mensual');
    final metaGrande = _getValor('meta_objetivo_grande');

    final analisisMeta = _analizarMeta(
      saldo: saldo,
      metaMensual: metaMensual,
      metaGrande: metaGrande,
    );

    final nivelEstres = _nivelEstresFinanciero(
      totalIngresos: totalIngresos,
      totalGastos: totalGastos,
      ratioFijo: ratioFijo,
      saldo: saldo,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Simulador de Vida',
          style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
          ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildResumenGeneral(
              totalIngresos: totalIngresos,
              totalGastos: totalGastos,
              totalFijos: totalGastosFijos,
              totalVariables: totalGastosVariables,
              saldo: saldo,
              nivelEstres: nivelEstres,
            ),
            const SizedBox(height: 16),
            _buildSeccionCampos('Ingresos mensuales', _ingresos),
            const SizedBox(height: 12),
            _buildSeccionCampos('Gastos fijos mensuales', _gastosFijos),
            const SizedBox(height: 12),
            _buildSeccionCampos('Gastos variables estimados', _gastosVariables),
            const SizedBox(height: 12),
            _buildSeccionMetas(metaMensual, metaGrande, analisisMeta),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _guardarDatos,
                icon: const Icon(Icons.save),
                label: const Text('Guardar simulación'),
              ),
            ),
            const SizedBox(height: 24),
            _buildDetalleDistribucion(
              totalIngresos: totalIngresos,
              totalFijos: totalGastosFijos,
              totalVariables: totalGastosVariables,
              sueldoDia: sueldoDia,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenGeneral({
    required double totalIngresos,
    required double totalGastos,
    required double totalFijos,
    required double totalVariables,
    required double saldo,
    required _NivelEstres nivelEstres,
  }) {
    String saldoTexto;
    Color saldoColor;
    if (saldo > 0) {
      saldoTexto = 'Te sobran \$${saldo.toStringAsFixed(0)} este mes.';
      saldoColor = Colors.green;
    } else if (saldo < 0) {
      saldoTexto =
          'Te faltan \$${(-saldo).toStringAsFixed(0)} para cubrir el mes.';
      saldoColor = Colors.red;
    } else {
      saldoTexto = 'Llegas justo, sin sobra ni déficit.';
      saldoColor = Colors.orange;
    }

    final descripcionEstres = switch (nivelEstres) {
      _NivelEstres.bajo => 'Bajo (estructura sana, hay margen).',
      _NivelEstres.medio => 'Medio (cuida los gastos variables).',
      _NivelEstres.alto =>
        'Alto (mucho fijo, poco margen para imprevistos).',
      _NivelEstres.critico =>
        'Crítico (ingresos muy ajustados o déficit mensual).',
    };

    final colorEstres = switch (nivelEstres) {
      _NivelEstres.bajo => Colors.green,
      _NivelEstres.medio => Colors.orange,
      _NivelEstres.alto => Colors.deepOrange,
      _NivelEstres.critico => Colors.red,
    };

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen mensual',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            _resumenFila('Total ingresos', totalIngresos),
            _resumenFila('Total gastos', totalGastos),
            const SizedBox(height: 4),
            Text(
              saldoTexto,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: saldoColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: colorEstres,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Nivel de estrés financiero: $descripcionEstres',
                    style: TextStyle(
                      fontSize: 13,
                      color: colorEstres,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _resumenFila(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('\$${value.toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  Widget _buildSeccionCampos(String titulo, List<_Campo> campos) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Column(
              children: campos
                  .map((c) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: TextField(
                          controller: _controllers[c.id],
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: c.label,
                            prefixText: '\$ ',
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (_) {
                            setState(() {});
                          },
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionMetas(
      double metaMensual, double metaGrande, _AnalisisMeta analisisMeta) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Metas de ahorro',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Column(
              children: _metas
                  .map((c) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: TextField(
                          controller: _controllers[c.id],
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: c.label,
                            prefixText: '\$ ',
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
            if (metaMensual > 0 || metaGrande > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Análisis de tus metas:',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  ...analisisMeta.mensajes.map(
                    (m) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '- $m',
                        style: TextStyle(
                          fontSize: 13,
                          color: m.esAlerta ? Colors.red : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              const Text(
                'Agrega una meta mensual o una meta grande para ver cuánto tardarías en alcanzarla.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalleDistribucion({
    required double totalIngresos,
    required double totalFijos,
    required double totalVariables,
    required double sueldoDia,
  }) {
    final ratioFijo =
        totalIngresos > 0 ? (totalFijos / totalIngresos * 100) : 0;
    final ratioVar =
        totalIngresos > 0 ? (totalVariables / totalIngresos * 100) : 0;
    final ratioLibre =
        totalIngresos > 0 ? (100 - ratioFijo - ratioVar).clamp(0, 100) : 0;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalle de tu mes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (totalIngresos <= 0)
              const Text(
                'Ingresa al menos un ingreso mensual para ver la distribución.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              )
            else ...[
              Text(
                'Gastos fijos: ${ratioFijo.toStringAsFixed(1)} % de tus ingresos.',
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                'Gastos variables: ${ratioVar.toStringAsFixed(1)} % de tus ingresos.',
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                'Margen libre / ahorro: ${ratioLibre.toStringAsFixed(1)} % de tus ingresos.',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              Text(
                'Dinero disponible por día (después de gastos): \$${sueldoDia.toStringAsFixed(0)} aprox.',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'Úsalo como “sueldo psicológico diario” para no pasarte en el mes.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _AnalisisMeta _analizarMeta({
    required double saldo,
    required double metaMensual,
    required double metaGrande,
  }) {
    final mensajes = <_MensajeMeta>[];

    if (metaMensual > 0) {
      if (saldo <= 0) {
        mensajes.add(
          _MensajeMeta(
            texto:
                'Actualmente no tienes saldo mensual positivo para ahorrar \$${metaMensual.toStringAsFixed(0)} al mes.',
            esAlerta: true,
          ),
        );
      } else if (saldo < metaMensual) {
        mensajes.add(
          _MensajeMeta(
            texto:
                'Tu saldo mensual (\$${saldo.toStringAsFixed(0)}) no alcanza para ahorrar tu meta de \$${metaMensual.toStringAsFixed(0)}.',
            esAlerta: true,
          ),
        );
      } else {
        mensajes.add(
          _MensajeMeta(
            texto:
                'Puedes ahorrar tu meta mensual de \$${metaMensual.toStringAsFixed(0)}. Te sobrarían aprox. \$${(saldo - metaMensual).toStringAsFixed(0)}.',
          ),
        );
      }
    }

    if (metaGrande > 0 && saldo > 0) {
      final meses = (metaGrande / saldo).ceil();
      if (meses <= 0) {
        mensajes.add(
          _MensajeMeta(
            texto:
                'Con tu saldo actual, puedes alcanzar tu meta grande muy rápido.',
          ),
        );
      } else {
        mensajes.add(
          _MensajeMeta(
            texto:
                'Con tu saldo mensual actual, tardarías aprox. $meses mes(es) en llegar a tu meta de \$${metaGrande.toStringAsFixed(0)}.',
          ),
        );
      }
    } else if (metaGrande > 0 && saldo <= 0) {
      mensajes.add(
        _MensajeMeta(
          texto:
              'Para avanzar hacia tu meta grande de \$${metaGrande.toStringAsFixed(0)}, primero necesitas saldo mensual positivo.',
          esAlerta: true,
        ),
      );
    }

    if (mensajes.isEmpty) {
      mensajes.add(
        _MensajeMeta(
          texto:
              'Ajusta tus ingresos y gastos, y define metas para ver un plan de ahorro estimado.',
        ),
      );
    }

    return _AnalisisMeta(mensajes: mensajes);
  }

  _NivelEstres _nivelEstresFinanciero({
    required double totalIngresos,
    required double totalGastos,
    required double ratioFijo,
    required double saldo,
  }) {
    if (totalIngresos <= 0 && totalGastos > 0) {
      return _NivelEstres.critico;
    }
    if (saldo < 0) return _NivelEstres.critico;
    if (ratioFijo > 0.8) return _NivelEstres.alto;
    if (ratioFijo > 0.65) return _NivelEstres.medio;
    return _NivelEstres.bajo;
  }
}

// --------- MODELOS AUXILIARES ---------

class _Campo {
  final String id;
  final String label;
  const _Campo({required this.id, required this.label});
}

enum _NivelEstres { bajo, medio, alto, critico }

class _AnalisisMeta {
  final List<_MensajeMeta> mensajes;
  _AnalisisMeta({required this.mensajes});
}

class _MensajeMeta {
  final String texto;
  final bool esAlerta;
  _MensajeMeta({required this.texto, this.esAlerta = false});
}
