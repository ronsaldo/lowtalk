Class {
	#name : #LowtalkASTSymbolLiteral,
	#superclass : #LowtalkASTLiteral,
	#category : 'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTSymbolLiteral >> accept: aVisitor [
	^ aVisitor visitSymbolLiteralNode: self
]
