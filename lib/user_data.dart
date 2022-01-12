class UserData {

  String id;
  String name;
  String score;

  UserData({
    this.id,
    this.name,
    this.score,
  });



  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'score': score,
    };
  }

  static UserData fromMap(Map value) {
    if (value == null) {
      return null;
    }

    return UserData(
      id: value['id'],
      name: value['name'],
      score: value['score'],
    );
  }

}