Class {
	#name : #LowtalkThisContextType,
	#superclass : #LowtalkSpecificDynamicObjectType,
	#classVars : [
		'ThisContextSpecialMessageTypes'
	],
	#category : #'Lowtalk-Core-Types'
}

{ #category : #initialization }
LowtalkThisContextType class >> initialize [
	ThisContextSpecialMessageTypes := Dictionary newFromPairs: #(
		uncheckedReplaceFunctionWith: UncheckedReplaceContextFunction
		uncheckedFramePointer UncheckedFramePointer
		uncheckedReturnFromFrame:value:exitPoint: UncheckedReturnFromFrameValue
	)
]

{ #category : #converting }
LowtalkThisContextType >> asValueType [
	^ LowtalkDynamicObjectType target: compilationTarget
]

{ #category : #testing }
LowtalkThisContextType >> isThisContextType [
	^ true
]

{ #category : #accessing }
LowtalkThisContextType >> name [
	^ #_ThisContext
]

{ #category : #'special messages' }
LowtalkThisContextType >> specialMessageTypeForSelector: selector [
	ThisContextSpecialMessageTypes at: selector ifPresent: [ :result | ^ result ].

	^ super specialMessageTypeForSelector: selector
]
