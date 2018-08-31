Class {
	#name : #LowtalkASTBlockExpression,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'returnType',
		'returnTypeExpression',
		'selfType',
		'selfTypeExpression',
		'arguments',
		'body',
		'definition',
		'inlined'
	],
	#category : #'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTBlockExpression >> accept: aVisitor [
	^ aVisitor visitBlockNode: self
]

{ #category : #accessing }
LowtalkASTBlockExpression >> arguments [
	^ arguments
]

{ #category : #accessing }
LowtalkASTBlockExpression >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
LowtalkASTBlockExpression >> body [
	^ body
]

{ #category : #accessing }
LowtalkASTBlockExpression >> body: anObject [
	body := anObject
]

{ #category : #accessing }
LowtalkASTBlockExpression >> definition [
	^ definition
]

{ #category : #accessing }
LowtalkASTBlockExpression >> definition: anObject [
	definition := anObject
]

{ #category : #accessing }
LowtalkASTBlockExpression >> hasPragmaNamed: aPragmaName [
	^ body hasPragmaNamed: aPragmaName
]

{ #category : #accessing }
LowtalkASTBlockExpression >> inlined [
	^ inlined
]

{ #category : #accessing }
LowtalkASTBlockExpression >> inlined: anObject [
	inlined := anObject
]

{ #category : #testing }
LowtalkASTBlockExpression >> isBlockNode [
	^ true
]

{ #category : #accessing }
LowtalkASTBlockExpression >> pragmaAt: aPragmaName ifAbsent: aBlock [
	^ body pragmaAt: aPragmaName ifAbsent: aBlock
]

{ #category : #accessing }
LowtalkASTBlockExpression >> pragmaAt: aPragmaName ifPresent: aBlock [
	^ body pragmaAt: aPragmaName ifPresent: aBlock
]

{ #category : #accessing }
LowtalkASTBlockExpression >> pragmasDo: aBlock [
	^ body pragmasDo: aBlock
]

{ #category : #printing }
LowtalkASTBlockExpression >> printOn: aStream [
	aStream nextPutAll: '(closure ('.
	arguments do: [ :arg | aStream print: arg ].
	aStream nextPutAll: ') '; print: body; nextPutAll: ')'
]

{ #category : #accessing }
LowtalkASTBlockExpression >> returnType [
	^ returnType
]

{ #category : #accessing }
LowtalkASTBlockExpression >> returnType: anObject [
	returnType := anObject
]

{ #category : #accessing }
LowtalkASTBlockExpression >> returnTypeExpression [
	^ returnTypeExpression
]

{ #category : #accessing }
LowtalkASTBlockExpression >> returnTypeExpression: anObject [
	returnTypeExpression := anObject
]

{ #category : #accessing }
LowtalkASTBlockExpression >> selfType [
	^ selfType
]

{ #category : #accessing }
LowtalkASTBlockExpression >> selfType: anObject [
	selfType := anObject
]

{ #category : #accessing }
LowtalkASTBlockExpression >> selfTypeExpression [
	^ selfTypeExpression
]

{ #category : #accessing }
LowtalkASTBlockExpression >> selfTypeExpression: anObject [
	selfTypeExpression := anObject
]

{ #category : #accessing }
LowtalkASTBlockExpression >> value [
	^ value
]
