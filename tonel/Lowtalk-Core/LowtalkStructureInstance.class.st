Class {
	#name : #LowtalkStructureInstance,
	#superclass : #LowtalkBObject,
	#instVars : [
		'type',
		'slots'
	],
	#category : 'Lowtalk-Core-Environment'
}

{ #category : #converting }
LowtalkStructureInstance >> asSSAConstantValueIn: module [
	| slotValues |
	slotValues := slots collect: [ :slot |
		slot valueType convertValue: slot value toSSAConstantWith: type compiler
	].

	^ SLVMConstant structure: type ssaType slots: slotValues
]

{ #category : #'reflective operations' }
LowtalkStructureInstance >> doesNotUnderstand: aMessage [
	| arguments value valueType slot |
	arguments := aMessage arguments.
	arguments size = 0 ifTrue: [
		type slotNamed: aMessage selector ifPresent: [ :slotDescriptor |
			slot := slots at: slotDescriptor index + 1.
			^ slot value
		]
	].
	arguments size = 1 ifTrue: [ 
		type slotNamed: aMessage selector allButLast ifPresent: [ :slotDescriptor |
			slot := slots at: slotDescriptor index + 1.
			value := arguments first.
			valueType := value lowtalkLiteralTypeWith: type compiler.
			slot value: (valueType convertValue: value toType: slot valueType at: (LowtalkASTNode new)).
			^ slot value
		]
	].

	^ super doesNotUnderstand: aMessage
]

{ #category : #testing }
LowtalkStructureInstance >> isStructureInstance [
	^ true
]

{ #category : #'slot accessing' }
LowtalkStructureInstance >> lowtalkGetFieldRef: slotDescription [
	^ slots at: slotDescription index + 1
]

{ #category : #'message dispatching' }
LowtalkStructureInstance >> lowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler [
	| precedence slot value valueType method |
	(selector == #class) ifTrue: [ ^ type ].
	
	method := type concreteMethodForSelector: selector.
	method ifNotNil: [
		^ method lowtalkValueWithArguments: { self } , arguments
		types: {self type ref} , argumentTypes compiler: aCompiler at: sendingNode
	].
	
	precedence := selector precedence.
	precedence = 1 ifTrue: [ 
		type slotNamed: selector ifPresent: [ :slotDescription |
			^ slots at: slotDescription index + 1
		]
	].
	precedence = 3 ifTrue: [
		type slotNamed: selector allButLast ifPresent: [ :slotDescription |
			slot := slots at: slotDescription index + 1.
			value := arguments first.
			valueType := argumentTypes first.
			slot value: (valueType convertValue: value toType: slot valueType at: sendingNode).
			^ slot
		]
	].

	^ super lowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
]

{ #category : #'message dispatching' }
LowtalkStructureInstance >> lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler [
	| precedence slot value valueType method |
	(selector == #class) ifTrue: [ ^ type ].
	
	method := type concreteMethodForSelector: selector.
	method ifNotNil: [
		^ method lowtalkValueWithArguments: { self } , (arguments collect: #value)
		types: {self type ref} , (arguments collect: #type) compiler: aCompiler at: sendingNode
	].
	
	precedence := selector precedence.
	precedence = 1 ifTrue: [ 
		type slotNamed: selector ifPresent: [ :slotDescription |
			^ slots at: slotDescription index + 1
		]
	].
	precedence = 3 ifTrue: [
		type slotNamed: selector allButLast ifPresent: [ :slotDescription |
			slot := slots at: slotDescription index + 1.
			value := arguments first value.
			valueType := arguments first inferType.
			slot value: (valueType convertValue: value toType: slot valueType at: sendingNode).
			^ slot
		]
	].

	^ super lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
]

{ #category : #'slot accessing' }
LowtalkStructureInstance >> lowtalkRefGetFieldRef: slotDescription [
	^ slots at: slotDescription index + 1
]

{ #category : #'slot accessing' }
LowtalkStructureInstance >> lowtalkRefSetField: slotDescription value: aValue [
	| slot |
	slot := slots at: slotDescription index + 1.
	slot value: aValue.
	^ slot
]

{ #category : #'slot accessing' }
LowtalkStructureInstance >> lowtalkSetField: slotDescription value: aValue [
	| slot |
	slot := slots at: slotDescription index + 1.
	slot value: aValue.
	^ slot
]

{ #category : #'slot accessing' }
LowtalkStructureInstance >> pointerForSlotDescription: desc [
	^ slots at: desc index + 1
]

{ #category : #accessing }
LowtalkStructureInstance >> slots [
	^ slots
]

{ #category : #accessing }
LowtalkStructureInstance >> slots: anObject [
	slots := anObject
]

{ #category : #accessing }
LowtalkStructureInstance >> type [
	^ type
]

{ #category : #accessing }
LowtalkStructureInstance >> type: anObject [
	type := anObject
]

{ #category : #evaluating }
LowtalkStructureInstance >> value [
	^ self
]
