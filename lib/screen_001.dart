import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:bhr_test/graph/graph_data_test.dart';
import 'package:bhr_test/graph/graph_made_test.dart';

List<double> sibal = [];
bool quitsock = false;

class screen_001 extends StatelessWidget {
  const screen_001({Key? key}) : super(key: key);
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  late TextEditingController _controller;
  late TextEditingController _controller2;

  List<double> _sibal = [];
  String _ip = '';
  int? _port;
  String _ipconfig = '';
  bool _gostop = false;
  bool _greyTextinput = true;
  int _txtlenth = 0;
  int _txtlenth2 = 0;
  final int _maxtextlen = 15;
  final int _maxtextlen2 = 4;

  // 위젯 생성될 때 처음으로 호출되는 메서드
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller2 = TextEditingController();
    sibal = [];
    quitsock = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const String _title = 'Createch Sample';

  // 통신 함수
  void sock() async {
    //소켓 라이브러리 사용 ip, port 입력
    Socket socket =
        await Socket.connect(_ip, _port!, timeout: Duration(seconds: 1));
    //연결 확인 메세지
    print('Connected to: '
        '${socket.remoteAddress.address}:${socket.remotePort}');

    // 현재 시간(import intl 라이브러리)
    var date = DateFormat('hh:mm:ss').format((DateTime.now()));
    // 현재 시간 메시지 보내기
    socket.add(utf8.encode(date));
    // 데이터 받아오기
    await socket.listen((
      Uint8List data,
    ) {
      // "data"의 Uint8List타입을 String 타입으로 변경 후 "res" 저장
      var res = String.fromCharCodes(data);
      // "res" 값이 "Close"와 일치할 경우 접속 파괴
      if (res == "Close") {
        //접속 파괴
        socket.destroy();
        print("close");
      } // 그 외 시작
      else {
        setState(() {
          _sibal = [];
          ByteData byteData = data.buffer.asByteData();
          List<double> floatList = [
            for (var offset = 0; offset < data.length; offset += 8)
              byteData.getFloat64(offset, Endian.big),
          ];
          var dap;
          for (var i = 0; i < floatList.length; i++) {
            dap = floatList[i].toStringAsFixed(6);
            double? fap = double.tryParse(dap);
            _sibal.add(fap!);
          }
          _ipconfig = _sibal.toString();
          sibal = _sibal;
          if (quitsock == true) {
            socket.destroy();
          }
        });
      } // 그 외 종료
    }, //에러 구간 시작
        onError: (error) {
      print(error);
      socket.close();
    }, //에러 구간 종료
        // 통신 종료 됬을 시
        onDone: () {
      print('Server left.');
      _gostop = false;
      socket.close();
    }); // 통신 종료 됬을 시
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
          title: Text(_title),
          centerTitle: true,
          primary: true,
          backgroundColor: Colors.black12,
          foregroundColor: Colors.white,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search_rounded),
              onPressed: () {
                print('fuckyou');
              },
            ),
          ]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/CREATECH_LOGO.png'),
                backgroundColor: Colors.white,
              ),
              accountName: Text('sgkim'),
              accountEmail: Text('sgkim@createch.co.kr'),
              onDetailsPressed: () {
                print('arrow is clicked');
              },
              decoration: BoxDecoration(
                color: Colors.grey[850],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.grey[850],
              ),
              title: Text('home'),
              onTap: () {
                print('home is clicked');
              },
            )
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(children: [
            TextField(
              style: TextStyle(color: Colors.white),
              maxLength: _maxtextlen,
              enabled: _greyTextinput,
              controller: _controller,
              cursorColor: Colors.white,
              onSubmitted: (String value) {
                print('$value');
                setState(() {
                  _ip = value;
                });
              },
              onChanged: (String value) {
                setState(() {
                  _txtlenth = value.length;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                labelStyle: TextStyle(color: Colors.grey[600]),
                labelText: 'Input IP Address(Only Number)',
                counterText: '',
                suffix: Text(
                  '$_txtlenth/$_maxtextlen',
                  style: (TextStyle(color: Colors.grey[600])),
                ),
              ),
              onTap: () {
                _controller.clear();
              },
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    maxLength: _maxtextlen2,
                    enabled: _greyTextinput,
                    controller: _controller2,
                    cursorColor: Colors.white,
                    onSubmitted: (String port) {
                      print('$port');
                      setState(() {
                        _port = int.parse(port);
                      });
                    },
                    onChanged: (String value) {
                      setState(() {
                        _txtlenth2 = value.length;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[900],
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      labelText: 'Input Port(Only Number)',
                      counterText: '',
                      suffix: Text(
                        '$_txtlenth2/$_maxtextlen2',
                        style: (TextStyle(color: Colors.grey[600])),
                      ),
                    ),
                    onTap: () {
                      _controller2.clear();
                    },
                  ),
                )
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Wrap(
                spacing: 10,
                children: [
                  TextButton(onPressed: () {}, child: Text('ping')),
                  TextButton(
                      onPressed: () async {
                        if (_gostop == true) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Already run'),
                            duration: Duration(milliseconds: 500),
                            action: SnackBarAction(
                              label: '',
                              onPressed: () {},
                            ),
                          ));
                        } else {
                          sock();
                          print('go');
                          setState(() {
                            _ip = _controller.text;
                            _port = int.parse(_controller2.text);
                            _greyTextinput = false;
                            quitsock = false;
                            _gostop = true;
                          });
                        }
                      },
                      child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey[850]))),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _gostop = false;
                        _greyTextinput = true;
                        quitsock = true;
                      });
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[850])),
                  )
                ],
              )
            ]),
            Wrap(
              children: [
                Container(
                  color: Colors.grey[850],
                  width: MediaQuery.of(context).size.width,
                  height: 20,
                  child: Text(
                    _ipconfig,
                    style: TextStyle(color: Colors.white54),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            Container(child: LineChartWidget(pricePoints))
          ]),
        ),
      ),
    );
  }
}
