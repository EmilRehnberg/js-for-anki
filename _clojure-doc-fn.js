define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc fn)",
      ],
      o: [
  "-------------------------",
  "clojure.core/fn",
  "  (fn name? [params*] exprs*)",
  "  (fn name? ([params*] exprs*) +)",
  "Special Form",
  "  params => positional-params* , or positional-params* & next-param",
  "  positional-param => binding-form",
  "  next-param => binding-form",
  "  name => symbol",
  "",
  "  Defines a function",
  "",
  "  Please see http://clojure.org/special_forms#fn",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
