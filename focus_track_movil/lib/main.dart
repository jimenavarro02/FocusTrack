import 'package:flutter/material.dart';

void main() {
  runApp(const FocusTrackApp());
}

/// Niveles de prioridad de la sesión (Reto 1).
enum Prioridad {
  baja('Baja', Icons.arrow_downward, Color(0xFF78909C), Colors.white),
  media('Media', Icons.remove, Color(0xFFFFB300), Colors.black),
  alta('Alta', Icons.priority_high, Color(0xFFB71C1C), Colors.white);

  const Prioridad(this.etiqueta, this.icono, this.color, this.colorTexto);

  final String etiqueta;
  final IconData icono;
  final Color color;
  final Color colorTexto;
}

/// Widget raíz inmutable que configura el tema visual de la aplicación.
class FocusTrackApp extends StatelessWidget {
  const FocusTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusTrack Móvil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E), // Azul Índigo Universitario
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: const PantallaPrincipalMetas(),
    );
  }
}

/// Pantalla con estado reactivo para registrar metas y productividad.
class PantallaPrincipalMetas extends StatefulWidget {
  const PantallaPrincipalMetas({super.key});

  @override
  State<PantallaPrincipalMetas> createState() =>
      _PantallaPrincipalMetasState();
}

class _PantallaPrincipalMetasState extends State<PantallaPrincipalMetas> {
  static const int _limiteMaximo = 10; // Reto 2: tope diario de metas

  int _metasCompletadas = 0;
  final int _metaObjetivo = 5;
  String _nivelProductividad = 'Inicial';
  Prioridad _prioridad = Prioridad.media;

  void _actualizarNivel() {
    if (_metasCompletadas == 0) {
      _nivelProductividad = 'Inicial';
    } else if (_metasCompletadas < _metaObjetivo) {
      _nivelProductividad = 'En Progreso';
    } else if (_metasCompletadas == _metaObjetivo) {
      _nivelProductividad = '¡Objetivo Alcanzado!';
    } else {
      _nivelProductividad =
          '¡Sobresaliente (+${_metasCompletadas - _metaObjetivo})!';
    }
  }

  void _incrementarMeta() {
    // Reto 2: bloqueo seguro al llegar al máximo.
    if (_metasCompletadas >= _limiteMaximo) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'Ha alcanzado el límite máximo diario de metas (10/10). '
              '¡Excelente jornada!',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      return;
    }
    setState(() {
      _metasCompletadas++;
      _actualizarNivel();
    });
  }

  void _decrementarMeta() {
    setState(() {
      if (_metasCompletadas > 0) {
        _metasCompletadas--;
        _actualizarNivel();
      }
    });
  }

  void _reiniciarContadores() {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Reinicio'),
          content: const Text(
            '¿Desea restablecer todas las metas completadas a cero?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _metasCompletadas = 0;
                  _actualizarNivel();
                });
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Metas restablecidas exitosamente.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Reiniciar'),
            ),
          ],
        );
      },
    );
  }

  /// Reto 1: texto informativo según la prioridad elegida.
  String _descripcionPrioridad(Prioridad p) {
    switch (p) {
      case Prioridad.baja:
        return 'Ritmo relajado: avance a su propio paso.';
      case Prioridad.media:
        return 'Ritmo equilibrado: mantenga la constancia.';
      case Prioridad.alta:
        return 'Máximo enfoque: priorice las metas críticas.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final colores = tema.colorScheme;
    final porcentaje = (_metasCompletadas / _metaObjetivo).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusTrack Móvil'),
        backgroundColor: colores.primaryContainer,
        foregroundColor: colores.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Reiniciar sesión de metas',
            onPressed: _reiniciarContadores,
          ),
        ],
      ),
      // SafeArea garantiza visualización correcta fuera del notch
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tarjeta de Resumen Ejecutivo
              Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.track_changes,
                        size: 52.0,
                        color: colores.primary,
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        'Progreso del Día',
                        style: tema.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '$_metasCompletadas / $_metaObjetivo',
                        style: tema.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colores.primary,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: LinearProgressIndicator(
                          value: porcentaje,
                          minHeight: 10.0,
                          backgroundColor: colores.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _metasCompletadas >= _metaObjetivo
                                ? Colors.teal
                                : colores.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Chip(
                        avatar: Icon(
                          _metasCompletadas >= _metaObjetivo
                              ? Icons.emoji_events
                              : Icons.bolt,
                          color: colores.onSecondaryContainer,
                        ),
                        label: Text(
                          _nivelProductividad,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colores.onSecondaryContainer,
                          ),
                        ),
                        backgroundColor: colores.secondaryContainer,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // Reto 1: Selector de Estado de Prioridad
              Text(
                'Prioridad de la sesión',
                style: tema.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              SegmentedButton<Prioridad>(
                showSelectedIcon: false,
                segments: Prioridad.values
                    .map(
                      (Prioridad p) => ButtonSegment<Prioridad>(
                        value: p,
                        label: Text(p.etiqueta),
                        icon: Icon(p.icono),
                      ),
                    )
                    .toList(),
                selected: <Prioridad>{_prioridad},
                onSelectionChanged: (Set<Prioridad> seleccion) {
                  setState(() {
                    _prioridad = seleccion.first;
                  });
                },
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: _prioridad.color,
                  selectedForegroundColor: _prioridad.colorTexto,
                ),
              ),
              const SizedBox(height: 24.0),

              // Panel de Información (refleja la prioridad elegida)
              Card(
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(
                    color: _prioridad.color,
                    width: 2.0,
                  ),
                ),
                child: ListTile(
                  leading: Icon(_prioridad.icono, color: _prioridad.color),
                  title: Text('Prioridad ${_prioridad.etiqueta}'),
                  subtitle: Text(
                    '${_descripcionPrioridad(_prioridad)}\n'
                    'Renderizado nativo con Impeller y Hot Reload.',
                  ),
                  isThreeLine: true,
                ),
              ),
            ],
          ),
        ),
      ),
      // Botones Flotantes de Acción
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'btn_decrementar',
            onPressed: _decrementarMeta,
            tooltip: 'Restar meta completada',
            backgroundColor: colores.surfaceContainerHighest,
            foregroundColor: colores.onSurfaceVariant,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 14.0),
          FloatingActionButton.extended(
            heroTag: 'btn_incrementar',
            onPressed: _incrementarMeta,
            tooltip: 'Completar meta',
            backgroundColor: colores.primary,
            foregroundColor: colores.onPrimary,
            icon: const Icon(Icons.check),
            label: const Text('Completar Meta'),
          ),
        ],
      ),
    );
  }
}
