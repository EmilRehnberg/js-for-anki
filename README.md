# Repo for Anki js scripts

I use script-tags in my anki templates to get manipulation with js.
To modularize js, I am using require.js

I use js in Anki for mainly two purposes
1. DOM manipulation
2. partials/markup refactoring/ especially for tables that I want on multiple cards

e.g. insert html below to apply insert-dfn-tags and insert-word-links scripts to a template
```{html}
<script data-main="_main.js" src="_require.js"></script>
<script>require(["_insert-dfn-tags.js", "_insert-word-links.js"]);</script>
```

NOTE: Media files with a prepended underscore to it's file name is considered static. Static files are shared amongst devices.
