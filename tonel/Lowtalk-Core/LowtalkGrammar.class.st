Class {
	#name : #LowtalkGrammar,
	#superclass : #PPCompositeParser,
	#instVars : [
		'expressionList',
		'expression',
		'dot',
		'primaryExpression',
		'identifier',
		'number',
		'space',
		'white',
		'identifierStart',
		'identifierInner',
		'floatNumber',
		'integerNumber',
		'dottedFloatNumber',
		'scientificFloatNumber',
		'binaryOperator',
		'optionalExpression',
		'unaryExpression',
		'binaryExpression',
		'assignmentExpression',
		'chainExpression',
		'assignOperator',
		'statementExpression',
		'chainReceiver',
		'keyword',
		'chainKeywordMessage',
		'semicolon',
		'chainedMessage',
		'chainUnaryMessage',
		'returnExpression',
		'caret',
		'parentExpression',
		'lparent',
		'rparent',
		'specialLiterals',
		'selfExpression',
		'superExpression',
		'trueExpression',
		'falseExpression',
		'nilExpression',
		'superKeyword',
		'selfKeyword',
		'trueKeyword',
		'falseKeyword',
		'nilKeyword',
		'byteArrayExpression',
		'arrayExpression',
		'blbracket',
		'rbracket',
		'lcbracket',
		'rcbracket',
		'identifierExpression',
		'typeExpression',
		'pragmaList',
		'localDeclaration',
		'pragma',
		'localDeclarations',
		'bar',
		'lessThan',
		'greaterThan',
		'letExpression',
		'letKeyword',
		'stringLiteral',
		'symbolLiteral',
		'symbolIdentifierLiteral',
		'symbolStringLiteral',
		'comment',
		'blockExpression',
		'lbracket',
		'arrayExpressionList',
		'blockHeader',
		'blockArgument',
		'blockContent',
		'colon',
		'optionalTypeExpression',
		'blockWithHeader',
		'blockWithoutHeader',
		'mlbracket',
		'methodHeader',
		'unaryMethodHeader',
		'binaryMethodHeader',
		'keywordMethodHeader',
		'keywordMethodHeaderKeyword',
		'methodExpression',
		'unaryExpressionSuffix',
		'unaryExpressionSuffixMessage',
		'unaryExpressionSuffixCall',
		'sharpLCBracket',
		'callExpressionArguments',
		'cstringLiteral',
		'literalArrayExpression',
		'laparent',
		'literalArrayElement',
		'literalArrayParent',
		'literalPunctuation',
		'blockSelfType',
		'typeSpecifier',
		'symbolKeywordLiteral',
		'symbolOperatorLiteral',
		'anyIdentifier',
		'thisContextExpression',
		'thisContextKeyword',
		'pragmaChainKeywordMessage',
		'pragmaChainedMessage',
		'methodHeaderReturnType',
		'arrow',
		'character',
		'typeChainReceiver',
		'typeChainKeywordMessage',
		'typeChainedMessage',
		'typeBinaryExpression',
		'typeBinaryOperator',
		'typeChainExpression'
	],
	#classVars : [
		'Keywords'
	],
	#category : #'Lowtalk-Core-Parser'
}

{ #category : #initialization }
LowtalkGrammar class >> initialize [
	super initialize.
	
	Keywords := Set newFrom: #(
		"Standard Smalltalk keywords"
		self super #'nil' #'true' #'false'
		thisContext
		
		"Lowtalk keywords"
		let
	)
]

