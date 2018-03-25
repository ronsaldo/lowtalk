Class {
	#name : #LowtalkLazyValue,
	#superclass : #Object,
	#instVars : [
		'evaluator',
		'node',
		'value',
		'evaluated',
		'type'
	],
	#category : 'Lowtalk-Core-Interpreter'
}

{ #category : #'as yet unclassified' }
LowtalkLazyValue class >> value: value type: type node: node [
	^ self new value: value type: type node: node
]

{ #category : #'as yet unclassified' }
LowtalkLazyValue class >> zipValues: values types: types node: node [
	| result |
	self assert: values size = types size.
	result := Array new: values size.
	1 to: values size do: [ :i |
		result at: i put: (self value: (values at: i) type: (types at: i) node: node)
	].
	^ result
]

{ #category : #accessing }
LowtalkLazyValue >> compiler [
	^ evaluator compiler
]

{ #category : #accessing }
LowtalkLazyValue >> environment [
	^ evaluator environment
]

{ #category : #accessing }
LowtalkLazyValue >> evaluator [
	^ evaluator
]

{ #category : #accessing }
LowtalkLazyValue >> evaluator: anObject [
	evaluator := anObject
]

{ #category : #'type inference' }
LowtalkLazyValue >> inferConstantValueType [
	^ self inferType asConstantValueType
]

{ #category : #'type inference' }
LowtalkLazyValue >> inferType [
	^ evaluator inferType: node
]

{ #category : #'type inference' }
LowtalkLazyValue >> inferValueType [
	^ self inferType asValueType
]

{ #category : #initialization }
LowtalkLazyValue >> initialize [
	evaluated := false
]

{ #category : #accessing }
LowtalkLazyValue >> node [
	^ node
]

{ #category : #accessing }
LowtalkLazyValue >> node: anObject [
	node := anObject
]

{ #category : #accessing }
LowtalkLazyValue >> type [
	^ type ifNil: [type := node type withoutReferences]
]

{ #category : #accessing }
LowtalkLazyValue >> validTypeValue [
	| result |
	result := self type.
	result isValidLowtalkType ifFalse: [ 
		node semanticError: 'expected a valid type.'.
	].
	^ result.
]

{ #category : #accessing }
LowtalkLazyValue >> value [
	evaluated ifFalse: [
		value := evaluator evaluateValue: node.
		evaluated := true.
	].

	^ value
]

{ #category : #'as yet unclassified' }
LowtalkLazyValue >> value: aValue type: aType node: aNode [
	value := aValue.
	type := aType.
	node := aNode.
	evaluated := true
]
