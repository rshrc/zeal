class post {
  String imageUrl;
  String caption = "";
  int likes = 0;
  List<String> comments = new List();

  void addComment(String comment) {
    comments.add(comment);
  }

  void serverUpdate() {
    // Do stuff
  }
}
