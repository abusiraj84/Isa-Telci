import 'package:flutter/material.dart';
import 'package:isa_telci/Services/api_service.dart';

class ApiTest extends StatefulWidget {
  ApiTest({Key key}) : super(key: key);

  @override
  _ApiTestState createState() => _ApiTestState();
}

class _ApiTestState extends State<ApiTest> {
  ApiService _apiService;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiService = ApiService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: FutureBuilder(
          future: _apiService.getSongs(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.hasData)
              return Text("DATA: ${snapshot.data}");
            else if (snapshot.hasError)
              return Text("ERROR: ${snapshot.error}");
            else
              return Text('None');
          }),
    );
  }
}
