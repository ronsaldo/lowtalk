Class {
	#name : #LowtalkASTCharacterLiteral,
	#superclass : #LowtalkASTLiteral,
	#category : 'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTCharacterLiteral >> accept: aVisitor [
	^ aVisitor visitCharacterLiteralNode: self
]
