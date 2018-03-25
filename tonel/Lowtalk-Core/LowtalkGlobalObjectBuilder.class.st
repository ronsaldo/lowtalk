Class {
	#name : #LowtalkGlobalObjectBuilder,
	#superclass : #LowtalkBObject,
	#instVars : [
		'compiler'
	],
	#category : 'Lowtalk-Core-FrontEnd'
}

{ #category : #converting }
LowtalkGlobalObjectBuilder >> asLowtalkObjectInstanceWith: aCompiler [
	^ nil
]

{ #category : #accessing }
LowtalkGlobalObjectBuilder >> compiler [
	^ compiler
]

{ #category : #accessing }
LowtalkGlobalObjectBuilder >> compiler: anObject [
	compiler := anObject
]
