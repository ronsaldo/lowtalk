accessing
newlines
	| index size el |
	newlines ifNotNil: [ ^ newlines ].
	^ newlines := Array streamContents: [ :out |
		index := 1.
		out nextPut: index. "Line 1"
		
		size := collection size.
		[ index <= size ] whileTrue: [ 
			el := collection at: index.
			el = Character cr ifTrue: [ 
				index := index + 1.
				index <= size ifTrue: [
					el := collection at: index.
					el = Character lf ifTrue: [ 
						index := index + 1.
					].
				].
				out nextPut: index.
			] ifFalse: [
				el = Character lf ifTrue: [ 
					index := index + 1.
					out nextPut: index.
				] ifFalse: [ 
					index := index + 1.
				]
			]
		]
	]