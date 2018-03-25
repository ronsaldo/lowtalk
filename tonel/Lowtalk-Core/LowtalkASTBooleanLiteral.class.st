Class {
	#name : #LowtalkASTBooleanLiteral,
	#superclass : #LowtalkASTLiteral,
	#category : 'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTBooleanLiteral >> accept: aVisitor [
	^ aVisitor visitBooleanLiteralNode: self
]
