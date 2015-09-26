var abbrs = document.getElementsByTagName("abbr");
[].forEach.call(abbrs, adjustAbbr);

function adjustAbbr(abbr){
  if (abbr.id) {
    var letters = abbr.id;
  } else {
    var letters = abbr.innerHTML;
    abbr.innerHTML = "※";
  }
  abbr.id = letters.toLowerCase();
}
