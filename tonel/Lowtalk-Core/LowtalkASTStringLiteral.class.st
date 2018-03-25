Class {
	#name : #LowtalkASTStringLiteral,
	#superclass : #LowtalkASTLiteral,
	#category : 'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTStringLiteral >> accept: aVisitor [
	^ aVisitor visitStringLiteralNode: self
]
