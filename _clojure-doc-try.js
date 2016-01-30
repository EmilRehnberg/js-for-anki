define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc try) <span class=comment>; also(doc catch)</span>",
      ],
      o: [
  "-------------------------",
  "try",
  "  (try expr* catch-clause* finally-clause?)",
  "Special Form",
  "  catch-clause => (catch classname name expr*)",
  "  finally-clause => (finally expr*)",
  "",
  "  Catches and handles Java exceptions.",
  "",
  "  Please see http://clojure.org/special_forms#try",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
