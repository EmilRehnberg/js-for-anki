define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc rest)",
      ],
      o: [
  "-------------------------",
  "clojure.core/rest",
  "([coll])",
  "- Returns a possibly empty seq of the items after the first.",
  "- Calls seq on its argument.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
