define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc defmethod)",
      ],
      o: [
  "-------------------------",
  "clojure.core/defmethod",
  "([multifn dispatch-val & fn-tail])",
  "Macro",
  "- Creates and installs a new method of multimethod associated with dispatch-value.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
