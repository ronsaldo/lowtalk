Metacello new
  baseline: 'Lowtalk';
  repository: 'filetree://filetree';
  load.

"Save the image"
(Smalltalk saveAs: 'lowtalk')
    ifFalse: [ Smalltalk snapshot: false andQuit: true ].
