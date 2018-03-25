Class {
	#name : #LowtalkASTIntegerLiteral,
	#superclass : #LowtalkASTLiteral,
	#category : 'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTIntegerLiteral >> accept: aVisitor [
	^ aVisitor visitIntegerLiteralNode: self
]
