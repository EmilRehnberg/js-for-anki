define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc count)",
      ],
      o: [
  "-------------------------",
  "clojure.core/count",
  "([coll])",
  "  Returns the number of items in the collection. (count nil) returns",
  "  0.  Also works on strings, arrays, and Java Collections and Maps",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
