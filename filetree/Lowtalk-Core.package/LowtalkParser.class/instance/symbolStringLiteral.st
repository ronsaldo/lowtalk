accessing
symbolStringLiteral
	^ super symbolStringLiteral ==> [ :token |
		| parsedString c index count value |
		value := token inputValue.
		parsedString := ByteString streamContents: [ :out |
			index := 3.
			count := value size.
			[ index < count ] whileTrue: [ 
				c := value at: index.
				out nextPut: c.
				c = $' ifTrue: [ 
					index := index + 2
				] ifFalse: [
					index := index + 1
				]
			]
		].
	
		LowtalkASTSymbolLiteral new
			position: token;
			value: parsedString asSymbol;
			yourself
	]