define(["_code-builders"], function(codes){
  var io = [
    {
      c: [
"In general, PostgreSQL makes a strong effort to <u>conform to existing database standards</u>, where MySQL has a mixed background on this.\
<ul>\
  <li>Comments: use '--' (ANSI standard). Works with both DBs but MySQL also has nonstandard '#'</li>\
  <li>ANSI standard does use single quotes for values; double quotes for system identifiers (i.e. field names, table names etc), hence WHERE \"last name\" = 'Smith'. MySQL uses single and double quotes interchangably.</li>\
  <li>MySQL use backticks to quote system identifiers (non-standard).</li>\
  <li>string comparisons are case-sensitive in PostgreSQL (unlike MySQL and MS Access). Either\
    <ul>\
      <li>Use the correct case in your query. (i.e. WHERE lname='Smith')</li>\
      <li>Use a conversion function (e.g. WHERE lower(lname)='smith')</li>\
      <li>Use a case-insensitive operator. (e.g. ILIKE or ~*)</li>\
    </ul>\
  </li>\
  <li>Database, table, field and columns names in PostgreSQL are case-independent (unless you created them with double-quotes). In MySQL it sensitivity depends on OS.</li>\
  <li>PostgreSQL and MySQL seem to differ most in handling of dates, and the names of functions that handle dates.</li>\
  <li>MySQL uses C-language operators for logic (i.e. 'foo' || 'bar' means 'foo' OR 'bar', 'foo' && 'bar' means 'foo' and 'bar'). This violates database standards and rules. PostgreSQL, following the standard, uses || for string concatenation ('foo' || 'bar' = 'foobar').</li>\
  <li>There are other differences between the two, such as the names of functions for finding the current user.</li>\
</ul>",
  ],
      i: [],
      o: []
    },
  ];

  return codes.buildCodeTagsSet(io);
});
