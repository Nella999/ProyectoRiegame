import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Visualiza la relación entre plantas totales, riegos y plantas con necesidades.
class EstadisticasChart extends StatefulWidget {
  final int plantas;    // Cantidad total de plantas registradas.
  final int riegos;     // Cantidad total de riegos históricos.
  final int necesitan;  // Cantidad de plantas que requieren riego hoy.

  const EstadisticasChart({
    super.key,
    required this.plantas,
    required this.riegos,
    required this.necesitan,
  });

  @override
  State<EstadisticasChart> createState() =>
      _EstadisticasChartState();
}

class _EstadisticasChartState
    extends State<EstadisticasChart> {
  // Índice de la sección del gráfico que está siendo tocada por el usuario.
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  centerSpaceRadius: 65,
                  sectionsSpace: 5,
                  borderData: FlBorderData(show: false),
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        touchedIndex =
                            response
                                ?.touchedSection
                                ?.touchedSectionIndex ??
                                -1;
                      });
                    },
                  ),
                  sections: _sections(),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_florist,
                    color: Colors.green,
                    size: 30,
                  ),
                  Text(
                    widget.plantas.toString(),
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text("Plantas"),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_florist,
                  color: Colors.green,
                ),
                SizedBox(width: 5),
                Text("Plantas"),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.water_drop,
                  color: Colors.blue,
                ),
                SizedBox(width: 5),
                Text("Riegos"),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.orange,
                ),
                SizedBox(width: 5),
                Text("Pendientes"),
              ],
            ),
          ],
        ),
      ],
    );
  }
  List<PieChartSectionData> _sections() {
    final total = widget.plantas +
        widget.riegos +
        widget.necesitan;
    return [
      PieChartSectionData(
        value: widget.plantas.toDouble(),
        title:
        "${((widget.plantas / total) * 100).toStringAsFixed(0)}%",
        color: Colors.green.shade500,
        radius: touchedIndex == 0 ? 92 : 80,
        titlePositionPercentageOffset: 0.55,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        badgeWidget: touchedIndex == 0
            ? const Icon(
          Icons.eco,
          color: Colors.white,
        )
            : null,
      ),

      PieChartSectionData(
        value: widget.riegos.toDouble(),
        title:
        "${((widget.riegos / total) * 100).toStringAsFixed(0)}%",
        color: Colors.lightBlue,
        radius: touchedIndex == 1 ? 92 : 80,
        titlePositionPercentageOffset: 0.55,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        badgeWidget: touchedIndex == 1
            ? const Icon(
          Icons.water_drop,
          color: Colors.white,
        )
            : null,
      ),

      PieChartSectionData(
        value: widget.necesitan.toDouble(),
        title:
        "${((widget.necesitan / total) * 100).toStringAsFixed(0)}%",
        color: Colors.orange,
        radius: touchedIndex == 2 ? 92 : 80,
        titlePositionPercentageOffset: 0.55,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        badgeWidget: touchedIndex == 2
            ? const Icon(
          Icons.warning,
          color: Colors.white,
        )
            : null,
      ),
    ];
  }
}