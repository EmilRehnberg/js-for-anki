define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc cons)",
      ],
      o: [
  "-------------------------",
  "clojure.core/cons",
  "([x seq])",
  "- Returns a new seq where x is the first element and seq is the rest.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
