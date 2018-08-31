Class {
	#name : #LowtalkASTObjectLiteral,
	#superclass : #LowtalkASTLiteral,
	#category : #'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTObjectLiteral >> accept: aVisitor [
	^ aVisitor visitObjectLiteralNode: self
]
