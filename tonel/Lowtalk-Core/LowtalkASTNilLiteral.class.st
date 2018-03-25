Class {
	#name : #LowtalkASTNilLiteral,
	#superclass : #LowtalkASTLiteral,
	#category : 'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTNilLiteral >> accept: aVisitor [
	^ aVisitor visitNilLiteralNode: self
]
