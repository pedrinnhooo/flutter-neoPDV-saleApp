import 'package:common_files/common_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluggy/src/AppConfig.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/venda/pagamento/pagamento_desconto/pagamento_desconto_bloc.dart';
import 'package:fluggy/src/venda/pagamento/pagamento_desconto/pagamento_desconto_module.dart';

class PagamentoDescontoPage extends StatefulWidget {
  @override
  _PagamentoDescontoPageState createState() => _PagamentoDescontoPageState();
}

class _PagamentoDescontoPageState extends State<PagamentoDescontoPage> {
  SharedVendaBloc vendaBloc = AppModule.to.getBloc<SharedVendaBloc>();
  PagamentoDescontoBloc pagamentoDescontoBloc =
      PagamentoDescontoModule.to.getBloc<PagamentoDescontoBloc>();
  MoneyMaskedTextController valorLiquido = MoneyMaskedTextController();
  String _valorDigitado = "0,00";
  String _txt = "";
  bool _firstDig = true;

  @override
  Widget build(BuildContext context) {
    valorLiquido.updateValue(vendaBloc.movimento.valorTotalLiquido);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/palavraFluggy.png',
              fit: BoxFit.contain,
              height: 40,
            )
          ],
        ),
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 220,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).accentColor,
                  ),
                  child: Column(
                    children: <Widget>[
                      StreamBuilder<IsValue>(
                        initialData: IsValue(),
                        stream: pagamentoDescontoBloc.isValueOut,
                        builder: (context, snapshot) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _valorDigitado = "0,00";
                                    _txt = "";
                                  });
                                  pagamentoDescontoBloc.setValue();
                                },
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Icon(Icons.attach_money,
                                            size: 50,
                                            color: snapshot.data.isValue
                                                ? Theme.of(context).primaryIconTheme.color
                                                : Colors.grey)),
                                    Text("Valor",
                                        style: TextStyle(
                                            fontSize:
                                                AppConfig.safeBlockHorizontal * 4.5,
                                            color: snapshot.data.isValue
                                                ? Theme.of(context).primaryIconTheme.color
                                                : Colors.grey))
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _valorDigitado = "0,00";
                                    _txt = "";
                                  });
                                  pagamentoDescontoBloc.setValue();
                                },
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text("%", style: TextStyle(fontSize: 39,
                                            color: !snapshot.data.isValue
                                                ? Theme.of(context).primaryIconTheme.color
                                                : Colors.grey))),
                                    Text("Percentual",
                                        style: TextStyle(
                                            fontSize:
                                                AppConfig.safeBlockHorizontal * 4.5,
                                            color: !snapshot.data.isValue
                                                ? Theme.of(context).primaryIconTheme.color
                                                : Colors.grey))
                                  ],
                                ),
                              )
                            ],
                          );
                        }),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                StreamBuilder<IsValue>(
                                  stream: pagamentoDescontoBloc.isValueOut,
                                  builder: (context, snapshot) {
                                    return Text(pagamentoDescontoBloc.isValue.texto, 
                                      style: Theme.of(context).textTheme.body2,);
                                  }
                                ),
                                Text(" $_valorDigitado", style: Theme.of(context).accentTextTheme.display1,),
                              ],
                            ),
                            Text(
                              "Valor restante R\$ ${valorLiquido.text}",
                              style: Theme.of(context).textTheme.body2,
                            ),
                          ],
                        ),
                      ),
                    ]
                  )
                ),
              )
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  childAspectRatio: 1.2,
                  padding: const EdgeInsets.all(10.0),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  children: <String>[
                    // @formatter:off
                    '7', '8', '9',
                    '4', '5', '6',
                    '1', '2', '3',
                    'DEL', '0', 'OK',
                    // @formatter:on
                  ].map((key) {
                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: GridTile(
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)
                          ),
                        splashColor: Theme.of(context).primaryColor,
                        child: Text(
                          key,
                          style: TextStyle(
                            fontSize: 26.0,
                            color: Colors.white,
                          ),
                        ),
                        color: key == "DEL" ? 
                          Colors.red : key == "OK" ? Colors.green[400]:
                          Theme.of(context).accentColor,
                        onPressed: () {
                          if (key == "OK") {
                            if (_valorDigitado != "0,00") {
                              _valorDigitado = _valorDigitado.replaceAll(".", "");
                              if (vendaBloc.movimento.valorTotalDesconto != null) {
                                vendaBloc.movimento.valorTotalDesconto = 0;
                                vendaBloc.addDescontoMovimento(percent: !pagamentoDescontoBloc.isValue.isValue
                                      ? getOnlyValue(formatValue(_txt)).round()
                                      : 0,
                                  value: pagamentoDescontoBloc.isValue.isValue
                                      ? getOnlyValue(formatValue(_txt))
                                      : 0,
                                );
                              }
                              Navigator.pop(context);
                            }
                          } else if (key == "DEL") {
                              setState(() {
                                if ((_txt == "") || (_txt.length == 1)) {
                                  _firstDig = true;
                                  _txt = "0";
                                } else {
                                  _txt = _txt.substring(0, _txt.length - 1);
                                }
                                _valorDigitado = formatValue(_txt);
                              });
                            } else {
                              setState(() {
                                //if (pagamentoDescontoBloc.isValue.isValue && _valorDigitado.length < valorLiquido.text.length) {
                                if (pagamentoDescontoBloc.isValue.isValue && (double.parse(_valorDigitado.replaceAll(",", ".")) < valorLiquido.numberValue)) {
                                  _txt = _firstDig ? key : _txt + key;
                                  _firstDig = false;
                                    _valorDigitado = getOnlyValue(formatValue(_txt)) > vendaBloc.movimento.valorTotalBruto
                                        ? valorLiquido.text
                                        : formatValue(_txt);
                                    //_valorDigitado = getOnlyValue(_valorDigitado) > vendaBloc.movimento.valorTotalBruto ?
                                    // _valorDigitado : formatValue(_txt);
                                } else {
                                  if(!pagamentoDescontoBloc.isValue.isValue && _valorDigitado.length <= valorLiquido.text.length){
                                  _txt = _firstDig ? key : _txt + key;
                                  _firstDig = false;
                                  _valorDigitado = (getOnlyValue(formatValue(_txt)) > 100.0)
                                          ? "100,00"
                                          : formatValue(_txt);
                                  }
                                }
                              }
                            );
                          }
                        },
                      )),
                    );
                  }).toList(),
                ),
              )
            ),
          ],
        ),
      )
    );
  }

  String formatValue(String value) {
    switch (value.length) {
      case 1:
        return "0,0" + value;
        break;
      case 2:
        return "0," + value;
        break;
      case 3:
        return value.substring(0, 1) + "," + value.substring(1, value.length);
        break;
      case 4:
        return value.substring(0, 2) + "," + value.substring(2, value.length);
        break;
      case 5:
        return value.substring(0, 3) + "," + value.substring(3, value.length);
        break;
      case 6:
        return value.substring(0, 1) +
            "." +
            value.substring(1, 4) +
            "," +
            value.substring(4, value.length);
        break;
      case 7:
        return value.substring(0, 2) +
            "." +
            value.substring(2, 5) +
            "," +
            value.substring(5, value.length);
        break;
      case 8:
        return value.substring(0, 3) +
            "." +
            value.substring(3, 6) +
            "," +
            value.substring(6, value.length);
        break;
      default:
    }
  }

  double getOnlyValue(String value) {
    String _temp;
    double _value;
    _temp = value.replaceAll(".", "");
    _temp = _temp.replaceAll(",", ".");
    _value = double.parse(_temp);
    return _value;
  }
}