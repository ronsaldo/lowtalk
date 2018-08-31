Class {
	#name : #LowtalkASTSuperReference,
	#superclass : #LowtalkASTExpression,
	#category : #'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTSuperReference >> accept: aVisitor [
	^ aVisitor visitSuperNode: self
]

{ #category : #testing }
LowtalkASTSuperReference >> isSuper [
	^ true
]

{ #category : #printing }
LowtalkASTSuperReference >> printOn: aStream [
	aStream nextPutAll: 'super'
]

{ #category : #accessing }
LowtalkASTSuperReference >> superClassForValue: aValue [
	^ aValue class superclass
]
