Class {
	#name : #LowtalkASTMethodArgument,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'name',
		'typeExpression'
	],
	#category : 'Lowtalk-Core-AST'
}

{ #category : #accessing }
LowtalkASTMethodArgument >> name [
	^ name
]

{ #category : #accessing }
LowtalkASTMethodArgument >> name: anObject [
	name := anObject
]

{ #category : #accessing }
LowtalkASTMethodArgument >> typeExpression [
	^ typeExpression
]

{ #category : #accessing }
LowtalkASTMethodArgument >> typeExpression: anObject [
	typeExpression := anObject
]
