import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: DataTablePage(),
    );
  }
}

class DataModel {
  final int id;
  final String name;
  final int age;
  final String address; // New field
  final String occupation; // New field

  DataModel({
    required this.id,
    required this.name,
    required this.age,
    required this.address,
    required this.occupation,
  });
}
class Datacontroller extends GetxController {
  var dataList = <DataModel>[].obs;
  var visibleItemsCount = 10.obs;
  var pageIndex = 0.obs;

  var sortColumn = ''.obs;
  var isAscending = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() {
    var data = [
      DataModel(id: 1, name: 'John', age: 25, address: '123 Main St', occupation: 'Engineer'),
      DataModel(id: 2, name: 'Alice', age: 30, address: '456 Elm St', occupation: 'Doctor'),
      DataModel(id: 3, name: 'Bob', age: 35, address: '789 Oak St', occupation: 'Teacher'),
      DataModel(id: 4, name: 'Emily', age: 28, address: '101 Pine St', occupation: 'Artist'),
      DataModel(id: 5, name: 'Michael', age: 40, address: '222 Maple St', occupation: 'Lawyer'),
      DataModel(id: 6, name: 'Sophia', age: 27, address: '333 Cedar St', occupation: 'Designer'),
      DataModel(id: 7, name: 'David', age: 33, address: '444 Birch St', occupation: 'Writer'),
      DataModel(id: 8, name: 'Emma', age: 29, address: '555 Spruce St', occupation: 'Chef'),
      DataModel(id: 9, name: 'James', age: 32, address: '666 Walnut St', occupation: 'Developer'),
      DataModel(id: 10, name: 'Olivia', age: 26, address: '777 Fir St', occupation: 'Architect'),
      DataModel(id: 1, name: 'John', age: 25, address: '123 Main St', occupation: 'Engineer'),
      DataModel(id: 2, name: 'Alice', age: 30, address: '456 Elm St', occupation: 'Doctor'),
      DataModel(id: 3, name: 'Bob', age: 35, address: '789 Oak St', occupation: 'Teacher'),
      DataModel(id: 4, name: 'Emily', age: 28, address: '101 Pine St', occupation: 'Artist'),
      DataModel(id: 5, name: 'Michael', age: 40, address: '222 Maple St', occupation: 'Lawyer'),
      DataModel(id: 6, name: 'Sophia', age: 27, address: '333 Cedar St', occupation: 'Designer'),
      DataModel(id: 7, name: 'David', age: 33, address: '444 Birch St', occupation: 'Writer'),
      DataModel(id: 8, name: 'Emma', age: 29, address: '555 Spruce St', occupation: 'Chef'),
      DataModel(id: 9, name: 'James', age: 32, address: '666 Walnut St', occupation: 'Developer'),
      DataModel(id: 10, name: 'Olivia', age: 26, address: '777 Fir St', occupation: 'Architect'),
    ];
    dataList.assignAll(data);
  }


  void setPageIndex(int index) {
    pageIndex.value = index;
  }

  void setVisibleItemsCount(int count) {
    visibleItemsCount.value = count;
  }

  List<DataModel> get pagedData {
    final startIndex = pageIndex.value * visibleItemsCount.value;
    return dataList.skip(startIndex).take(visibleItemsCount.value).toList();
  }

