var abbrs = document.getElementsByTagName("abbr");
for (var abbrNum in abbrs){
  var abbr = abbrs[abbrNum];
  abbr = adjustAbbr(abbr);
}

function adjustAbbr(abbr){
  if (abbr.id) {
    var letters = abbr.id;
  } else {
    var letters = abbr.innerHTML;
    abbr.innerHTML = "※";
  }
  abbr.id = letters.toLowerCase();
}
