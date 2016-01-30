define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc symbol)",
      ],
      o: [
  "-------------------------",
  "clojure.core/symbol",
  "([name] [ns name])",
  "  Returns a Symbol with the given namespace and name.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
