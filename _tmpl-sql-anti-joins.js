define(["_code-builders"], function(codes){
  var io = [
    {
      c: [
        "ANTI JOINs",
        "Using IN",
      ],
      i: [
        "  FROM author",
        " WHERE author.id NOT IN (",
        "    SELECT book.author_id ",
        "      FROM book)",
      ],
      o: []
    },
    {
      c: [
        "Using EXISTS",
      ],
      i: [
        "FROM author",
        "WHERE NOT EXISTS (",
        "  SELECT 1 ",
        "    FROM book ",
        "   WHERE book.author_id = author.id)",
      ],
      o: []
    },
  ];

  return codes.buildCodeTagsSet(io);
});
