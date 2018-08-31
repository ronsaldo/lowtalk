Class {
	#name : #LowtalkMethodReceiverSlot,
	#superclass : #LowtalkMethodVariable,
	#instVars : [
		'description',
		'type'
	],
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #accessing }
LowtalkMethodReceiverSlot >> description [
	^ description
]

{ #category : #accessing }
LowtalkMethodReceiverSlot >> description: anObject [
	description := anObject.
	type := description type ref
]

{ #category : #'code generation' }
LowtalkMethodReceiverSlot >> emitSSAVariableReferenceWith: codeGenerator builder: builder at: node [
	^ description emitSSASlotReferenceOf: codeGenerator selfValue builder: builder at: node
]

{ #category : #testing }
LowtalkMethodReceiverSlot >> isMethodReceiverSlot [
	^ true
]

{ #category : #accessing }
LowtalkMethodReceiverSlot >> type [
	^ type
]

{ #category : #accessing }
LowtalkMethodReceiverSlot >> valueType [
	^ description type
]
