accessing
cstringLiteral
	^ super cstringLiteral ==> [ :token |
		| parsedString c index count value |
		value := token inputValue.
		self flag: 'TODO: Implement octal and hex sequences.'.
		parsedString := ByteString streamContents: [ :out |
			index := 3.
			count := value size.
			[ index < count ] whileTrue: [ 
				c := value at: index.
				c = $\ ifTrue: [ 
					c := value at: index + 1.
					out nextPut: (CEscapeSequenceMap at: c ifAbsent: [ c ]).
					index := index + 2
				] ifFalse: [
				out nextPut: c.
					index := index + 1
				]
			]
		].
	
		LowtalkASTStringLiteral new
			position: token;
			value: parsedString;
			yourself
	]