{ #category : #accessing }
LowtalkGrammar >> anyIdentifier [
	^ (self token: identifierStart ,  identifierInner star , $: asParser not)
]

{ #category : #expressions }
LowtalkGrammar >> arrayExpression [
	^ lcbracket , arrayExpressionList , rcbracket
]

{ #category : #expressions }
LowtalkGrammar >> arrayExpressionList [
	^ optionalExpression , (dot , optionalExpression) star
]

{ #category : #tokens }
LowtalkGrammar >> arrow [
	^ self operator: '->' asParser
]

{ #category : #tokens }
LowtalkGrammar >> assignOperator [
	^ self operator: ':=' asParser
]

{ #category : #expressions }
LowtalkGrammar >> assignmentExpression [
	^ chainExpression , (assignOperator , assignmentExpression) optional
]

{ #category : #tokens }
LowtalkGrammar >> bar [
	^ self token: $| asParser
]

{ #category : #expressions }
LowtalkGrammar >> binaryExpression [
	^ unaryExpression , (binaryOperator , unaryExpression) star
]

{ #category : #expressions }
LowtalkGrammar >> binaryMethodHeader [
	^ binaryOperator , optionalTypeExpression , identifier
]

{ #category : #tokens }
LowtalkGrammar >> binaryOperator [
	^ self operator: (PPPredicateObjectParser anyOf: '+-/\*~<>=@,%|&?!') plus
]

{ #category : #tokens }
LowtalkGrammar >> blbracket [
	^ self token: '#[' asParser
]

{ #category : #expressions }
LowtalkGrammar >> blockArgument [
	^ colon , identifier, optionalTypeExpression
]

{ #category : #expressions }
LowtalkGrammar >> blockContent [
	^ blockWithHeader / blockWithoutHeader
]

{ #category : #expressions }
LowtalkGrammar >> blockExpression [
	^ lbracket , blockContent , rbracket
]

{ #category : #expressions }
LowtalkGrammar >> blockHeader [
	^ blockArgument star
]

{ #category : #expressions }
LowtalkGrammar >> blockSelfType [
	^ colon , selfKeyword , typeSpecifier
]

{ #category : #expressions }
LowtalkGrammar >> blockWithHeader [
	^ optionalTypeExpression , blockSelfType optional , blockHeader , bar , expressionList
]

{ #category : #accessing }
LowtalkGrammar >> blockWithoutHeader [
	^ expressionList
]

{ #category : #expressions }
LowtalkGrammar >> byteArrayExpression [
	^ blbracket , integerNumber star , rbracket
]

{ #category : #expressions }
LowtalkGrammar >> callExpressionArguments [
	^ (expression , (dot, expression) star) optional
]

{ #category : #tokens }
LowtalkGrammar >> caret [
	^ self operator: $^ asParser
]

{ #category : #expressions }
LowtalkGrammar >> chainExpression [
	^ chainReceiver , chainKeywordMessage optional , (semicolon , chainedMessage) star
]

{ #category : #expressions }
LowtalkGrammar >> chainKeywordMessage [
	^ (keyword , binaryExpression) plus
]

{ #category : #expressions }
LowtalkGrammar >> chainReceiver [
	^ binaryExpression
]

{ #category : #expressions }
LowtalkGrammar >> chainUnaryMessage [
	^ identifier
]

{ #category : #expressions }
LowtalkGrammar >> chainedMessage [
	^ chainKeywordMessage / chainUnaryMessage
]

{ #category : #accessing }
LowtalkGrammar >> character [
	^ self token: $$ asParser, #any asParser
]

{ #category : #tokens }
LowtalkGrammar >> colon [
	^ self token: $: asParser
]

{ #category : #tokens }
LowtalkGrammar >> comment [
	^ $" asParser , $" asParser negate star, $" asParser
]

{ #category : #expressions }
LowtalkGrammar >> cstringLiteral [
	^ self token: 'c''' asParser , (($\ asParser, #any asParser) / $' asParser negate) star , $' asParser
]

{ #category : #tokens }
LowtalkGrammar >> dot [
	^ self token: $. asParser
]

{ #category : #expressions }
LowtalkGrammar >> dottedFloatNumber [
	^ self token: ($- asParser optional, #digit asParser plus , $. asParser , #digit asParser plus, ($e asParser , $- asParser optional, #digit asParser plus) optional)
]

{ #category : #expressions }
LowtalkGrammar >> expression [
	^ statementExpression
]

{ #category : #expressions }
LowtalkGrammar >> expressionList [
	^ pragmaList, localDeclarations optional, optionalExpression , (dot , optionalExpression) star
]

{ #category : #expressions }
LowtalkGrammar >> falseExpression [
	^ falseKeyword
]

{ #category : #keywords }
LowtalkGrammar >> falseKeyword [
	^ self keyword: 'false'
]

{ #category : #expressions }
LowtalkGrammar >> floatNumber [
	^ dottedFloatNumber / scientificFloatNumber
]

{ #category : #tokens }
LowtalkGrammar >> greaterThan [
	^ self token: $> asParser
]

{ #category : #tokens }
LowtalkGrammar >> identifier [
	^ (self token: identifierStart ,  identifierInner star , $: asParser not) >=> [ :stream :continuation |
		| result memento |
		memento := stream remember.
		result := continuation value.
		(result isPetitFailure not and: [ Keywords includes: result inputValue ]) ifTrue: [
			stream restore: memento.
			PPFailure message: 'expected an identifier, not a keyword.' context: stream
		] ifFalse: [
			result
		]
	]
]

{ #category : #expressions }
LowtalkGrammar >> identifierExpression [
	^ identifier
]

{ #category : #tokens }
LowtalkGrammar >> identifierInner [
	^ #letter asParser / #digit asParser / $_ asParser
]

{ #category : #tokens }
LowtalkGrammar >> identifierStart [
	^ #letter asParser / $_ asParser
]

{ #category : #expressions }
LowtalkGrammar >> integerNumber [
	^ self token: ($- asParser optional, #digit asParser plus , ($r asParser, (#digit asParser / #letter asParser) plus) optional)
]

{ #category : #tokens }
LowtalkGrammar >> keyword [
	^ self token: identifierStart , identifierInner star , $: asParser
]

{ #category : #tokens }
LowtalkGrammar >> keyword: keywordValue [
	^ self token: keywordValue asParser
]

{ #category : #expressions }
LowtalkGrammar >> keywordMethodHeader [
	^ keywordMethodHeaderKeyword plus
]

{ #category : #expressions }
LowtalkGrammar >> keywordMethodHeaderKeyword [
	^ keyword , optionalTypeExpression , identifier
]

{ #category : #tokens }
LowtalkGrammar >> laparent [
	^ self token: '#(' asParser
]

{ #category : #tokens }
LowtalkGrammar >> lbracket [
	^ self token: $[ asParser
]

{ #category : #tokens }
LowtalkGrammar >> lcbracket [
	^ self token: ${ asParser
]

{ #category : #tokens }
LowtalkGrammar >> lessThan [
	^ self token: $< asParser
]

{ #category : #expressions }
LowtalkGrammar >> letExpression [
	^ letKeyword , identifier , optionalTypeExpression, (assignOperator , expression) optional
]

{ #category : #keywords }
LowtalkGrammar >> letKeyword [
	^ self keyword: 'let'
]

{ #category : #accessing }
LowtalkGrammar >> literalArrayElement [
	^ falseExpression / trueExpression / nilExpression / stringLiteral / symbolLiteral / identifierExpression / number/ character / literalArrayExpression / literalArrayParent / literalPunctuation
]

{ #category : #expressions }
LowtalkGrammar >> literalArrayExpression [
	^ laparent , literalArrayElement star , rparent
]

{ #category : #expressions }
LowtalkGrammar >> literalArrayParent [
	^ lparent , literalArrayElement star , rparent
]

{ #category : #expressions }
LowtalkGrammar >> literalPunctuation [
	^ binaryOperator / (self token: $) asParser negate)
]

{ #category : #expressions }
LowtalkGrammar >> localDeclaration [
	^ identifier , optionalTypeExpression
]

{ #category : #expressions }
LowtalkGrammar >> localDeclarations [
	^ bar , localDeclaration plus , bar
]

{ #category : #tokens }
LowtalkGrammar >> lparent [
	^ self token: $( asParser
]

{ #category : #expressions }
LowtalkGrammar >> methodExpression [
	^ mlbracket , methodHeader , expressionList , rbracket
]

{ #category : #accessing }
LowtalkGrammar >> methodHeader [
	^ (unaryMethodHeader / binaryMethodHeader / keywordMethodHeader) , methodHeaderReturnType optional
]

{ #category : #accessing }
LowtalkGrammar >> methodHeaderReturnType [
	^ arrow , typeExpression , dot
]

{ #category : #tokens }
LowtalkGrammar >> mlbracket [
	^ self token: ':[' asParser
]

{ #category : #expressions }
LowtalkGrammar >> nilExpression [
	^ nilKeyword
]

{ #category : #keywords }
LowtalkGrammar >> nilKeyword [
	^ self keyword: 'nil'
]

{ #category : #expressions }
LowtalkGrammar >> number [
	^ floatNumber / integerNumber 
]

{ #category : #tokens }
LowtalkGrammar >> operator: aParser [
	^ self token: aParser
]

{ #category : #expressions }
LowtalkGrammar >> optionalExpression [
	^ expression optional
]

{ #category : #expressions }
LowtalkGrammar >> optionalTypeExpression [
	^ typeSpecifier optional
]

{ #category : #expressions }
LowtalkGrammar >> parentExpression [
	^ lparent , expression , rparent
]

{ #category : #accessing }
LowtalkGrammar >> pragma [
	^ lessThan , pragmaChainedMessage , greaterThan
]

{ #category : #accessing }
LowtalkGrammar >> pragmaChainKeywordMessage [
	^ (keyword , primaryExpression) plus
]

{ #category : #'as yet unclassified' }
LowtalkGrammar >> pragmaChainedMessage [
	^ pragmaChainKeywordMessage / chainUnaryMessage
]

{ #category : #expressions }
LowtalkGrammar >> pragmaList [
	^ pragma star
]

{ #category : #expressions }
LowtalkGrammar >> primaryExpression [
	^ parentExpression / character / stringLiteral / cstringLiteral / identifierExpression / specialLiterals / symbolLiteral / byteArrayExpression / literalArrayExpression / arrayExpression / blockExpression / methodExpression  / number
]

{ #category : #tokens }
LowtalkGrammar >> rbracket [
	^ self token: $] asParser
]

{ #category : #tokens }
LowtalkGrammar >> rcbracket [
	^ self token: $} asParser
]

{ #category : #expressions }
LowtalkGrammar >> returnExpression [
	^ caret , assignmentExpression
]

{ #category : #tokens }
LowtalkGrammar >> rparent [
	^ self token: $) asParser
]

{ #category : #expressions }
LowtalkGrammar >> scientificFloatNumber [
	^ self token: ($- asParser optional, #digit asParser plus , $e asParser , $- asParser optional, #digit asParser plus)
]

{ #category : #expressions }
LowtalkGrammar >> selfExpression [
	^ selfKeyword
]

{ #category : #keywords }
LowtalkGrammar >> selfKeyword [
	^ self keyword: 'self'
]

{ #category : #tokens }
LowtalkGrammar >> semicolon [
	^ self token: $; asParser
]

{ #category : #tokens }
LowtalkGrammar >> sharpLCBracket [
	^ self token: '#{' asParser
]

{ #category : #tokens }
LowtalkGrammar >> space [
	^ (comment / white ) plus
]

{ #category : #expressions }
LowtalkGrammar >> specialLiterals [
	^ selfExpression / superExpression / trueExpression / falseExpression / nilExpression / thisContextExpression
]

{ #category : #accessing }
LowtalkGrammar >> start [
	^ expressionList , space star, #eof asParser
]

{ #category : #expressions }
LowtalkGrammar >> statementExpression [
	^ returnExpression / letExpression / assignmentExpression
]

{ #category : #expressions }
LowtalkGrammar >> stringLiteral [
	^ self token: $' asParser , ($' asParser negate / ($' asParser , $' asParser)) star , $' asParser
]

{ #category : #expressions }
LowtalkGrammar >> superExpression [
	^ superKeyword
]

{ #category : #keywords }
LowtalkGrammar >> superKeyword [
	^ self keyword: 'super'
]

{ #category : #expressions }
LowtalkGrammar >> symbolIdentifierLiteral [
	^ self token: $# asParser , identifierStart , identifierInner star
]

{ #category : #expressions }
LowtalkGrammar >> symbolKeywordLiteral [
	^ self token: $# asParser, (identifierStart , identifierInner star , $: asParser) plus
]

{ #category : #expressions }
LowtalkGrammar >> symbolLiteral [
	^ symbolKeywordLiteral / symbolOperatorLiteral / symbolIdentifierLiteral / symbolStringLiteral
]

{ #category : #expressions }
LowtalkGrammar >> symbolOperatorLiteral [
	^ self token: $# asParser , (PPPredicateObjectParser anyOf: '+-/\*~<>=@,%|&?!') plus
]

{ #category : #expressions }
LowtalkGrammar >> symbolStringLiteral [
	^ self token: '#''' asParser , ($' asParser negate / ($' asParser , $' asParser)) star , $' asParser
]

{ #category : #expressions }
LowtalkGrammar >> thisContextExpression [
	^ thisContextKeyword
]

{ #category : #keywords }
LowtalkGrammar >> thisContextKeyword [
	^ self keyword: 'thisContext'
]

{ #category : #tokens }
LowtalkGrammar >> token: aParser [
	^ aParser token trim: space
]

{ #category : #expressions }
LowtalkGrammar >> trueExpression [
	^ trueKeyword
]

{ #category : #keywords }
LowtalkGrammar >> trueKeyword [
	^ self keyword: 'true'
]

{ #category : #'type expression' }
LowtalkGrammar >> typeBinaryExpression [
	^ unaryExpression , (typeBinaryOperator , unaryExpression) star
]

{ #category : #'type expression' }
LowtalkGrammar >> typeBinaryOperator [
	^ (self token: (PPPredicateObjectParser anyOf: '+-/\*~<>=@,%|&?!') plus) >=> [ :stream :continuation |
		| result memento |
		memento := stream remember.
		result := continuation value.
		(result isPetitFailure not and: [ result inputValue = #> ]) ifTrue: [
			stream restore: memento.
			PPFailure message: 'Invalid type binary operator.' context: stream
		] ifFalse: [
			result
		]
	]
]

{ #category : #'type expression' }
LowtalkGrammar >> typeChainExpression [
	^ typeChainReceiver , typeChainKeywordMessage optional , (semicolon , typeChainedMessage) star
]

{ #category : #'type expression' }
LowtalkGrammar >> typeChainKeywordMessage [
	^ (keyword , typeBinaryExpression) plus
]

{ #category : #'type expression' }
LowtalkGrammar >> typeChainReceiver [
	^ typeBinaryExpression
]

{ #category : #'type expression' }
LowtalkGrammar >> typeChainedMessage [
	^ typeChainKeywordMessage / chainUnaryMessage
]

{ #category : #'type expression' }
LowtalkGrammar >> typeExpression [
	^ typeChainExpression
]

{ #category : #expressions }
LowtalkGrammar >> typeSpecifier [
	^ lessThan , typeExpression , greaterThan
]

{ #category : #expressions }
LowtalkGrammar >> unaryExpression [
	^ primaryExpression , unaryExpressionSuffix star
]

{ #category : #expressions }
LowtalkGrammar >> unaryExpressionSuffix [
	^ unaryExpressionSuffixMessage / unaryExpressionSuffixCall
]

{ #category : #expressions }
LowtalkGrammar >> unaryExpressionSuffixCall [
	^ sharpLCBracket , callExpressionArguments , rcbracket
]

{ #category : #expressions }
LowtalkGrammar >> unaryExpressionSuffixMessage [
	^ anyIdentifier
]

{ #category : #expressions }
LowtalkGrammar >> unaryMethodHeader [
	^ identifier
]

{ #category : #tokens }
LowtalkGrammar >> white [
	^ #space asParser
]
