class travel {
  final int id;
  final String name;
  final String description;
  final String image;

  travel({required this.id, required this.name, required this.description, required this.image});

  factory travel.fromJson(Map<String, dynamic> json) {
    return travel(
      id: int.parse(json['id'].toString()), // กันเหนียวเผื่อ API ส่งเป็น String
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }
}