

// Future<void> excelToJson(String fileName, String fileDirectory,GlobalKey<ScaffoldState> scaffoldKey) async {
//   ByteData data = await rootBundle.load(fileDirectory);
//   var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//   var excel = Excel.decodeBytes(bytes);
//   int i = 0;
//   List<dynamic> keys = new List<dynamic>();
//   List<Map<String, dynamic>> json = new List<Map<String, dynamic>>();
//   for (var table in excel.tables.keys) {
//     for (var row in excel.tables[table].rows) {
//       if (i == 0) {
//         keys = row;
//         i++;
//       } else {
//         Map<String, dynamic> temp = Map<String, dynamic>();
//         int j = 0;
//         String tk = '';
//         for (var key in keys) {
//           tk = '"' + key + '"';
//           temp[tk] = (row[j].runtimeType == String)
//               ? '"' + row[j].toString() + '"'
//               : row[j];
//           j++;
//         }
//         json.add(temp);
//       }
//     }
//   }
//   print(json.length);
//   String fullJson = json.toString().substring(1, json
//       .toString()
//       .length - 1);
//
//   fullJson = '{ "DATA" : [$fullJson]}';
//   final directory = await getExternalStorageDirectory();
//
//   File file = await File('${directory.path}/$fileName.json').create();
//   await file.writeAsString(fullJson).then((value) =>
//       scaffoldKey.currentState
//           .showSnackBar(SnackBar(content: Text("Completed")))
//   );
//   print(file.exists().toString());
// }
// Future<String> excelToJson() async {
//   FilePickerResult result =await FilePicker.platform.pickFiles(type:FileType.custom,allowedExtensions: ['xls','xlsx','csv']);
//   if (result != null) {
//     File excelFile = File(result.files.single.path);}
//   var bytes = File(excelFilePath).readAsBytesSync();
//   var excel = Excel.decodeBytes(bytes);
//   int i = 0;
//   List<dynamic> keys = [];
//   var jsonMap = [];
//
//   for (var table in excel.tables.keys) {
//     dev.log(table.toString());
//     for (var row in excel.tables[table].rows) {
//       dev.log(row.toString());
//       if (i == 0) {
//         keys = row;
//         i++;
//       } else {
//         var temp = {};
//         int j = 0;
//         String tk = '';
//         for (var key in keys) {
//           tk = '\"${key.toString()}\"';
//           temp[tk] = (row[j].runtimeType == String)
//               ?  '\"${row[j].toString()}\"'
//               : row[j];
//           j++;
//         }
//
//         jsonMap.add(temp);
//       }
//     }
//   }
//   dev.log(
//     jsonMap.length.toString(),
//     name: 'excel to json',
//   );
//   dev.log(jsonMap.toString(), name: 'excel to json');
//   String fullJson =
//   jsonMap.toString().substring(1, jsonMap.toString().length - 1);
//   dev.log(
//     fullJson.toString(),
//     name: 'excel to json',
//   );
//   return fullJson;
// }

