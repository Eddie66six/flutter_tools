import 'dart:io';
class GitService {
  var runInShell = true;
  Future<void> removeLocalBranches(String gitPath, Function(String) stepNotifier) async{
    try {
      stepNotifier("Atualizando repositorio local....");
      await Future.delayed(Duration(milliseconds: 500), () {});
      var forceDelete = true;
      List<String> localBranches = await _getLocalBranches(gitPath);
      List<String>  remoteBranches = await _getRemoteBranches(gitPath);

      await _statusBranch(gitPath);
      await _pruneBranch(gitPath);
      await _checkoutBranch(gitPath, 'master');
      await _pullBranch(gitPath);

      stepNotifier("Removendo branchs....");
      await Future.delayed(Duration(milliseconds: 500), () {});
      for (var branch in localBranches) {
        if(branch.trim().replaceAll('* ', '') == 'master') continue;
        if(!remoteBranches.any((e) => e.replaceAll('origin/', '').trim() == branch.replaceAll('* ', '').trim())){
          print(branch);
          await _deleteBranch(gitPath, branch.replaceAll('* ', '').trim(), force: forceDelete);
        }
      }
    } catch (e) {
      stepNotifier("Erro");
      await Future.delayed(Duration(milliseconds: 500), () {});
    }
  }

  Future<void> removeCacheGitIgnore(String gitPath, Function(String) stepNotifier, String messageCommit) async {
    try {
      stepNotifier("Removendo arquivos....");
      await _removeCache(gitPath);
      stepNotifier("Adicionando arquivos....");
      await _add(gitPath);
      stepNotifier("Commit....");
      await _commit(gitPath, messageCommit);
      await Future.delayed(Duration(milliseconds: 500), () {});
      
    } catch (e) {
      stepNotifier("Erro");
      await Future.delayed(Duration(milliseconds: 500), () {});
    }
  }

  _getRemoteBranches(String gitPath) async{
    var remoteBranches = [];
    await Process.run("git --git-dir ${_spacePath(gitPath, extra: '\\.git')} --work-tree ${_spacePath(gitPath)} branch -r", [], runInShell: runInShell).then((result) {
      remoteBranches = result.stdout.toString().split('\n');
    });
    return remoteBranches;
  }

  _getLocalBranches(String gitPath) async{
    try {
    var localBranches = [];
    await Process.run('git --git-dir ${_spacePath(gitPath, extra: '\\.git')} --work-tree ${_spacePath(gitPath)} branch', [], runInShell: runInShell).then((result) {
      localBranches = result.stdout.toString().split('\n');
    });
    return localBranches; 
    } catch (e) {
      print(e);
    }
  }

  _checkoutBranch(String gitPath, String branch) async {
    await Process.run("git --git-dir ${_spacePath(gitPath, extra: '\\.git')} --work-tree ${_spacePath(gitPath)} checkout $branch", [], runInShell: runInShell).then((result) {
      print(result.stderr);
    });
  }

  _pruneBranch(String gitPath) async{
    await Process.run("git --git-dir ${_spacePath(gitPath, extra: '\\.git')} --work-tree ${_spacePath(gitPath)} remote update --prune", [], runInShell: runInShell).then((result) {
      print(result.stderr);
    });
  }

  _deleteBranch(String gitPath, String branch, {bool force = false}) async{
    await Process.run("git --git-dir ${_spacePath(gitPath, extra: '\\.git')} --work-tree ${_spacePath(gitPath)} branch ${force ? '-D' : '-d'} $branch", [], runInShell: runInShell).then((result) {
      print(result.stderr);
    });
  }

  _pullBranch(String gitPath) async{
    await Process.run("git --git-dir ${_spacePath(gitPath, extra: '\\.git')} --work-tree ${_spacePath(gitPath)} pull", [], runInShell: runInShell).then((result) {
      print(result.stdout);
    });
  }

  _statusBranch(String gitPath) async{
    await Process.run("git --git-dir ${_spacePath(gitPath, extra: '\\.git')} --work-tree ${_spacePath(gitPath)} status", [], runInShell: runInShell).then((result) {
      print(result.stdout);
    });
  }

  String _spacePath(String path, {String extra = ""}){
    //var _path = path + extra;
    var _path = path;
    if(_path.indexOf(" ") > -1){
      if(_path.indexOf("\"") > -1){
        _path = _path.replaceAll("\"", "");
      }
      _path = "\"$_path$extra\"";
    }
    return "$_path$extra";
  }

  _removeCache(String gitPath) async{
    await Process.run("git --git-dir=${_spacePath(gitPath, extra: '\\.git')} --work-tree=${_spacePath(gitPath)} rm -r --cached .", [], runInShell: runInShell).then((result) {
      print(result.stdout);
    });
  }

  _add(String gitPath) async{
    await Process.run("git --git-dir=${_spacePath(gitPath, extra: '\\.git')} --work-tree=${_spacePath(gitPath)} add .", [], runInShell: runInShell).then((result) {
      print(result.stdout);
    });
  }

  _commit(String gitPath, String message) async{
    await Process.run("git --git-dir=${_spacePath(gitPath, extra: '\\.git')} --work-tree=${_spacePath(gitPath)} commit -m\"$message\"", [], runInShell: runInShell).then((result) {
      print(result.stdout);
    });
  }
}