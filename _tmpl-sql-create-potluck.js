define(["_tag-builders"], function(builders){
  var io = {
    i: [
      "CREATE TABLE POTLUCK (",
      "  id INT PRIMARY KEY AUTO_INCREMENT,",
      "  signup_date DATE",
      ");",
    ],
    o: [
      "Query OK, 0 rows affected (0.03 sec)",
    ]
  };

  return builders.buildCodePair(io);
});
