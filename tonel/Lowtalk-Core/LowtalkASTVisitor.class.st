Class {
	#name : #LowtalkASTVisitor,
	#superclass : #Object,
	#category : 'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTVisitor >> visitArrayLiteralNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitArrayNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitAssignmentNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitBlockArgumentNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitBlockNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitBooleanLiteralNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitCallExpression: node [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitCharacterLiteralNode: aNode [
	self subclassResponsibility
	
]

{ #category : #visiting }
LowtalkASTVisitor >> visitExpressionListNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitFloatLiteralNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitIdentifierReferenceNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitIntegerLiteralNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitLetExpressionNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitLocalVariableNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitMessageChainNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitMessageNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitMethodExpression: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitNilLiteralNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitNode: aNode [
	^ aNode accept: self
]

{ #category : #visiting }
LowtalkASTVisitor >> visitObjectLiteralNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitPragmaNode: node [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitReturnNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitSelfNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitStringLiteralNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitSuperNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitSymbolLiteralNode: aNode [
	self subclassResponsibility
]

{ #category : #visiting }
LowtalkASTVisitor >> visitThisContextNode: aNode [
	self subclassResponsibility
]
