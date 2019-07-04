require(['_dom-updaters', '_dom-readers'], function (updaters, readers) {
  var readerId = 'text-reader'

  var bangHint = readers.readBangHint()
  if (bangHint) {
    updaters.insertHint(bangHint, readerId)
  }
})
