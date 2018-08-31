Class {
	#name : #LowtalkInterpreterMethodExpression,
	#superclass : #LowtalkBObject,
	#instVars : [
		'node',
		'environment',
		'compiler'
	],
	#category : #'Lowtalk-Core-Interpreter'
}

{ #category : #'as yet unclassified' }
LowtalkInterpreterMethodExpression >> compiledMethodForReceiverType: receiverTypeLazyValue [
	<compileTime>
	<lazy>
	| receiverType |
	receiverType := receiverTypeLazyValue value asLowtalkTypeIn: receiverTypeLazyValue node.
	^ LowtalkMethodSemanticAnalyzer new
		analyzeMethod: node receiverType: receiverType environment: environment
]

{ #category : #'as yet unclassified' }
LowtalkInterpreterMethodExpression >> compiledMethodForReceiverTypeValue: receiverType [
	^ LowtalkMethodSemanticAnalyzer new
		analyzeMethod: node receiverType: receiverType environment: environment
]

{ #category : #accessing }
LowtalkInterpreterMethodExpression >> compiler [
	^ compiler
]

{ #category : #accessing }
LowtalkInterpreterMethodExpression >> compiler: anObject [
	compiler := anObject
]

{ #category : #accessing }
LowtalkInterpreterMethodExpression >> environment [
	^ environment
]

{ #category : #accessing }
LowtalkInterpreterMethodExpression >> environment: anObject [
	environment := anObject
]

{ #category : #'as yet unclassified' }
LowtalkInterpreterMethodExpression >> methodSignatureForReceiverTypeValue: receiverType [
	^ LowtalkMethodSemanticAnalyzer new
		analyzeMethodSignature: node receiverType: receiverType environment: environment
]

{ #category : #accessing }
LowtalkInterpreterMethodExpression >> node [
	^ node
]

{ #category : #accessing }
LowtalkInterpreterMethodExpression >> node: anObject [
	node := anObject
]

{ #category : #accessing }
LowtalkInterpreterMethodExpression >> selector [
	<compileTime>
	^ node selector
]
