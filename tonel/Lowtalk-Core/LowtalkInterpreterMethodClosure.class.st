Class {
	#name : #LowtalkInterpreterMethodClosure,
	#superclass : #LowtalkBObject,
	#instVars : [
		'environment',
		'definition'
	],
	#classVars : [
		'CullSelectors',
		'ValueSelectors'
	],
	#category : #'Lowtalk-Core-Interpreter'
}

{ #category : #initialization }
LowtalkInterpreterMethodClosure class >> initialize [
	ValueSelectors := Set newFrom: #(
		value
		value:
		value:value:
		value:value:value:
		value:value:value:value:
		value:value:value:value:value:
	).
	
	CullSelectors := Set newFrom: #(
		cull:
		cull:cull:
		cull:cull:cull:
		cull:cull:cull:cull:
		cull:cull:cull:cull:cull:
	).
]

{ #category : #converting }
LowtalkInterpreterMethodClosure >> asLowtalkObjectInstanceWith: aCompiler [
	| function |
	function := aCompiler generateInterpreterMethod: definition.
	self flag: 'Do we need to encapsulate in a closure?'.
	^ function
]

{ #category : #accessing }
LowtalkInterpreterMethodClosure >> definition [
	^ definition
]

{ #category : #accessing }
LowtalkInterpreterMethodClosure >> definition: anObject [
	definition := anObject
]

{ #category : #accessing }
LowtalkInterpreterMethodClosure >> environment [
	^ environment
]

{ #category : #accessing }
LowtalkInterpreterMethodClosure >> environment: anObject [
	environment := anObject
]

{ #category : #evaluating }
LowtalkInterpreterMethodClosure >> lowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler [
	(ValueSelectors includes: selector) ifTrue: [
		^ self lowtalkValueWithArguments: arguments types: argumentTypes compiler: environment compiler at: sendingNode
	].

	(CullSelectors includes: selector) ifTrue: [ 
		self halt
	].

	^ super lowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
]

{ #category : #evaluating }
LowtalkInterpreterMethodClosure >> lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler [
	(ValueSelectors includes: selector) ifTrue: [
		^ self lowtalkValueWithArguments: (arguments collect: #value) types: (arguments collect: #type) compiler: environment compiler at: sendingNode
	].

	(CullSelectors includes: selector) ifTrue: [ 
		self halt
	].

	^ super lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
]

{ #category : #evaluating }
LowtalkInterpreterMethodClosure >> lowtalkValueWithArguments: evaluationArguments types: evaluationArgumentTypes compiler: aLowtalkCompiler at: aNode [
	^ definition lowtalkValueWithArguments: evaluationArguments types: evaluationArgumentTypes closureEnvironment: environment compiler: aLowtalkCompiler at: aNode
]

{ #category : #evaluating }
LowtalkInterpreterMethodClosure >> value [
	<compileTime>
	^ self valueWithArguments: #()
]

{ #category : #evaluating }
LowtalkInterpreterMethodClosure >> value: arg [
	<compileTime>
	^ self valueWithArguments: { arg }
]

{ #category : #evaluating }
LowtalkInterpreterMethodClosure >> value: arg1 value: arg2 [
	<compileTime>
	^ self valueWithArguments: { arg1 . arg2}
]

{ #category : #evaluating }
LowtalkInterpreterMethodClosure >> value: arg1 value: arg2 value: arg3 [
	<compileTime>
	^ self valueWithArguments: { arg1 . arg2 . arg3 }
]

{ #category : #evaluating }
LowtalkInterpreterMethodClosure >> value: arg1 value: arg2 value: arg3 value: arg4 [
	<compileTime>
	^ self valueWithArguments: { arg1 . arg2 . arg3 . arg4}
]

{ #category : #evaluating }
LowtalkInterpreterMethodClosure >> value: arg1 value: arg2 value: arg3 value: arg4 value: arg5 [
	<compileTime>
	^ self valueWithArguments: { arg1 . arg2 . arg3 . arg4 . arg5 }
]

{ #category : #evaluating }
LowtalkInterpreterMethodClosure >> valueWithArguments: evaluationArguments [
	<compileTime>
	^ self lowtalkValueWithArguments: evaluationArguments types: (evaluationArguments collect: [:arg | arg lowtalkLiteralTypeWith: environment compiler]) compiler: environment compiler at: LowtalkASTNode new.
]
