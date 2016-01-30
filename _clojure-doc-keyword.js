define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc keyword)",
      ],
      o: [
  "-------------------------",
  "clojure.core/keyword",
  "([name] [ns name])",
  "  Returns a Keyword with the given namespace and name.  Do not use :",
  "  in the keyword strings, it will be added automatically.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
