Class {
	#name : #LowtalkParser,
	#superclass : #LowtalkGrammar,
	#classVars : [
		'CEscapeSequenceMap'
	],
	#category : 'Lowtalk-Core-Parser'
}

{ #category : #initialization }
LowtalkParser class >> initialize [
	CEscapeSequenceMap := Dictionary newFromPairs: { 
		$a . 16r07 asCharacter. "Alert"
		$b . 16r08 asCharacter. "Backspace"
		$f . 16r0C asCharacter. "Form feed"
		$n . Character lf.
		$r . Character cr.
		$t . Character tab.
		$v . 16r0B asCharacter. "Vertical tab"
		$e . 16r1B asCharacter. "Escape"
	}
]

{ #category : #parsing }
LowtalkParser class >> parseFromFileNamed: aFileName [
	^ self new parseFromFileNamed: aFileName
]

{ #category : #accessing }
LowtalkParser >> arrayExpression [
	^ super arrayExpression ==> [ :list |
		LowtalkASTArrayExpression new
			position: list first;
			expressionList: list second;
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> arrayExpressionList [
	^ super arrayExpressionList ==> [ :list |
		({list first } , (list second collect: #second)) select: #isNotNil
	]
]

{ #category : #accessing }
LowtalkParser >> assignmentExpression [
	^ super assignmentExpression ==> [ :list |
		list second ifNotNil: [
			LowtalkASTAssignment new
				position: list second first;
				reference: list first;
				value: list second second;
				yourself
		] ifNil: [
			list first
		]
	]
]

{ #category : #accessing }
LowtalkParser >> binaryExpression [
	^ super binaryExpression ==> [ :list |
		| result |
		result := list first.
		list second do: [ :binaryMessage |
			result := LowtalkASTMessage new
				position: binaryMessage first;
				receiver: result;
				selector: binaryMessage first inputValue asSymbol;
				arguments: { binaryMessage second };
				yourself
		].
		result
	]
]

{ #category : #accessing }
LowtalkParser >> binaryMethodHeader [
	^ super binaryMethodHeader ==> [ :list |
		LowtalkASTMethodExpression new
			selector: list first inputValue asSymbol;
			arguments: {LowtalkASTMethodArgument new
				position: list third;
				name: list third inputValue;
				typeExpression: list second};
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> blockArgument [
	^ super blockArgument ==> [ :list |
		LowtalkASTBlockArgument new
			position: list first;
			name: list second inputValue asSymbol;
			typeExpression: list third;
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> blockExpression [
	^ super blockExpression ==> [ :list |
		list second position: (list first asLowtalkASTPosition until: list last); yourself
	]
]

{ #category : #accessing }
LowtalkParser >> blockSelfType [
	^ super blockSelfType ==> [ :list |
		list third
	]
]

{ #category : #accessing }
LowtalkParser >> blockWithHeader [
	^ super blockWithHeader ==> [ :list |
		LowtalkASTBlockExpression new
			returnTypeExpression: list first;
			selfTypeExpression: list second;
			arguments: list third;
			body: list last;
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> blockWithoutHeader [
	^ super blockWithoutHeader ==> [ :content |
		LowtalkASTBlockExpression new
			arguments: #();
			body: content;
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> callExpressionArguments [
	^ super callExpressionArguments ==> [ :list |
		list ifNil: [ #() ] ifNotNil: [ 
			{list first} , (list second collect: #second)
		]
	]
]

{ #category : #accessing }
LowtalkParser >> chainExpression [
	^ super chainExpression ==> [ :list |
		list third ifEmpty: [
			list second ifNil: [
				list first
			] ifNotNil: [
				list second copy receiver: list first
			]
		] ifNotEmpty: [
			| position chained |
			position := list third first first.
			chained := list third collect: #second.
			list second ifNil: [
				list first isMessageSend ifFalse: [ 
					PPFailure message: 'a chain has to start with a message send'
				] ifTrue: [
					LowtalkASTMessageChain new
						position: position;
						receiver: list first receiver;
						messages: { list first copy receiver: nil; yourself } , chained;
						yourself
				]
			] ifNotNil: [
				LowtalkASTMessageChain new
					position: position;
					receiver: list first;
					messages: { list second } , chained;
					yourself
			]
		]
	]
]

{ #category : #accessing }
LowtalkParser >> chainKeywordMessage [
	^ super chainKeywordMessage ==> [ :list |
		| selector |
		selector := ''.
		list do: [ :each | selector := selector , each first inputValue ].
		LowtalkASTMessage new
			position: list first first;
			selector: selector asSymbol;
			arguments: (list collect: #second);
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> chainUnaryMessage [
	^ super chainUnaryMessage ==> [ :selector |
		LowtalkASTMessage new
			position: selector;
			selector: selector inputValue asSymbol;
			arguments: #();
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> character [
	^ super character ==> [ :token |
		LowtalkASTCharacterLiteral new
			position: token;
			value: token inputValue second;
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> cstringLiteral [
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
]

{ #category : #accessing }
LowtalkParser >> dottedFloatNumber [
	^ super dottedFloatNumber ==> [ :value |
		LowtalkASTFloatLiteral new
			position: value;
			value: (Float readFrom: value inputValue);
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> expressionList [
	^ super expressionList ==> [ :list |
		LowtalkASTExpressionList new
			position: (list third ifNil: [list fourth ifEmpty: [ LowtalkASTPosition empty ] ifNotEmpty: [:dottedList | dottedList first first ]]);
			pragmaList: list first;
			locals: list second;
			expressions: (({ list third } , (list fourth collect: #second)) select: #isNotNil);
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> falseExpression [
	^ super falseExpression ==> [ :token |
		LowtalkASTBooleanLiteral new position: token; value: false
	]
]

{ #category : #accessing }
LowtalkParser >> identifierExpression [
	^ super identifierExpression ==> [ :value |
		LowtalkASTIdentifierReference new
			position: value;
			value: value inputValue asSymbol;
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> integerNumber [
	^ super integerNumber ==> [ :value |
		| content radix sign valueContent|
		content := value inputValue.
		(content includes: $r) ifTrue: [ 
			sign := content first = $- ifTrue: [ -1 ] ifFalse: [ 1 ].
			radix := (content first = $- ifTrue: [ content allButFirst ] ifFalse: [ content ]) asInteger.
			valueContent := content allButFirst: (content indexOf: $r).
			LowtalkASTIntegerLiteral new
				position: value;
				value: (Integer readFrom: valueContent base: radix) * sign;
				yourself
		] ifFalse: [ 
			LowtalkASTIntegerLiteral new
				position: value;
				value: content asInteger;
				yourself
		]
	]
]

{ #category : #accessing }
LowtalkParser >> keywordMethodHeader [
	^ super keywordMethodHeader ==> [ :list |
		| selector |
		selector := ''.
		list do: [ :el | selector := selector , el first inputValue ].
		
		LowtalkASTMethodExpression new
			position: list first first;
			selector: selector asSymbol;
			arguments: (list collect: #second);
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> keywordMethodHeaderKeyword [
	^ super keywordMethodHeaderKeyword ==> [ :list |
		{ list first .
		LowtalkASTMethodArgument new
			position: list third;
			name: list third inputValue;
			typeExpression: list second
		}
	]
]

{ #category : #accessing }
LowtalkParser >> letExpression [
	^ super letExpression ==> [ :list |
		LowtalkASTLetExpression  new
			position: list first;
			identifier: list second inputValue asSymbol;
			typeExpression: list third;
			initialValue: (list fourth ifNotNil: [:initial | initial second]);
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> literalArrayExpression [
	^ super literalArrayExpression ==> [ :list |
		LowtalkASTArrayLiteral new
			position: list first;
			value: (list second collect: #asLiteralValue)
		]
]

{ #category : #accessing }
LowtalkParser >> literalArrayParent [
	^ super literalArrayParent ==> [ :list |
		LowtalkASTArrayLiteral new
			position: list first;
			value: (list second collect: #asLiteralValue)
		]
]

{ #category : #accessing }
LowtalkParser >> literalPunctuation [
	^ super literalPunctuation ==> [ :token |
			LowtalkASTSymbolLiteral new
				position: token;
				value: token inputValue asSymbol
	]
]

{ #category : #accessing }
LowtalkParser >> localDeclaration [
	^ super localDeclaration ==> [ :list |
		LowtalkASTLocalVariable new
			position: list first;
			name: list first inputValue asSymbol;
			typeExpression: list second;
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> localDeclarations [
	^ super localDeclarations ==> [ :list | list second ]
]

{ #category : #accessing }
LowtalkParser >> methodExpression [
	^ super methodExpression ==> [ :list |
		list second
			position: (list first asLowtalkASTPosition until: list last);
			body: list third;
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> methodHeader [
	^ super methodHeader ==> [ :list |
		list first
			returnTypeExpression: list second; yourself
	]
]

{ #category : #accessing }
LowtalkParser >> methodHeaderReturnType [
	^ super methodHeaderReturnType ==> [ :list | list second ]
]

{ #category : #accessing }
LowtalkParser >> nilExpression [
	^ super nilExpression ==> [ :token |
		LowtalkASTNilLiteral new position: token
	]
]

{ #category : #accessing }
LowtalkParser >> parentExpression [
	^ super parentExpression ==> [ :list | list second ]
]

{ #category : #parsing }
LowtalkParser >> parse: aCollection [
	^ super parse: aCollection asLowtalkCollectionWithContext
]

{ #category : #parsing }
LowtalkParser >> parseFromFileNamed: aFileName [
	| fileRef contents |
	fileRef := aFileName asFileReference.
	contents := fileRef contents asLowtalkCollectionWithContext.
	contents name: fileRef fullName.
	^ self parse: contents
]

{ #category : #accessing }
LowtalkParser >> pragma [
	^ super pragma ==> [ :list |
		LowtalkASTPragma new
			position: list first;
			selector: list second selector;
			arguments: list second arguments;
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> pragmaChainKeywordMessage [
	^ super pragmaChainKeywordMessage ==> [ :list |
		| selector |
		selector := ''.
		list do: [ :each | selector := selector , each first inputValue ].
		LowtalkASTMessage new
			position: list first first;
			selector: selector asSymbol;
			arguments: (list collect: #second);
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> returnExpression [
	^ super returnExpression ==> [:list |
		LowtalkASTReturnStatement new
			position: list first;
			value: list second;
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> scientificFloatNumber [
	^ super scientificFloatNumber ==> [ :value |
		LowtalkASTFloatLiteral new
			position: value;
			value: (Float readFrom: value inputValue);
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> selfExpression [
	^ super selfExpression ==> [ :token | LowtalkASTSelfReference new position: token ]
]

{ #category : #accessing }
LowtalkParser >> start [
	^ super start ==> [ :result | result first ]
]

{ #category : #accessing }
LowtalkParser >> stringLiteral [
	^ super stringLiteral ==> [ :token |
		| parsedString c index count value |
		value := token inputValue.
		parsedString := ByteString streamContents: [ :out |
			index := 2.
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
	
		LowtalkASTStringLiteral new
			position: token;
			value: parsedString;
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> superExpression [
	^ super superExpression ==> [ :token | LowtalkASTSuperReference new position: token ]
]

{ #category : #accessing }
LowtalkParser >> symbolIdentifierLiteral [
	^ super symbolIdentifierLiteral ==> [ :token |
		LowtalkASTSymbolLiteral new
			position: token;
			value: token inputValue allButFirst asSymbol;
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> symbolKeywordLiteral [
	^ super symbolKeywordLiteral ==> [ :token |
		LowtalkASTSymbolLiteral new
			position: token;
			value: token inputValue allButFirst asSymbol;
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> symbolOperatorLiteral [
	^ super symbolOperatorLiteral ==> [ :token |
		LowtalkASTSymbolLiteral new
			position: token;
			value: token inputValue allButFirst asSymbol;
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> symbolStringLiteral [
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
]

{ #category : #accessing }
LowtalkParser >> thisContextExpression [
	^ super thisContextExpression ==> [ :token |
		LowtalkASTThisContextReference new position: token
	]
]

{ #category : #accessing }
LowtalkParser >> trueExpression [
	^ super trueExpression ==> [ :token |
		LowtalkASTBooleanLiteral new position: token; value: true
	]
]

{ #category : #accessing }
LowtalkParser >> typeBinaryExpression [
	^ super typeBinaryExpression ==> [ :list |
		| result |
		result := list first.
		list second do: [ :binaryMessage |
			result := LowtalkASTMessage new
				position: binaryMessage first;
				receiver: result;
				selector: binaryMessage first inputValue asSymbol;
				arguments: { binaryMessage second };
				yourself
		].
		result
	]
]

{ #category : #accessing }
LowtalkParser >> typeChainExpression [
	^ super typeChainExpression ==> [ :list |
		list third ifEmpty: [
			list second ifNil: [
				list first
			] ifNotNil: [
				list second copy receiver: list first
			]
		] ifNotEmpty: [
			| position chained |
			position := list third first first.
			chained := list third collect: #second.
			list second ifNil: [
				list first isMessageSend ifFalse: [ 
					PPFailure message: 'a chain has to start with a message send'
				] ifTrue: [
					LowtalkASTMessageChain new
						position: position;
						receiver: list first receiver;
						messages: { list first copy receiver: nil; yourself } , chained;
						yourself
				]
			] ifNotNil: [
				LowtalkASTMessageChain new
					position: position;
					receiver: list first;
					messages: { list second } , chained;
					yourself
			]
		]
	]
]

{ #category : #accessing }
LowtalkParser >> typeChainKeywordMessage [
	^ super typeChainKeywordMessage ==> [ :list |
		| selector |
		selector := ''.
		list do: [ :each | selector := selector , each first inputValue ].
		LowtalkASTMessage new
			position: list first first;
			selector: selector asSymbol;
			arguments: (list collect: #second);
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> typeSpecifier [
	^ super typeSpecifier ==> [ :list |
		list second
	]
]

{ #category : #accessing }
LowtalkParser >> unaryExpression [
	^ super unaryExpression ==> [ :list |
		| result |
		result := list first.
		list second do: [ :message |
			message receiver: result.
			result := message
		].
		result
	]
]

{ #category : #accessing }
LowtalkParser >> unaryExpressionSuffixCall [
	^ super unaryExpressionSuffixCall ==> [ :list |
		LowtalkASTCallExpression new
			position: list first;
			arguments: list second;
			yourself 
	]
]

{ #category : #accessing }
LowtalkParser >> unaryExpressionSuffixMessage [
	^ super unaryExpressionSuffixMessage ==> [ :selector |
		LowtalkASTMessage new
			position: selector;
			selector: selector inputValue asSymbol;
			arguments: #();
			yourself
	]
]

{ #category : #accessing }
LowtalkParser >> unaryMethodHeader [
	^ super unaryMethodHeader ==> [ :selector |
		LowtalkASTMethodExpression new
			position: selector;
			selector: selector inputValue asSymbol;
			arguments: #();
			yourself
	]
]
