Class {
	#name : #LowtalkASTBlockArgument,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'name',
		'typeExpression',
		'binding'
	],
	#category : 'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTBlockArgument >> accept: aVisitor [
	^ aVisitor visitBlockArgumentNode: self
]

{ #category : #accessing }
LowtalkASTBlockArgument >> binding [
	^ binding
]

{ #category : #accessing }
LowtalkASTBlockArgument >> binding: anObject [
	binding := anObject
]

{ #category : #accessing }
LowtalkASTBlockArgument >> name [
	^ name
]

{ #category : #accessing }
LowtalkASTBlockArgument >> name: anObject [
	name := anObject
]

{ #category : #printing }
LowtalkASTBlockArgument >> printOn: aStream [
	aStream nextPutAll: '('; nextPutAll: name; space; print: typeExpression; nextPutAll: ')'.
]

{ #category : #accessing }
LowtalkASTBlockArgument >> typeExpression [
	^ typeExpression
]

{ #category : #accessing }
LowtalkASTBlockArgument >> typeExpression: anObject [
	typeExpression := anObject
]
