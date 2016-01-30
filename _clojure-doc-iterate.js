define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc iterate)",
      ],
      o: [
  "-------------------------",
  "clojure.core/iterate",
  "([f x])",
  "- Returns a lazy sequence of x, (f x), (f (f x)) etc. f must be free of side-effects",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
