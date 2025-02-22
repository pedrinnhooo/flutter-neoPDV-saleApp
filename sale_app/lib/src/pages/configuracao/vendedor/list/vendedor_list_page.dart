import 'package:common_files/common_files.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:fluggy/src/app_module.dart';
import 'package:fluggy/src/pages/widgets/Drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/configuracao/vendedor/detail/vendedor_detail_page.dart';
import 'package:fluggy/src/pages/configuracao/vendedor/vendedor_module.dart';

class VendedorListPage extends StatefulWidget {
  @override
  _VendedorListPageState createState() => _VendedorListPageState();
}

class _VendedorListPageState extends State<VendedorListPage> {
  VendedorBloc vendedorBloc;
  SharedVendaBloc sharedVendaBloc;
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    vendedorBloc = VendedorModule.to.getBloc<VendedorBloc>();
    _scaffoldKey  = GlobalKey<ScaffoldState>();
    try {
      sharedVendaBloc = AppModule.to.getBloc<SharedVendaBloc>();
    } catch (e) {
      sharedVendaBloc = null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    Future _initRequester() async {
      return vendedorBloc.getAllPessoa();
    }

    Future<List> _dataRequester() async {
      return Future.delayed(Duration(milliseconds: 100), () async {
        return await vendedorBloc.getAllPessoa();
      });
    }

    Function _itemBuilder = (List dataList, BuildContext context, int index) {
      return ListTile(
        title: Text("${dataList[index].razaoNome}",
            style: Theme.of(context).textTheme.body2,
          ),
        trailing: Container(
          height: 30,
          width: 30,
          child: InkWell(
            child: Icon(
              Icons.edit, 
              color: Theme.of(context).primaryIconTheme.color),
            onTap: () async {
              await vendedorBloc.getPessoaById(dataList[index].id);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => VendedorDetailPage(),
                  settings: RouteSettings(name: '/DetalheVendedor'),
                  transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 180),
                ),
              );
            },
          ),
        ),
        onTap: () {
          if(sharedVendaBloc != null){
            sharedVendaBloc.setVendedorMovimento(dataList[index].id, dataList[index].razaoNome);
            Navigator.pop(context);
          }
        },
      );
    };

    Widget header = Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 4,
                child: Container(
                padding: EdgeInsets.only(left: 15),
                child: TextField(
                  style: Theme.of(context).textTheme.body2,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.white70),
                    hintText: locale.palavra.pesquisar,
                    hintStyle: Theme.of(context).textTheme.body2,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white70),
                    ), 
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white70),
                    ), 
                  ),
                  onSubmitted: (text) async {
                    vendedorBloc.filtroNome = text;
                    vendedorBloc.offset = 0;
                    vendedorBloc.getAllPessoa();
                  },
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: FloatingActionButton(
                        mini: true,
                        backgroundColor: Theme.of(context).primaryIconTheme.color,
                        child: Icon(Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await vendedorBloc.newPessoa();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => VendedorDetailPage(),
                              settings: RouteSettings(name: '/DetalheVendedor'),
                              transitionsBuilder: (c, anim, a2, child) => FadeTransition( opacity: anim, child: child),
                              transitionDuration: Duration(milliseconds: 180),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )
              ),
            )
          ],
        ),
      )
    );

    Widget body = Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),  
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).accentColor,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[ 
                    Expanded(
                      child: DynamicListView.build(
                        bloc: vendedorBloc,
                        stream: vendedorBloc.pessoaListOut,
                        itemBuilder: _itemBuilder,
                        dataRequester: _dataRequester,
                        initRequester: _initRequester,
                        initLoadingWidget: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: CircularProgressIndicator(backgroundColor: Colors.white,),
                        ),
                        moreLoadingWidget: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: CircularProgressIndicator(backgroundColor: Colors.white,),
                        ),
                      ),
                    )
                  ]
                )
              )
            ]
          )
        )
      )
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(locale.cadastroVendedor.titulo, 
          style: Theme.of(context).textTheme.title,
        ),
        leading:  StreamBuilder(
          stream: vendedorBloc.appGlobalBloc.configuracaoGeralOut,
          builder: (context, snapshot) {
            if (!snapshot.hasData){
              return CircularProgressIndicator();
            }
            ConfiguracaoGeral configuracaoGeral = snapshot.data;
            return IconButton(
              icon: Icon(configuracaoGeral.ehMenuClassico == 1 ? 
              Icons.menu : Icons.arrow_back,color: Theme.of(context).primaryIconTheme.color),
              onPressed: () {
                if (configuracaoGeral.ehMenuClassico == 1) {
                  _scaffoldKey.currentState.openDrawer();
                } else { 
                  Navigator.pop(context);
                }
              }
            );
          }
        ),
      ),
      drawer: DrawerApp(),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            header,
            body
          ],
        ),
      ),
    );
  }
}
