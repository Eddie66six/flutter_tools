import 'package:flutter/material.dart';
import 'package:flutter_tools/component/transparent_app_bar.dart';
import 'package:flutter_tools/git/gitService.dart';
import 'package:flutter_tools/util/local_storage_service.dart';
import 'package:flutter_tools/util/sized_app.dart';

class GitPage extends StatefulWidget {
  @override
  _GitPageState createState() => _GitPageState();
}

class _GitPageState extends State<GitPage> {
  String? _gitPath;
  String? _mesage;
  bool _inProgresss = false;
  var _listPath = <String>[];
  var _textEditingController = TextEditingController();
  var gitService = GitService();
  var scrollController = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      _listPath = await LocalStorageService.to.getPathData();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String?> _showDialogCommit() {
    var _textEditingControllerCommit = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new TextField(
            controller: _textEditingControllerCommit,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Commit text"
            ),
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text("Salvar"),
              onPressed: () {
                if(_textEditingControllerCommit.text.isEmpty) return;
                Navigator.of(context).pop(_textEditingControllerCommit.text);
              },
            ),
          ],
        );
      },
    );
  }

  void action({
      Future<void> Function(String, dynamic Function(String))? func1,
      Future<void> Function(String, dynamic Function(String), String)? func2
    }) async{
    if(_gitPath == null || _gitPath!.isEmpty){
      const snackBar = SnackBar(
        content: Text('Caminha da pasta do git é obrigatorio'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if(func1 != null){
      _inProgresss = true;
      setState(() {});
      await func1(_gitPath!, (String mesage) {
        _mesage = mesage;
        setState(() {});
      });
    }
    else {
      var commit = await _showDialogCommit();
      if(commit == null || commit.isEmpty) return;

      _inProgresss = true;
      setState(() {});
      await func2!(_gitPath!, (String mesage) {
        _mesage = mesage;
        setState(() {});
      }, commit);
    }


    if(_listPath.indexOf(_gitPath!) == -1){
      LocalStorageService.to.setPathData(_gitPath!);
      _listPath.add(_gitPath!);
    }
    _inProgresss = false;
    _textEditingController.text = "";
    _gitPath = "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransparentAppBar(),
      body: Padding(
        padding:const EdgeInsets.all(10.0),
        child: 
        _inProgresss == true ? Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text(_mesage ?? "")
            ],
          ),
        ) :
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.grey.shade200,
              height: SizedApp.to!.displaySize.height * 0.7,
              child: Column(
                children: [
                  Text("Ultimos caminhos acessados"),
                  Expanded(
                    child: Scrollbar(
                      controller: scrollController,
                      child: ListView(
                        controller: scrollController,
                        children: List.generate(_listPath.length, (index){
                          return GestureDetector(
                            onTap: () {
                              _gitPath = _listPath[index];
                              _textEditingController.text = _gitPath!;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(_listPath[index]),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      LocalStorageService.to.removePathData();
                      _listPath.clear();
                      setState(() {});
                    },
                    child: Text("Limpar lista"))
                ],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: "Caminho da pasta com .git"
              ),
              onChanged: (String value) => _gitPath = value,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    action(func1: gitService.removeLocalBranches);
                  },
                  child: Text('Limpar repositorios')
                ),
                TextButton(
                  onPressed: () async {
                    action(func2: gitService.removeCacheGitIgnore);
                  },
                  child: Text('Limpar cache gitignore')
                ),
              ],
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}