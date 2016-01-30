define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc range)",
      ],
      o: [
  "-------------------------",
  "clojure.core/range",
  "([] [end] [start end] [start end step])",
  "  Returns a lazy seq of nums from start (inclusive) to end",
  "  (exclusive), by step, where start defaults to 0, step to 1, and end to",
  "  infinity. When step is equal to 0, returns an infinite sequence of",
  "  start. When start is equal to end, returns empty list.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
