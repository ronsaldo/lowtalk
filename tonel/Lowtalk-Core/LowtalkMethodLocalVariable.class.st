Class {
	#name : #LowtalkMethodLocalVariable,
	#superclass : #LowtalkMethodVariable,
	#instVars : [
		'valueType',
		'type',
		'compiledMethodVariable',
		'compiledMethodVariableIsSlot',
		'isCapturedInClosure'
	],
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #accessing }
LowtalkMethodLocalVariable >> compiledMethodVariable [
	^ compiledMethodVariable
]

{ #category : #accessing }
LowtalkMethodLocalVariable >> compiledMethodVariable: anObject [
	compiledMethodVariable := anObject
]

{ #category : #accessing }
LowtalkMethodLocalVariable >> compiledMethodVariableIsSlot [
	^ compiledMethodVariableIsSlot
]

{ #category : #accessing }
LowtalkMethodLocalVariable >> compiledMethodVariableIsSlot: anObject [
	compiledMethodVariableIsSlot := anObject
]

{ #category : #initialization }
LowtalkMethodLocalVariable >> initialize [
	super initialize.
	compiledMethodVariableIsSlot := false.
	isCapturedInClosure := false.
	
]

{ #category : #'as yet unclassified' }
LowtalkMethodLocalVariable >> irStoreStackTopWith: irBuilder [
	compiledMethodVariableIsSlot ifTrue: [ 
		irBuilder
			pushTemp: compiledMethodVariable;
			send: #lowtalkStoreValueIntoSlot:
	] ifFalse: [ 
		irBuilder storeTemp: compiledMethodVariable
	]
	
]

{ #category : #accessing }
LowtalkMethodLocalVariable >> isCapturedInClosure [
	^ isCapturedInClosure
]

{ #category : #accessing }
LowtalkMethodLocalVariable >> isCapturedInClosure: anObject [
	isCapturedInClosure := anObject
]

{ #category : #testing }
LowtalkMethodLocalVariable >> isLocalVariable [
	^ true
]

{ #category : #accessing }
LowtalkMethodLocalVariable >> type [
	^ type
]

{ #category : #accessing }
LowtalkMethodLocalVariable >> valueType [
	^ valueType
]

{ #category : #accessing }
LowtalkMethodLocalVariable >> valueType1: anObject [
	valueType := anObject
]

{ #category : #accessing }
LowtalkMethodLocalVariable >> valueType: aValueType [
	valueType := aValueType.
	type := aValueType ref.
]
