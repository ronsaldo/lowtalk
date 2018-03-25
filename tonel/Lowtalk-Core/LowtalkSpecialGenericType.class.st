Class {
	#name : #LowtalkSpecialGenericType,
	#superclass : #LowtalkSpecificDynamicObjectType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkSpecialGenericType >> evaluateInEnvironment: environment at: node [
	self subclassResponsibility
]

{ #category : #testing }
LowtalkSpecialGenericType >> isSpecialGenericType [
	^ true
]

{ #category : #accessing }
LowtalkSpecialGenericType >> privateSlotsTypeIn: environment at: node [
	^ (self evaluateInEnvironment: environment at: node) privateSlotsTypeIn: environment at: node
]

{ #category : #accessing }
LowtalkSpecialGenericType >> specialMessageTypeForSelector: selector environment: environment at: node [
	| actualType |
	actualType := self evaluateInEnvironment: environment at: node.
	^ actualType specialMessageTypeForSelector: selector environment: environment at: node
]
