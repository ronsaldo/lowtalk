Metacello new
  baseline: 'Lowtalk';
  repository: 'tonel://tonel';
  load.

"Save the image"
(Smalltalk saveAs: 'lowtalk')
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].
