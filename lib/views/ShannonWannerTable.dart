import 'package:diversitree_mobile/components/RingkasanInformasi.dart';
import 'package:flutter/material.dart';

class ShannonWannerTable extends StatefulWidget {
  @override
  _ShannonWannerTableState createState() => _ShannonWannerTableState();
}

class _ShannonWannerTableState extends State<ShannonWannerTable> {
  final List<SpeciesData> speciesDataList = List.generate(
    100, // 100 species data for pagination
    (index) => SpeciesData(
      'Species $index',
      (index + 1) * 10,  // Frequency as an example, increasing by 10
      (index + 1) * 0.05,
      (index + 1) * 0.05,
      (index + 1) * 0.05,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RingkasanInformasi(infoSize: 56, showCamera: false,),

        PaginatedDataTable(
            header: Text('Daftar Spesies'),
            rowsPerPage: 10, // The number of rows per page
            columns: [
              DataColumn(label: Text('Species')),
              DataColumn(label: Text('Frequency')),
              DataColumn(label: Text('p')),
              DataColumn(label: Text('ln(p)')),
              DataColumn(label: Text('p * ln(p)')),
            ],
            source: SpeciesDataSource(speciesDataList),
          ),
      ],
    );
  }
}

class SpeciesData {
  final String species;
  final int frequency;
  final double pValue;
  final double lnp;
  final double plnp;

  SpeciesData(this.species, this.frequency, this.pValue, this.lnp, this.plnp);
}

class SpeciesDataSource extends DataTableSource {
  final List<SpeciesData> speciesDataList;

  SpeciesDataSource(this.speciesDataList);

  @override
  DataRow getRow(int index) {
    final speciesData = speciesDataList[index];
    return DataRow(cells: [
      DataCell(Text(speciesData.species)),
      DataCell(Text(speciesData.frequency.toString())),
      DataCell(Text(speciesData.pValue.toStringAsFixed(3))),
      DataCell(Text(speciesData.lnp.toStringAsFixed(3))),
      DataCell(Text(speciesData.plnp.toStringAsFixed(3))),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => speciesDataList.length;

  @override
  int get selectedRowCount => 0;
}