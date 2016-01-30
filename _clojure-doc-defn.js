define(["_code-builders"], function(codes){
  var io = [
    {
      i: [
        "(doc defn)",
      ],
      o: [
  "-------------------------",
  "clojure.core/defn",
  "([name doc-string? attr-map? [params*] prepost-map? body] [name doc-string? attr-map? ([params*] prepost-map? body) + attr-map?])",
  "Macro",
  "- Same as (def name (fn [params* ] exprs*)) or (def name (fn ([params* ] exprs*)+)) with any doc-string or attrs added to the var metadata.",
  "- prepost-map defines a map with optional keys :pre and :post that contain collections of pre or post conditions.",
      ],
    },
  ];

  codes.writeAdjacentCode(io);
});
