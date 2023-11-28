class AppUser{
  static final emptyUser = AppUser(id: 'null', name: 'null');

  final String id;
  final String name;
  AppUser({required this.id, required this.name});
}