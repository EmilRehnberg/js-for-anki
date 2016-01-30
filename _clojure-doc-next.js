define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc next)",
      ],
      o: [
  "-------------------------",
  "clojure.core/next",
  "([coll])",
  "- Returns a seq of the items after the first.",
  "- Calls seq on its argument.",
  "- If there are no more items, returns nil.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
