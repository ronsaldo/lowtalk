Class {
	#name : #LowtalkASTNode,
	#superclass : #Object,
	#instVars : [
		'position',
		'type'
	],
	#category : 'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTNode >> accept: aVisitor [
	self subclassResponsibility
]

{ #category : #accessing }
LowtalkASTNode >> asLowtalkASTPosition [
	^ position
]

{ #category : #errors }
LowtalkASTNode >> environment: anEnvironment semanticError: message [
	^ LTCSemanticError new
		messageText: message;
		node: self;
		environment: anEnvironment;
		signal
]

{ #category : #errors }
LowtalkASTNode >> environment: anEnvironment semanticError: errorFormat format: formatArguments [
	^ self environment: anEnvironment semanticError: (errorFormat format: formatArguments)
]

{ #category : #testing }
LowtalkASTNode >> isBlockNode [
	^ false
]

{ #category : #testing }
LowtalkASTNode >> isIdentifierReference [
	^ false
]

{ #category : #testing }
LowtalkASTNode >> isLiteralNode [
	^ false
]

{ #category : #testing }
LowtalkASTNode >> isMessageSend [
	^ false
]

{ #category : #testing }
LowtalkASTNode >> isSelf [
	^ false
]

{ #category : #accessing }
LowtalkASTNode >> isSuper [
	^ false
]

{ #category : #testing }
LowtalkASTNode >> isThisContext [
	^ false
]

{ #category : #accessing }
LowtalkASTNode >> position [
	^ position 
]

{ #category : #accessing }
LowtalkASTNode >> position: aPosition [
	position := aPosition asLowtalkASTPosition
]

{ #category : #errors }
LowtalkASTNode >> semanticError: message [
	^ LTCSemanticError new
		messageText: message;
		node: self;
		signal
]

{ #category : #errors }
LowtalkASTNode >> semanticError: errorFormat format: formatArguments [
	^ self semanticError: (errorFormat format: formatArguments)
]

{ #category : #accessing }
LowtalkASTNode >> setTypeIfNil: aType [
	type ifNil: [ type := aType]
]

{ #category : #accessing }
LowtalkASTNode >> sourceCode [
	^ position sourceCode
]

{ #category : #accessing }
LowtalkASTNode >> superClassForValue: aValue [
	^ aValue class
]

{ #category : #'as yet unclassified' }
LowtalkASTNode >> type [
	^ type
]

{ #category : #accessing }
LowtalkASTNode >> type: aType [
	type := aType
]
