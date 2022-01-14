class UserData {

  String id;
  String name;
  int score;
  int win;
  int onlineScore;

  UserData({
    this.id,
    this.name,
    this.score,
    this.win,
    this.onlineScore
  });



  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'win' : win,
      'onlineScore' : score
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
      win: value['win'],
      onlineScore: value['onlineScore']
    );
  }

}