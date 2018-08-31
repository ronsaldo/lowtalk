Class {
	#name : #LowtalkASTArrayLiteral,
	#superclass : #LowtalkASTLiteral,
	#category : #'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTArrayLiteral >> accept: aVisitor [
	^ aVisitor visitArrayLiteralNode: self
]
