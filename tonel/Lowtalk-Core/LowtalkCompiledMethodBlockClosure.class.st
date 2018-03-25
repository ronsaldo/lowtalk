Class {
	#name : #LowtalkCompiledMethodBlockClosure,
	#superclass : #LowtalkBObject,
	#instVars : [
		'closure',
		'definition'
	],
	#classVars : [
		'CullSelectors',
		'ValueSelectors'
	],
	#category : 'Lowtalk-Core-Interpreter'
}

{ #category : #initialization }
LowtalkCompiledMethodBlockClosure class >> initialize [
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

{ #category : #accessing }
LowtalkCompiledMethodBlockClosure >> closure [
	^ closure
]

{ #category : #accessing }
LowtalkCompiledMethodBlockClosure >> closure: anObject [
	closure := anObject
]

{ #category : #accessing }
LowtalkCompiledMethodBlockClosure >> definition [
	^ definition
]

{ #category : #accessing }
LowtalkCompiledMethodBlockClosure >> definition: anObject [
	definition := anObject
]

{ #category : #'message dispatching' }
LowtalkCompiledMethodBlockClosure >> lowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler [
	(ValueSelectors includes: selector) ifTrue: [
		^ self lowtalkValueWithArguments: arguments types: argumentTypes compiler: aCompiler at: sendingNode
	].

	(CullSelectors includes: selector) ifTrue: [ 
		self halt
	].

	^ super lowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
]

{ #category : #'message dispatching' }
LowtalkCompiledMethodBlockClosure >> lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler [
	(ValueSelectors includes: selector) ifTrue: [
		^ self lowtalkValueWithArguments: (arguments collect: #value) types: (arguments collect: #type) compiler: aCompiler at: sendingNode
	].

	(CullSelectors includes: selector) ifTrue: [ 
		self halt
	].

	^ super lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
]

{ #category : #evaluating }
LowtalkCompiledMethodBlockClosure >> lowtalkValueWithArguments: evaluationArguments types: evaluationArgumentTypes compiler: aLowtalkCompiler at: aNode [

	| convertedArguments argumentType expectedArgumentType |
	convertedArguments := evaluationArguments collectWithIndex: [ :argument :index |
		argumentType := evaluationArgumentTypes at: index.
		expectedArgumentType := (definition arguments at: index) type.
		argumentType convertValue: argument toType: expectedArgumentType at: aNode
	].
	^ closure valueWithArguments: convertedArguments
]

{ #category : #evaluating }
LowtalkCompiledMethodBlockClosure >> value [
	<compileTime>
	^ self valueWithArguments: #()
]

{ #category : #accessing }
LowtalkCompiledMethodBlockClosure >> value: arg [
	<compileTime>
	^ self valueWithArguments: { arg }
]

{ #category : #evaluating }
LowtalkCompiledMethodBlockClosure >> value: arg1 value: arg2 [
	<compileTime>
	^ self valueWithArguments: { arg1 . arg2}
]

{ #category : #evaluating }
LowtalkCompiledMethodBlockClosure >> value: arg1 value: arg2 value: arg3 [
	<compileTime>
	^ self valueWithArguments: { arg1 . arg2 . arg3 }
]

{ #category : #evaluating }
LowtalkCompiledMethodBlockClosure >> value: arg1 value: arg2 value: arg3 value: arg4 [
	<compileTime>
	^ self valueWithArguments: { arg1 . arg2 . arg3 . arg4}
]

{ #category : #evaluating }
LowtalkCompiledMethodBlockClosure >> value: arg1 value: arg2 value: arg3 value: arg4 value: arg5 [
	<compileTime>
	^ self valueWithArguments: { arg1 . arg2 . arg3 . arg4 . arg5 }
]

{ #category : #evaluating }
LowtalkCompiledMethodBlockClosure >> valueWithArguments: evaluationArguments [
	<compileTime>
	^ self lowtalkValueWithArguments: evaluationArguments types: (evaluationArguments collect: [:arg | arg lowtalkLiteralTypeWith: definition compiler]) compiler: definition compiler at: LowtalkASTNode new.
]
