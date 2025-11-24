import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class QuickHelpScreen extends StatefulWidget {
  const QuickHelpScreen({Key? key}) : super(key: key);

  @override
  State<QuickHelpScreen> createState() => _QuickHelpScreenState();
}

class _QuickHelpScreenState extends State<QuickHelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'Todas';
  List<Map<String, dynamic>> allHelps = [];
  List<Map<String, dynamic>> filteredHelps = [];

  final List<String> categories = [
    'Todas',
    '🔌 Electricidad',
    '💧 Gasfitería',
    '🔒 Cerrajería',
    '❄️ Electrodomésticos',
    '🔥 Calefacción',
    '🧹 Hogar'
  ];

  @override
  void initState() {
    super.initState();
    _loadHelps();
  }

  void _loadHelps() {
  allHelps = [
    // 🔌 ELECTRICIDAD
    {
      'title': 'Cómo cambiar una ampolleta',
      'category': '🔌 Electricidad',
      'steps': [
        'Apaga el interruptor antes de tocar la lámpara.',
        'Deja enfriar la ampolleta si estaba encendida.',
        'Desenrosca la ampolleta dañada.',
        'Enrosca la nueva hasta que quede firme, sin forzar.',
      ],
      'video': 'https://youtu.be/qWKV5MTziIA?si=ZsMO1LmGuwnDI_c1'
    },
    {
      'title': 'No funciona un enchufe',
      'category': '🔌 Electricidad',
      'steps': [
        'Conecta otro aparato para confirmar que no haya energía.',
        'Verifica los fusibles o el diferencial.',
        'Revisa si el enchufe está suelto o tiene cables dañados.',
      ],
      'video': 'https://youtu.be/4jXFqb2GilM?si=pbt4IKx6z07bDdPb'
    },
    {
      'title': 'El disyuntor se baja solo',
      'category': '🔌 Electricidad',
      'steps': [
        'Desconecta todos los artefactos eléctricos.',
        'Vuelve a subir el disyuntor.',
        'Conecta uno por uno para detectar cuál provoca el corte.',
      ],
      'video': 'https://youtu.be/5lzVwOIVP5E?si=hymnTUH5EKTZFtOm'
    },
    {
      'title': 'Cómo usar un multímetro',
      'category': '🔌 Electricidad',
      'steps': [
        'Enciende el multímetro y selecciona voltaje o continuidad.',
        'Coloca las puntas en los polos correctos.',
        'Lee el valor en pantalla para comprobar corriente o continuidad.',
      ],
      'video': 'https://youtu.be/r2H0Z1zlxGo?si=zQOatzbx19OugQKu'
    },

    // 💧 GASFITERÍA
    {
      'title': 'Llave del lavamanos gotea',
      'category': '💧 Gasfitería',
      'steps': [
        'Cierra la llave de paso del agua.',
        'Desmonta el mando de la llave.',
        'Cambia el sello o empaque interior.',
        'Vuelve a montar la llave y abre el agua.',
      ],
      'video': 'https://youtu.be/nDy4z_OwpkA?si=G_6nlFhP6oEgRUNV'
    },
    {
      'title': 'No sale agua de la ducha',
      'category': '💧 Gasfitería',
      'steps': [
        'Revisa si hay agua fría y caliente en otras llaves.',
        'Limpia el filtro del cabezal de la ducha.',
        'Si sigue sin agua, revisa el calefont o la presión.',
      ],
      'video': 'https://youtu.be/sbAHIbVlcig?si=27LULhuvXEVZ_qT7'
    },
    {
      'title': 'El WC no corta el agua',
      'category': '💧 Gasfitería',
      'steps': [
        'Quita la tapa del estanque.',
        'Ajusta el flotador o reemplaza el mecanismo de descarga.',
        'Prueba varias veces hasta que el nivel sea correcto.',
      ],
      'video': 'https://youtu.be/kGxaMMEGhZk?si=tpK0zFIz8CavCeUr'
    },
    {
      'title': 'Cómo destapar el lavaplatos',
      'category': '💧 Gasfitería',
      'steps': [
        'Echa agua caliente con bicarbonato y vinagre.',
        'Si no funciona, usa una sopapa.',
        'Desenrosca el sifón bajo el lavaplatos y límpialo.',
      ],
      'video': 'https://youtu.be/-y1eQxi_JCk?si=YOamUl2JJSSW8dNU'
    },
    {
      'title': 'Fuga de agua en cañería visible',
      'category': '💧 Gasfitería',
      'steps': [
        'Cierra la llave de paso general.',
        'Seca bien la zona.',
        'Aplica cinta de teflón o sellador temporal hasta que llegue el técnico.',
      ],
      'video': 'https://youtu.be/A5GoctPs1pc?si=JuJYY5fNkf2rVopW'
    },

    // 🔒 CERRAJERÍA
    {
      'title': 'Puerta no cierra bien',
      'category': '🔒 Cerrajería',
      'steps': [
        'Afloja los tornillos del picaporte.',
        'Ajusta la posición del pestillo o la placa metálica.',
        'Aprieta nuevamente los tornillos.',
      ],
      'video': 'https://youtu.be/LAwMMBBVtcE?si=syxVgNI-yOTBM-DZ'
    },
    {
      'title': 'Cómo lubricar una cerradura',
      'category': '🔒 Cerrajería',
      'steps': [
        'Usa lubricante en spray (no aceite).',
        'Introduce la llave varias veces para repartir el lubricante.',
      ],
      'video': 'https://youtu.be/id6mILNKYjE?si=speXeqA-KkMNFkLE'
    },
    {
      'title': 'Me quedé afuera de la casa',
      'category': '🔒 Cerrajería',
      'steps': [
        'Si tienes una ventana abierta, entra por ahí de forma segura.',
        'Llama a un cerrajero certificado si no hay acceso seguro.',
      ],
      'video': 'https://youtu.be/xipy-L0UUOg?si=xorym92IYbeW3F2P'
    },
    {
      'title': 'Cambiar una chapa',
      'category': '🔒 Cerrajería',
      'steps': [
        'Quita los tornillos de la cerradura antigua.',
        'Inserta la nueva chapa alineando los agujeros.',
        'Atornilla y prueba el cierre.',
      ],
      'video': 'https://youtu.be/-e8pu4OUZ5c?si=vhEYNL-ff86ERxZu'
    },
    {
      'title': 'Ajustar bisagras flojas',
      'category': '🔒 Cerrajería',
      'steps': [
        'Aprieta los tornillos de las bisagras.',
        'Si el agujero está dañado, mete un palillo con pegamento antes del tornillo.',
      ],
      'video': 'https://youtu.be/SAgDwFDqxVM?si=ttjaKp2q2tFhdG49'
    },

    // ❄️ ELECTRODOMÉSTICOS
    {
      'title': 'El refrigerador no enfría',
      'category': '❄️ Electrodomésticos',
      'steps': [
        'Verifica que esté enchufado y que el cable esté bien.',
        'Revisa que el termostato esté en nivel medio o alto.',
        'Limpia el condensador trasero si hay polvo.',
      ],
      'video': 'https://youtu.be/CJd4CzzI5PY?si=2tCTG4hS1noiAwER'
    },
    {
      'title': 'La lavadora no centrifuga',
      'category': '❄️ Electrodomésticos',
      'steps': [
        'Revisa si la tapa cierra correctamente.',
        'Limpia el filtro de pelusas.',
        'Asegúrate de no sobrecargar la lavadora.',
      ],
      'video': 'https://youtu.be/K2-JliUTHwc?si=BjK7l2dHMF4EqaYR'
    },
    {
      'title': 'El microondas no calienta',
      'category': '❄️ Electrodomésticos',
      'steps': [
        'Verifica que gire el plato interior.',
        'Prueba con otro enchufe.',
        'Si sigue igual, no lo abras: llama a un técnico.',
      ],
      'video': 'https://youtu.be/a1F0adTZxz0?si=z2kEFxPPjDGI0Ubs'
    },
    {
      'title': 'Plancha con vapor no larga agua',
      'category': '❄️ Electrodomésticos',
      'steps': [
        'Llena el tanque con agua limpia.',
        'Activa el botón de vapor varias veces.',
        'Limpia los orificios con vinagre caliente.',
      ],
      'video': 'https://youtu.be/-wQbD0xnKAE?si=f5p-7t_bkHiyeRvN'
    },
    {
      'title': 'El hervidor no enciende',
      'category': '❄️ Electrodomésticos',
      'steps': [
        'Verifica el enchufe y el cable.',
        'Limpia la base de contacto.',
        'Si está calcificado, limpia con vinagre caliente.',
      ],
      'video': 'https://youtu.be/Q04yDlcktxU?si=tb26Zmh2D9PSPHke'
    },

    // 🔥 CALEFACCIÓN
    {
      'title': 'No sale agua caliente del calefont',
      'category': '🔥 Calefacción',
      'steps': [
        'Asegúrate de que el gas esté abierto.',
        'Verifica la presión de agua.',
        'Revisa si el piloto está encendido.',
        'Limpia los filtros de entrada del calefont.',
      ],
      'video': 'https://youtu.be/CksaSeuIQ4A?si=5tVf3XFRxtoxxqBt'
    },
    {
      'title': 'Cómo encender el calefont',
      'category': '🔥 Calefacción',
      'steps': [
        'Abre el gas y el agua caliente.',
        'Presiona el botón de encendido hasta que prenda el piloto.',
        'Regula la temperatura según necesidad.',
      ],
      'video': 'https://youtube.com/shorts/_q6IytE0gU8?si=gQAYgHIdi45R9Iru'
    },
    {
      'title': 'Calefactor a gas no prende',
      'category': '🔥 Calefacción',
      'steps': [
        'Verifica que haya gas en el cilindro.',
        'Revisa el encendido y el regulador de presión.',
        'Si no prende, limpia el piloto con un clip.',
      ],
      'video': 'https://youtu.be/Lz-0gJzwdsI?si=WrLcrnG8HOTaVPw9'
    },
    {
      'title': 'Radiador no calienta bien',
      'category': '🔥 Calefacción',
      'steps': [
        'Purge el aire del radiador abriendo la válvula.',
        'Verifica que el termostato esté funcionando.',
      ],
      'video': 'https://youtu.be/A4D9kyQdbvQ?si=dqiDPupiB3oEjhhd'
    },
    {
      'title': 'El calefont hace explosión al encender',
      'category': '🔥 Calefacción',
      'steps': [
        'Reduce la presión de gas.',
        'Limpia los inyectores con un cepillo fino.',
        'Si el problema continúa, llama a un técnico.',
      ],
      'video': 'https://youtu.be/UBZzM7W-etQ?si=HcsJVGSavvLOaicl'
    },

    // 🧹 HOGAR
    {
      'title': 'Cómo limpiar vidrios sin dejar marcas',
      'category': '🧹 Hogar',
      'steps': [
        'Usa vinagre con agua en partes iguales.',
        'Seca con papel de diario o paño de microfibra.',
      ],
      'video': 'https://youtu.be/C87xGH4PxSk?si=gU_Dv_LttybiqP5B'
    },
    {
      'title': 'Eliminar mal olor del refrigerador',
      'category': '🧹 Hogar',
      'steps': [
        'Limpia con bicarbonato y limón.',
        'Deja un recipiente con café molido dentro.',
      ],
      'video': 'https://youtu.be/_llI8KLqEys?si=lyApaT3Z6IqIeOYL'
    },
    {
      'title': 'Quitar manchas de la pared',
      'category': '🧹 Hogar',
      'steps': [
        'Frota suavemente con esponja mágica o bicarbonato.',
        'Evita productos abrasivos para no dañar la pintura.',
      ],
      'video': 'https://youtu.be/bmQNECm3Zv4?si=C5O_jVFpvW2NqoTy'
    },
    {
      'title': 'Cómo desinfectar la cocina',
      'category': '🧹 Hogar',
      'steps': [
        'Limpia primero con agua y detergente.',
        'Desinfecta con alcohol o vinagre blanco.',
      ],
      'video': 'https://youtu.be/unkdjo7SCGE?si=rum4EBOOxW9AVqX6'
    },
    {
      'title': 'Eliminar moho del baño',
      'category': '🧹 Hogar',
      'steps': [
        'Rocía vinagre blanco o cloro diluido sobre el moho.',
        'Cepilla y deja ventilar bien el baño.',
      ],
      'video': 'https://youtu.be/uhZu0dGbjzc?si=zfO13J2xTviQ3TYS'
    },
  ];

  filteredHelps = List.from(allHelps);
}


  void _filterHelps() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredHelps = allHelps.where((help) {
        final matchesCategory = selectedCategory == 'Todas' ||
            help['category'] == selectedCategory;
        final matchesText = help['title'].toLowerCase().contains(query);
        return matchesCategory && matchesText;
      }).toList();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      _filterHelps();
    });
  }

  void _openHelpDetail(Map<String, dynamic> help) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HelpDetailScreen(help: help),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayudas rápidas 🧰'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _filterHelps(),
              decoration: InputDecoration(
                hintText: 'Buscar ayuda...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          // 🔹 Chips de categorías
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, index) {
                final category = categories[index];
                final selected = category == selectedCategory;
                return ChoiceChip(
                  label: Text(category),
                  selected: selected,
                  onSelected: (_) => _onCategorySelected(category),
                  selectedColor: Colors.teal.shade300,
                  backgroundColor: Colors.teal.shade100,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // 📋 Lista de ayudas
          Expanded(
            child: filteredHelps.isEmpty
                ? const Center(child: Text("No se encontraron resultados."))
                : ListView.builder(
                    itemCount: filteredHelps.length,
                    itemBuilder: (context, index) {
                      final help = filteredHelps[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(help['title']),
                          subtitle: Text(help['category']),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.teal),
                          onTap: () => _openHelpDetail(help),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// 🧩 Pantalla de detalle
class HelpDetailScreen extends StatelessWidget {
  final Map<String, dynamic> help;

  const HelpDetailScreen({Key? key, required this.help}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(help['title']),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pasos a seguir:',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...help['steps'].map<Widget>((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('• $s'),
                )),
            const SizedBox(height: 20),
            Text('Video explicativo:',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_circle_fill),
                label: const Text("Ver en YouTube"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final Uri videoUrl = Uri.parse(help['video']);
                  if (await canLaunchUrl(videoUrl)) {
                    await launchUrl(videoUrl, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No se pudo abrir el video")),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
