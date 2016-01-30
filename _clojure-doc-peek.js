define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc peek)",
      ],
      o: [
  "-------------------------",
  "clojure.core/peek",
  "([coll])",
  "- For a list or queue, same as first, for a vector, same as, but much more efficient than, last.",
  "- If the collection is empty, returns nil.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
