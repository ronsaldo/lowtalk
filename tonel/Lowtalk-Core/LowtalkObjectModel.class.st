Class {
	#name : #LowtalkObjectModel,
	#superclass : #Object,
	#instVars : [
		'compiler'
	],
	#classVars : [
		'SpecialLiterals'
	],
	#category : #'Lowtalk-Core-FrontEnd'
}

{ #category : #accessing }
LowtalkObjectModel >> arrayClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
LowtalkObjectModel >> compiler [
	^ compiler
]

{ #category : #accessing }
LowtalkObjectModel >> compiler: anObject [
	compiler := anObject
]

{ #category : #'object creation' }
LowtalkObjectModel >> convertAdditionalMethodState: anArray [
	self subclassResponsibility
]

{ #category : #'object creation' }
LowtalkObjectModel >> convertArray: anArray [
	self subclassResponsibility
]

{ #category : #'object creation' }
LowtalkObjectModel >> convertBoxedFloat64: aBoxedFloat64 [
	self subclassResponsibility
]

{ #category : #'object creation' }
LowtalkObjectModel >> convertByteString: aByteString [
	self subclassResponsibility
]

{ #category : #'object creation' }
LowtalkObjectModel >> convertByteSymbol: aByteSymbol [
	self subclassResponsibility
]

{ #category : #accessing }
LowtalkObjectModel >> namespaceCreationFunction [
	^ nil
]
