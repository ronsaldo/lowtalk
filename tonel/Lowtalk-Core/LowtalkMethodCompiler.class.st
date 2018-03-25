Class {
	#name : #LowtalkMethodCompiler,
	#superclass : #AbstractCompiler,
	#instVars : [
		'compiler'
	],
	#category : 'Lowtalk-Core-FrontEnd'
}

{ #category : #'as yet unclassified' }
LowtalkMethodCompiler class >> forCompiledMethod: aCompiledMethod [
	^ self new
		environment: aCompiledMethod methodClass environment;
		class: aCompiledMethod methodClass;
		yourself
]

{ #category : #accessing }
LowtalkMethodCompiler >> class: aClass [
]

{ #category : #accessing }
LowtalkMethodCompiler >> compiler [
	^ compiler ifNil: [ compiler := LowtalkCompiler compilationTarget: SLVMCompilationTarget forCurrentImage ]
]

{ #category : #accessing }
LowtalkMethodCompiler >> environment: anSmalltalkImage [
]

{ #category : #parsing }
LowtalkMethodCompiler >> parseTreeOfMethod: aCompiledMethod [
	^ LowtalkMethodDummyParseTree new
]
