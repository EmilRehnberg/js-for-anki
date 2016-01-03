define(["_code-builders"], function(codes){
  var io = [
    {
      c: [ ],
      i: [ "SELECT * FROM orders"],
      o: [
  " id | customer_id | order_date | shipping_country",
  "----+-------------+------------+------------------",
  "  1 |           2 | 2014-12-05 | SE",
  "  2 |           4 | 2015-10-05 | JA",
  "  3 |           2 | 2015-12-12 | NO",
  "(3 rows)",
  ]
    },
  ];

  return codes.buildCodeTagsSet(io);
});
