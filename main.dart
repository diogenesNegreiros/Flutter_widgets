
//Desenvolvedor: Diogenes de Souza Negreiros

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize(getAppId());
  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize bannerSize = AdmobBannerSize.BANNER;
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;

  @override
  void initState() {
    super.initState();
  
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );

    rewardAd = AdmobReward(
        adUnitId: getRewardBasedVideoAdUnitId(),
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          if (event == AdmobAdEvent.closed) rewardAd.load();
          handleEvent(event, args, 'Reward');
        });

    interstitialAd.load();
    rewardAd.load();
  }

  void handleEvent(AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(content),
      duration: Duration(milliseconds: 1500),
    ));
  }

  String _textfieldText = "";

  bool _estaSelecionadoBox1 = false;
  bool _estaSelecionadoBox2 = false;
  bool _estaSelecionadoBox3 = false;
  bool _estaSelecionadoBox4 = false;

  var _textButonCheck = "RaisedButton - Checkbox";

  String _radioEscolha = "?";
  String _radioListEscolha = "?";
  String _textRadio = "RaisedButton - Radio";
  String _textRadioList = "RaisedButton - RadioListTile";

  bool _switchEstado = false;
  bool _switchListTileEstado = false;

  double slideValue1 = 0;
  double slideValue2 = 2.5;

  Icon floatIcon = Icon(Icons.done);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(

        key: scaffoldState,
//        appBar: AppBar(
//          title: const Text('Flutter '),
//        ),
        bottomNavigationBar: Builder(
          builder: (BuildContext context) {
            return Container(
              color: Colors.blueGrey,
              child: SafeArea(
                child: SizedBox(
                  height: 40,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          child: Text(
                            'Show Interstitial',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (await interstitialAd.isLoaded) {
                              interstitialAd.show();
                            } else {
                              showSnackBar("Interstitial ad is still loading...");
                            }
                          },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          child: Text(
                            'Show Reward',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (await rewardAd.isLoaded) {
                              rewardAd.show();
                            } else {
                              showSnackBar("Reward ad is still loading...");
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        body: Container(
          color: Colors.grey,
          padding: EdgeInsets.only(top: 40),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 10,right: 10),
                  color: Colors.grey,
                  margin: EdgeInsets.only(bottom:0),
                  child: AdmobBanner(
                    adUnitId: getBannerAdUnitId(),
                    adSize: AdmobBannerSize.BANNER,
                    listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                      handleEvent(event, args, 'Banner');
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child:  Text("Image example", textAlign: TextAlign.center),
                ),

                Container(
                  child: Image.asset("images/widget.png"),
                ),
                Container(

                  width: double.infinity,
                  color: Colors.grey[300],
                  padding: EdgeInsets.only(top: 10, left: 5),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("TextField") ,
                      ),

                      TextField(
                        decoration: InputDecoration(labelText:"text"),
                        keyboardType: TextInputType.text,
                        enabled: true,
                        maxLength: 20,
                        maxLengthEnforced: false,
                        onChanged: (texto){
                          setState(() {
                            _textfieldText = texto;
                          });
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(labelText:"date"),
                        keyboardType: TextInputType.datetime,
                        enabled: true,
                        maxLength: 10,
                        maxLengthEnforced: true,
                        onChanged: (texto){
                          setState(() {
                            _textfieldText = texto;
                          });
                        },
                      ),
                      TextField(
                        decoration: InputDecoration(labelText:"number"),
                        keyboardType: TextInputType.number,
                        enabled: true,
                        maxLength: 5,
                        maxLengthEnforced: false,
                        onChanged: (texto){
                          setState(() {
                            _textfieldText = texto;
                          });
                        },
                      ),

                      TextField(
                        decoration: InputDecoration(labelText:"password"),
                        keyboardType: TextInputType.text,
                        enabled: true,
                        maxLength: 6,
                        obscureText: true,
                        maxLengthEnforced: true,
                        onChanged: (texto){
                          setState(() {
                            _textfieldText = texto;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 5, left: 5),
                    child:Container(
//                color: Colors.grey[300],
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("1-Check"),
                          Checkbox(value: _estaSelecionadoBox1,
                              onChanged: (bool valor){
                                setState(() {
                                  _estaSelecionadoBox1 = valor;
                                });
                              } ),
                          Text("2-Check"),
                          Checkbox(value: _estaSelecionadoBox2,
                              onChanged: (bool valor){
                                setState(() {
                                  _estaSelecionadoBox2 = valor;
                                });
                              } ),
                          Text("3-Check"),
                          Checkbox(value: _estaSelecionadoBox3,
                              onChanged: (bool valor){
                                setState(() {
                                  _estaSelecionadoBox3 = valor;
                                });
                              } ),
                        ],
                      ),
                    )
                ),

                CheckboxListTile(
                    value: _estaSelecionadoBox4,
                    title: Text("4-CheckboxListTile"),
                    subtitle: Text("linha clicável"),
                    secondary: Icon(Icons.add),
//                  activeColor: Colors.green,
                    selected: false,
                    onChanged: (bool valor){
                      setState(() {
                        _estaSelecionadoBox4 = valor;
                      });
                    } ),

                RaisedButton(
                    color: Colors.blue,
                    child: Text(_textButonCheck, style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      setState(() {
                        _textButonCheck = "1("+ _estaSelecionadoBox1.toString()+ "), 2("+ _estaSelecionadoBox2.toString()+ "), "
                            "3("+ _estaSelecionadoBox3.toString()+ "), 4("+ _estaSelecionadoBox4.toString()+ ")";
                      });
                    }),

                Container(
                  padding: EdgeInsets.only(left: 5),
                  color: Colors.grey[300],
                  child: Row(
                    children: <Widget>[
                      Text("(1)"),
                      Radio(
                          value: "1",
                          groupValue: _radioEscolha,
                          onChanged: (String escolha){
                            setState(() {
                              _radioEscolha = escolha;
                            });
                          }
                      ),
                      Text("(2)"),
                      Radio(
                          value: "2",
                          groupValue: _radioEscolha,
                          onChanged: (String escolha){
                            setState(() {
                              _radioEscolha = escolha;
                            });
                          }
                      ),
                      RaisedButton(
                          color: Colors.blue,
                          child: Text(_textRadio, style: TextStyle(color: Colors.white)),
                          onPressed: (){
                            setState(() {
                              _textRadio = _radioEscolha;
                            });
                          })
                    ],
                  ),
                ),
                RadioListTile(
                    value: "1",
                    title: Text("1-RadioListTile"),
                    groupValue: _radioListEscolha,
                    onChanged: (String escolha){
                      setState(() {
                        _radioListEscolha = escolha;
                      });
                    }
                ),
                RadioListTile(
                    value: "2",
                    title: Text("2-RadioListTile"),
                    groupValue: _radioListEscolha,
                    onChanged: (String escolha){
                      setState(() {
                        _radioListEscolha = escolha;
                      });
                    }
                ),
                RaisedButton(
                    color: Colors.blue,
                    child: Text(_textRadioList, style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      setState(() {
                        _textRadioList = _radioListEscolha;
                      });
                    }),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  color: Colors.grey[300],
                  child: Column(
                    children: <Widget>[
                      Text("Switch - " + _switchEstado.toString()),
                      Switch(
                          value: _switchEstado,
                          onChanged: (bool estado){
                            setState(() {
                              _switchEstado = estado;
                            });
                          }
                      ),
                      SwitchListTile(
                          title: Text("SwitchListTile - "+ _switchListTileEstado.toString()),
                          subtitle: Text("subtitle example.."),
                          value: _switchListTileEstado,
                          onChanged: (bool estado){
                            setState(() {
                              _switchListTileEstado = estado;
                            });
                          }
                      ),

                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text("Slider")),

                      Slider(
                          value: slideValue1,
                          activeColor: Colors.blue,
                          inactiveColor: Colors.amber[100],
                          label: slideValue1.toString(),
                          min: 0,
                          max: 10,
                          divisions: 10,
                          onChanged: (double newValue){
                            setState(() {
                              slideValue1 = newValue;
                            });
                          }
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50, right: 50),
                        child: Row(
                          children: <Widget>[
                            Text(slideValue2.toString()),
                            Slider(
                                value: slideValue2,
                                activeColor: Colors.red,
                                inactiveColor: Colors.grey[400],
                                label: slideValue2.toString(),
                                divisions: 10,
                                min: 0,
                                max: 5,
                                onChanged: (double newValue){
                                  setState(() {
                                    slideValue2 = newValue;
                                  });
                                }
                            )
                          ],
                        ),

                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 15, left: 15),

                  color: Colors.grey[300],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child:  Text("FloatingActionButton")
                      ),

                      Padding(
                          padding: EdgeInsets.all(10),
                          child: floatIcon
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child:  FloatingActionButton(
                              child: Icon(Icons.navigation),
                              onPressed: (){
                                setState(() {
                                  floatIcon = Icon(Icons.navigation);
                                });
                              },
                              backgroundColor: Colors.green,

                            ) ,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child:  FloatingActionButton(
                              child: Icon(Icons.add),
                              onPressed: (){
                                setState(() {
                                  floatIcon = Icon(Icons.add);
                                });
                              },
                              backgroundColor: Colors.blue,

                            ) ,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child:  FloatingActionButton(
                              child: Icon(Icons.alarm),
                              onPressed: (){
                                setState(() {
                                  floatIcon = Icon(Icons.alarm);
                                });
                              },
                              backgroundColor: Colors.amber,

                            ) ,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),

                            child:  FloatingActionButton(
                              child: Icon(Icons.share),
                              backgroundColor: Colors.grey,
                              onPressed: (){
                                setState(() {
                                  floatIcon = Icon(Icons.share);
                                });
                              },


                            ) ,
                          ),

                        ],
                      ),
                     Container(
                       padding: EdgeInsets.only(top: 60,bottom: 30),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.stretch,
                         children: <Widget>[
                           RaisedButton(
                               color: Colors.green[800],
                               child: Text("Source code", style: TextStyle(color: Colors.white),),
                               onPressed: (){
                                 _launchInWebViewOrVC("https://raw.githubusercontent.com/diogenesNegreiros/Flutter_widgets/master/main.dart");
                               }),
                           RaisedButton(

                               color: Colors.blueGrey,
                               child: Text("GitHub", style: TextStyle(color: Colors.white),),
                               onPressed: (){
                                 _launchInBrowser("https://github.com/diogenesNegreiros/Flutter_widgets");
                               }),
                           RaisedButton(

                               color: Colors.blue[900],
                               child: Text("About Flutter", style: TextStyle(color: Colors.white),),
                               onPressed: (){
                                 _launchInBrowser("https://flutter.dev/");
                               }),
                         ],
                       ),
                     )
                    ],
                  ),
                )

              ],
            ),


          ),

        ),

        bottomSheet: Container(
          width: double.infinity,
          color: Colors.white,
          margin: EdgeInsets.only(bottom:3, top: 3),
          child: AdmobBanner(
            adUnitId: getBannerAdUnitId(),
            adSize: bannerSize,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              handleEvent(event, args, 'Banner');
            },
          ),
        ),

      ),

    );
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    rewardAd.dispose();
    super.dispose();
  }
}

/*

App Id
Android: ca-app-pub-3940256099942544~3347511713
iOS: ca-app-pub-3940256099942544~1458002511

Banner
Android: ca-app-pub-3940256099942544/6300978111
iOS: ca-app-pub-3940256099942544/2934735716

Interstitial
Android: ca-app-pub-3940256099942544/1033173712
iOS: ca-app-pub-3940256099942544/4411468910

Reward Video
Android: ca-app-pub-3940256099942544/5224354917
iOS: ca-app-pub-3940256099942544/1712485313
*/

String getAppId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544~1458002511';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544~3347511713';
  }
  return null;
}

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111';
  }
  return null;
}

String getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/4411468910';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/1033173712';
  }
  return null;
}

String getRewardBasedVideoAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/1712485313';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/5224354917';
  }
  return null;
}

_launchInWebViewOrVC(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      enableJavaScript: true,
      headers: <String, String>{'my_header_key': 'my_header_value'},

    );
  } else {
    throw 'Could not launch $url';
  }
}

_launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}