  void sortData(bool ascending) {
    dataList.sort((a, b) => ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
  }
  void sortDataByColumn(String columnName) {
    if (sortColumn.value == columnName) {
      isAscending.value = !isAscending.value;
    } else {
      sortColumn.value = columnName;
      isAscending.value = true;
    }
    switch (columnName) {
      case 'id':
        dataList.sort((a, b) => isAscending.value ? a.id.compareTo(b.id) : b.id.compareTo(a.id));
        break;
      case 'name':
        dataList.sort((a, b) => isAscending.value ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        break;
      case 'age':
        dataList.sort((a, b) => isAscending.value ? a.age.compareTo(b.age) : b.age.compareTo(a.age));
        break;
    }
  }
  void filterData(String query) {
    if (query.isEmpty) {
      fetchData();
    } else {
      var filteredData = dataList.where((item) => item.name.toLowerCase().contains(query.toLowerCase())).toList();
      dataList.assignAll(filteredData);
    }
  }
  void filterByAgeRange(int minAge, int maxAge) {
    var filteredData = dataList.where((item) => item.age >= minAge && item.age <= maxAge).toList();
    dataList.assignAll(filteredData);
  }
}

class DataTablePage extends StatelessWidget {
  final Datacontroller controller = Get.put(Datacontroller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Table with Pagination, Sorting, Filtering'),
        actions: [
          IconButton(
            onPressed: () {
              _showSortingDialog(context);
            },
            icon: Icon(Icons.short_text_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => controller.filterData(value),
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              return SfDataGrid(
                source: CustomDataGridSource(controller.pagedData),
                columns: [
                  GridColumn(
                    width: 80,
                    columnName: 'id',
                    label: Center(
                        child: Text('ID')),

                  ),
                  GridColumn(
                    width: 150,

                    columnName: 'name',
                    label: Center(child: Text('Name')),
                  ),
                  GridColumn(
                    width: 50,
                    columnName: 'age',
                    label: Center(child: Text('Age')),
                  ),
                  GridColumn(
                    width: 200,
                    columnName: 'address',
                    label: Center(child: Text('Address')),
                  ),
                  GridColumn(
                    width: 110,
                    columnName: 'occupation',
                    label: Center(child: Text('Occupation')),
                  ),
                ],
              );
            }),
          ),
          Obx(() {
            final pageCount = (controller.dataList.length / controller.visibleItemsCount.value).ceil().toDouble();
            return pageCount > 0
                ? SfDataPager(
              delegate: CustomDataPagerDelegate(controller),
              pageCount: pageCount,
              visibleItemsCount: controller.visibleItemsCount.value,
              onPageNavigationStart: (pageIndex) {
                controller.setPageIndex(pageIndex);
              },
            )
                : Container();
          }),
        ],
      ),
    );
  }

  void _showSortingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sort and Filter Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Sort A to Z'),
                onTap: () {
                  controller.sortDataByColumn('name');
                  if (!controller.isAscending.value) controller.sortDataByColumn('name');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Sort Z to A'),
                onTap: () {
                  controller.sortDataByColumn('name');
                  if (controller.isAscending.value) controller.sortDataByColumn('name');
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                title: Text('Filter Age 1 to 18'),
                onTap: () {
                  controller.filterByAgeRange(1, 18);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Filter Age 18 to 25'),
                onTap: () {
                  controller.filterByAgeRange(18, 25);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Filter Age 25 to 32'),
                onTap: () {
                  controller.filterByAgeRange(25, 32);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Clear Age Filter'),
                onTap: () {
                  controller.fetchData();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomDataGridSource extends DataGridSource {
  CustomDataGridSource(this.data) {
    buildDataGridRows();
  }

  final List<DataModel> data;
  List<DataGridRow> _dataGridRows = [];

  void buildDataGridRows() {
    _dataGridRows = data.map<DataGridRow>((dataModel) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: dataModel.id),
        DataGridCell<String>(columnName: 'name', value: dataModel.name),
        DataGridCell<int>(columnName: 'age', value: dataModel.age),
        DataGridCell<String>(columnName: 'address', value: dataModel.address),
        DataGridCell<String>(columnName: 'occupation', value: dataModel.occupation),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[0].value.toString()),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[1].value.toString()),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[2].value.toString()),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[3].value.toString()),
      ),
      Container(
        padding: EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(row.getCells()[4].value.toString()),
      ),
    ]);
  }
}

class CustomDataPagerDelegate extends DataPagerDelegate {
  CustomDataPagerDelegate(this.controller);

  final Datacontroller controller;

  @override
  int get rowCount => controller.dataList.length;

  @override
  List<DataGridRow> getRows(int startIndex, int endIndex) {
    return controller.dataList
        .skip(startIndex)
        .take(endIndex - startIndex)
        .map((dataModel) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'id', value: dataModel.id),
      DataGridCell<String>(columnName: 'name', value: dataModel.name),
      DataGridCell<int>(columnName: 'age', value: dataModel.age),
      DataGridCell<String>(columnName: 'address', value: dataModel.address),
      DataGridCell<String>(columnName: 'occupation', value: dataModel.occupation),
    ]))
        .toList();
  }
}
