define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "CREATE TABLE potluck (",
        "           id INT PRIMARY KEY AUTO_INCREMENT,",
        "  signup_date DATE",
        ");",
      ],
      o: [
        "Query OK, 0 rows affected (0.03 sec)",
      ]
    },
  ];

  return codes.buildCodeTagsSet(io);
});
