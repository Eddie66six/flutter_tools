class AssetsApp {
  AssetsApp._();
  static AssetsApp? _instance;
  static AssetsApp get to => _instance ??= AssetsApp._();

  String get gitLogo => "assets/logo/git.png";
}