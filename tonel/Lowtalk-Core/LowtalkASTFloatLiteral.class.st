Class {
	#name : #LowtalkASTFloatLiteral,
	#superclass : #LowtalkASTLiteral,
	#category : #'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTFloatLiteral >> accept: aVisitor [
	^ aVisitor visitFloatLiteralNode: self
]
