"
I am exception used for returning a value from the interpreter.
"
Class {
	#name : #LowtalkInterpreterReturnException,
	#superclass : #Exception,
	#instVars : [
		'value',
		'type'
	],
	#category : 'Lowtalk-Core-Interpreter'
}

{ #category : #accessing }
LowtalkInterpreterReturnException >> type [
	^ type
]

{ #category : #accessing }
LowtalkInterpreterReturnException >> type: anObject [
	type := anObject
]

{ #category : #accessing }
LowtalkInterpreterReturnException >> value [
	^ value
]

{ #category : #accessing }
LowtalkInterpreterReturnException >> value: anObject [
	value := anObject
]
