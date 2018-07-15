require(["_dom-writers", "_tag-builders"], function(writers, builders){
  var detailsElement = builders.buildDetailsTag(' <table class="wikitable"> <caption>Vowels and codas </caption> <tbody> <tr><th>Devanāgarī</th><th colspan="2">Transcription</th><th>Category</th></tr> <tr><td>अ</td><td>a</td><td>A</td><td rowspan="10">monophthongs<br>and <a href="/wiki/Syllabic_consonant" title="Syllabic consonant">syllabic</a> <a href="/wiki/Liquid_consonant" title="Liquid consonant">liquids</a></td></tr> <tr><td>आ</td><td>ā</td><td>Ā</td></tr> <tr><td>इ</td><td>i</td><td>I</td></tr> <tr><td>ई</td><td>ī</td><td>Ī</td></tr> <tr><td>उ</td><td>u</td><td>U</td></tr> <tr><td>ऊ</td><td>ū</td><td>Ū</td></tr> <tr><td>ऋ</td><td>ṛ</td><td>Ṛ</td></tr> <tr><td>ॠ</td><td>ṝ</td><td>Ṝ</td></tr> <tr><td>ऌ</td><td>ḷ</td><td>Ḷ</td></tr> <tr><td>ॡ</td><td>ḹ</td><td>Ḹ</td></tr> <tr><td>ए</td><td>e</td><td>E</td><td rowspan="4"><a href="/wiki/Diphthong" title="Diphthong">diphthongs</a></td></tr> <tr><td>ऐ</td><td>ai</td><td>Ai</td></tr> <tr><td>ओ</td><td>o</td><td>O</td></tr> <tr><td>औ</td><td>au</td><td>Au</td></tr> <tr><td>अं</td><td>ṃ</td><td>Ṃ</td><td><a href="/wiki/Anusvara" title="Anusvara">anusvara</a></td></tr> <tr><td>अः</td><td>ḥ</td><td>Ḥ</td><td><a href="/wiki/Visarga" title="Visarga">visarga</a></td></tr> <tr><td>ऽ</td><td>&#39;</td><td></td><td><a href="/wiki/Avagraha" title="Avagraha">avagraha</a></td></tr> <tr></tf> </tbody></table> <table class="wikitable"> <caption>Consonants</caption> <tbody> <tr><th><a href="/wiki/Velar_consonant" title="Velar consonant">velars</a></th><th><a href="/wiki/Palatal_consonant" title="Palatal consonant">palatals</a></th><th><a href="/wiki/Retroflex_consonant" title="Retroflex consonant">retroflexes</a></th><th><a href="/wiki/Dental_consonant" title="Dental consonant">dentals</a></th><th><a href="/wiki/Labial_consonant" title="Labial consonant">labials</a></th><th>Category</th></tr> <tr><td>क <br> k&nbsp;&nbsp;K</td><td>च <br> c&nbsp;&nbsp;C</td><td>ट <br> ṭ&nbsp;&nbsp;Ṭ</td><td>त <br> t&nbsp;&nbsp;T</td><td>प <br> p&nbsp;&nbsp;P</td><td><a href="/wiki/Tenuis_consonant" title="Tenuis consonant">tenuis</a> stops</td></tr> <tr><td>ख <br> kh&nbsp;&nbsp;Kh</td><td>छ <br> ch&nbsp;&nbsp;Ch</td><td>ठ <br> ṭh&nbsp;&nbsp;Ṭh</td><td>थ <br> th&nbsp;&nbsp;Th</td><td>फ <br> ph&nbsp;&nbsp;Ph</td><td><a href="/wiki/Aspiration_(phonetics)" class="mw-redirect" title="Aspiration (phonetics)">aspirated</a> stops</td></tr> <tr><td>ग <br> g&nbsp;&nbsp;G</td><td>ज <br> j&nbsp;&nbsp;J</td><td>ड <br> ḍ&nbsp;&nbsp;Ḍ</td><td>द <br> d&nbsp;&nbsp;D</td><td>ब <br> b&nbsp;&nbsp;B</td><td><a href="/wiki/Voiced_consonant" class="mw-redirect" title="Voiced consonant">voiced</a> stops</td></tr> <tr><td>घ <br> gh&nbsp;&nbsp;Gh</td><td>झ <br> jh&nbsp;&nbsp;Jh</td><td>ढ <br> ḍh&nbsp;&nbsp;Ḍh</td><td>ध <br> dh&nbsp;&nbsp;Dh</td><td>भ <br> bh&nbsp;&nbsp;Bh</td><td><a href="/wiki/Breathy-voiced" class="mw-redirect" title="Breathy-voiced">breathy-voiced</a> stops</td></tr> <tr><td>ङ <br> ṅ&nbsp;&nbsp;Ṅ</td><td>ञ <br> ñ&nbsp;&nbsp;Ñ</td><td>ण <br> ṇ&nbsp;&nbsp;Ṇ</td><td>न <br> n&nbsp;&nbsp;N</td><td>म <br> m&nbsp;&nbsp;M</td><td><a href="/wiki/Nasal_stop" class="mw-redirect" title="Nasal stop">nasal stops</a></td></tr> <tr><td>ह <br> h&nbsp;&nbsp;H</td><td>य <br> y&nbsp;&nbsp;Y</td><td>र <br> r&nbsp;&nbsp;R</td><td>ल <br> l&nbsp;&nbsp;L</td><td>व <br> v&nbsp;&nbsp;V</td><td><a href="/wiki/Approximant" class="mw-redirect" title="Approximant">approximants</a></td></tr> <tr><td>&nbsp;</td><td>श <br> ś&nbsp;&nbsp;Ś</td><td>ष <br> ṣ&nbsp;&nbsp;Ṣ</td><td>स <br> s&nbsp;&nbsp;S</td><td>&nbsp;</td><td><a href="/wiki/Sibilant" title="Sibilant">sibilants</a></td></tr> <tr></tr> </tbody></table>', "Sanskrit Lookup");
  writers.appendToBody(detailsElement);
});
