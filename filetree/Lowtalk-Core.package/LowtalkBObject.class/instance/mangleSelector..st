as yet unclassified
mangleSelector: aSelector
	^ ByteString streamContents: [ :out |
		aSelector do: [ :char |
			(char isAlphaNumeric or: [ char = $_ ]) ifTrue: [ 
				out nextPut: char
			] ifFalse: [
				char nextPutAll: '_x' ; nextPutAll: char printStringHex
			].
		]
	]