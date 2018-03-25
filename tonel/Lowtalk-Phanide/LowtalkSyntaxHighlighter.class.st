Class {
	#name : #LowtalkSyntaxHighlighter,
	#superclass : #LowtalkGrammar,
	#instVars : [
		'commands'
	],
	#category : 'Lowtalk-Phanide'
}

{ #category : #accessing }
LowtalkSyntaxHighlighter class >> ignoredNames [
	^ super ignoredNames, #(commands)
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> bar [
	^ super bar ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle bar token: token)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> binaryMethodHeader [
	^ super binaryMethodHeader ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle methodHeaderSelector token: tokens first);
			add: (PhanideHighlightCommandStyle localDefinition token: tokens third)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> blockArgument [
	^ super blockArgument ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle localDefinition firstToken: tokens first lastToken: tokens second)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> caret [
	^ super caret ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle keyword token: token)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> colon [
	^ super colon ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle keyword token: token)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> commands [ 
	^ commands ifNil: [ commands := OrderedCollection new ]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> comment [
	^ super comment token ==> [ :c |
		self commands add: (PhanideHighlightCommandStyle commentStyle token: c)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> cstringLiteral [
	^ super cstringLiteral ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle string token: token)
	]
]

{ #category : #'as yet unclassified' }
LowtalkSyntaxHighlighter >> highlightText: aStringOrText [
	| highlighted |
	self parse: aStringOrText.
	
	highlighted := aStringOrText asText.
	self commands do: [ :command | command executeOn: highlighted inPresentation: nil relativeToFileReference: nil ].
	^ highlighted
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> identifier [
	^ super identifier ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle identifier token: token)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> keyword: aKeyword [
	^ (super keyword: aKeyword) ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle keyword token: token)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> keywordMethodHeaderKeyword [
	^ super keywordMethodHeaderKeyword ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle methodHeaderSelector token: tokens first);
			add: (PhanideHighlightCommandStyle localDefinition token: tokens third)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> letExpression [
	^ super letExpression ==> [ :tokens |
		self commands add: (PhanideHighlightCommandStyle localDefinition token: tokens second)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> literalArrayExpression [
	^ super literalArrayExpression ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle literalArrayParent token: tokens first);
			add: (PhanideHighlightCommandStyle literalArrayParent token: tokens last)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> literalArrayParent [
	^ super literalArrayParent ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle literalArrayParent token: tokens first);
			add: (PhanideHighlightCommandStyle literalArrayParent token: tokens last)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> methodExpression [
	^ super methodExpression ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle methodBracket token: tokens first);
			add: (PhanideHighlightCommandStyle methodBracket token: tokens last)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> methodHeaderReturnType [
	^ super methodHeaderReturnType ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle typeExpression firstToken: tokens first lastToken: tokens last)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> number [
	^ super number ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle number token: token)
	]
]

{ #category : #tokens }
LowtalkSyntaxHighlighter >> operator: aKeyword [
	^ (super operator: aKeyword) ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle operator token: token)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> pragma [
	^ super pragma ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle pragma firstToken: tokens first lastToken: tokens last)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> stringLiteral [
	^ super stringLiteral ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle string token: token)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> symbolLiteral [
	^ super symbolLiteral ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle symbol token: token)
	]
]

{ #category : #tokens }
LowtalkSyntaxHighlighter >> typeBinaryOperator [
	^ super typeBinaryOperator ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle operator token: token)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> typeSpecifier [
	^ super typeSpecifier ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle typeExpression firstToken: tokens first lastToken: tokens last)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> unaryExpressionSuffixCall [
	^ super unaryExpressionSuffixCall ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle callBracket token: tokens first);
			add: (PhanideHighlightCommandStyle callBracket token: tokens last)
	]
]

{ #category : #accessing }
LowtalkSyntaxHighlighter >> unaryMethodHeader [
	^ super unaryMethodHeader ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle methodHeaderSelector token: token)
	]
]
