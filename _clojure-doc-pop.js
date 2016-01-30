define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc pop)",
      ],
      o: [
  "-------------------------",
  "clojure.core/pop",
  "([coll])",
  "- For a list or queue, returns a new list/queue without the first item, for a vector, returns a new vector without the last item.",
  "- If the collection is empty, throws an exception.",
  "- Note - not the same as next/butlast.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
