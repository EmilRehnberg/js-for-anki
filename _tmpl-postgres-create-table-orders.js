define(["_code-builders"], function(codes){
  var io = [
    {
      c: ["create DB from command line and table in psql shell"],
      i: [
  "createdb sandbox",
  "psql -d sandbox",
  "CREATE TABLE orders (",
  " id               serial PRIMARY KEY, ",
  " customer_id      integer NOT NULL, ",
  " order_date       date NOT NULL, ",
  " shipping_country varchar(2) NOT NULL CHECK (shipping_country <> "")",
  ");",
      ],
      o: ["CREATE TABLE"]
    },
    {
      c: [ ],
      i: [
  "INSERT INTO orders",
  "            (customer_id, order_date, shipping_country) ",
  "     VALUES (2, '2014-12-05', 'SE'), ",
  "            (4, '2015-10-05', 'JA'), ",
  "            (2, '2015-12-12', 'NO');",
      ],
      o: ["INSERT 0 3"]
    },
  ];

  return codes.buildCodeTagsSet(io);
});
