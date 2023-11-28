class AppUser{
  static final emptyUser = AppUser(id: 'null', name: 'null', email: 'null');

  final String id;
  final String name;
  final String email;
  AppUser({required this.id, required this.name, required this.email});
}