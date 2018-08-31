Class {
	#name : #LowtalkMetaType,
	#superclass : #LowtalkSpecificDynamicObjectType,
	#instVars : [
		'instanceType'
	],
	#classVars : [
		'TypeSpecialMessageType'
	],
	#category : #'Lowtalk-Core-Types'
}

{ #category : #testing }
LowtalkMetaType >> canBeImplicitlyConvertedTo: targetType [
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	((instanceType respondsTo: #metaClass) and: [ targetType == instanceType metaClass ]) ifTrue: [ ^ true ].
	^ false
]

{ #category : #methods }
LowtalkMetaType >> concreteMethodForSelector: selector [
	^ instanceType concreteMethodForMetaSelector: selector
]

{ #category : #converting }
LowtalkMetaType >> convertValue: value toSSAConstantWith: compiler [
	^ compiler convertDynamicObjectSSAConstant: value
]

{ #category : #accessing }
LowtalkMetaType >> instanceType [
	<compileTime>
	^ instanceType
]

{ #category : #accessing }
LowtalkMetaType >> instanceType: anObject [
	instanceType := anObject
]

{ #category : #testing }
LowtalkMetaType >> isMetaType [
	^ true
]

{ #category : #testing }
LowtalkMetaType >> isValueConforming: value [
	^ value isLowtalkType
]

{ #category : #methods }
LowtalkMetaType >> methodSignatureForSelector: selector environment: anEnvironment [
	^ instanceType methodSignatureForMetaSelector: selector environment: anEnvironment
]

{ #category : #accessing }
LowtalkMetaType >> name [
	^ instanceType name , ' metaType'
]

{ #category : #accessing }
LowtalkMetaType >> resultTypeForSelector: selector message: messageNode compiler: aCompiler evaluator: evaluator [
	^ instanceType resultTypeForMetaSelector: selector message: messageNode compiler: aCompiler evaluator: evaluator
]

{ #category : #'special messages' }
LowtalkMetaType >> specialMessageTypeForSelector: selector [
	(instanceType specialMessageTypeForMetaSelector: selector) ifNotNil: [ :result |
		^ result
	].

	^ super specialMessageTypeForSelector: selector
]

{ #category : #coercions }
LowtalkMetaType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	((instanceType respondsTo: #metaClass) and: [ targetType == instanceType metaClass ]) ifTrue: [
		^ value
	].

	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]
