Class {
	#name : #LowtalkSLVMObjectModel,
	#superclass : #SLVMObjectModel,
	#instVars : [
		'compiler',
		'messageSendTrampoline',
		'messageSuperSendTrampoline',
		'contextMetaDataHeaderSize',
		'closureInstantiateFunction',
		'pointerToObjectFunction',
		'objectToPointerFunction',
		'marryThisContextFunction',
		'widowThisContextFunction',
		'nonLocalReturnFunction',
		'floatToObjectFunction',
		'objectToFloatFunction'
	],
	#category : #'Lowtalk-Core-FrontEnd'
}

{ #category : #accessing }
LowtalkSLVMObjectModel >> characterShift [
	^ compiler objectModel characterShift
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> characterTag [
	^ compiler objectModel characterTag
]

{ #category : #'trampoline names' }
LowtalkSLVMObjectModel >> closureHeaderType [
	^ compiler objectModel closureHeaderType ifNotNil: [:closureHeaderType | closureHeaderType ssaType]
]

{ #category : #'trampoline names' }
LowtalkSLVMObjectModel >> closureInstantiateFunction [
	^ closureInstantiateFunction ifNil: [
		closureInstantiateFunction := compiler objectModel closureInstantiateFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> compiler [
	^ compiler
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> compiler: anObject [
	compiler := anObject
]

{ #category : #'as yet unclassified' }
LowtalkSLVMObjectModel >> contextMetaDataHeaderSize [
	^ contextMetaDataHeaderSize ifNil: [ contextMetaDataHeaderSize := (compiler objectModel convertMethodContextMetadataFunction value: nil value: #()) ssaValueType size ]
]

{ #category : #'trampoline names' }
LowtalkSLVMObjectModel >> convertConstantValue: value inModule: module [
	value isSLVMObject ifTrue: [
		self assert: (value type isPointerType or: [value type isDynamicObjectType]).
		(value isFunction or: [value isFunctionExitPoint]) ifTrue: [
			^ SLVMConstant pointer:
				(SLVMConstant add: (SLVMConstant pointer: value castTo: compiler uintPointerType ssaType) with:
				(SLVMConstant type: compiler uintPointerType ssaType value: 1))
				castTo: compiler objectType ssaType
		] ifFalse: [
			^ SLVMConstant pointer: value castTo: compiler objectType ssaType
		]
	].

	(self isInlineLiteral: value) ifTrue: [ ^ self convertInlineLiteral: value ].
	^ compiler doConvertSSADynamicConstantValue: value inModule: module
]

{ #category : #visiting }
LowtalkSLVMObjectModel >> createFunctionContextMetaData: function [
	| result module header slotType slotConstants resultConstant |
	module := function module.
	result := compiler objectModel convertMethodContextMetadataFunction value: function value: (function dynamicLiterals collect: #value).
	
	header := result header asSSAConstantValueIn: module.
	slotType := result slotType.
	slotConstants := result slots collect: [ :slotValue | slotType convertValue: slotValue toSSAConstantWith: compiler ] as: Array.
	slotConstants := SLVMConstant array: result slotsType ssaType slots: slotConstants.
	
	resultConstant := SLVMConstant structure: result ssaValueType slots: { header . slotConstants }.
	^ resultConstant
]

{ #category : #'as yet unclassified' }
LowtalkSLVMObjectModel >> createObjectVariableHeaderClass: variableClass name: variableName [
	| instance |
	compiler objectModel objectVariableHeaderCreationFunction ifNil: [ ^ nil ].
	instance := compiler objectModel objectVariableHeaderCreationFunction 
		lowtalkValueWithArguments: { variableClass headerPointer . variableName }
		types: { compiler objectModel headerType pointer . compiler objectType }
		compiler: compiler at: nil.
	
	^ instance asSSAConstantValueIn: compiler ssaModule
]

{ #category : #'as yet unclassified' }
LowtalkSLVMObjectModel >> falseValue [
	^ compiler objectModel falseVariable ssaValue initialValue
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> floatToObjectFunction [
	^ floatToObjectFunction ifNil: [
		floatToObjectFunction := compiler objectModel floatToObjectFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> increaseReference [
	^ compiler ssaIncreaseReference
]

{ #category : #testing }
LowtalkSLVMObjectModel >> isReferenceCounted [
	^ self increaseReference isNotNil and: [ self releaseReference isNotNil ]
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> marryThisContextFunction [
	^ marryThisContextFunction ifNil: [
		marryThisContextFunction := compiler objectModel marryThisContextFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]
]

{ #category : #'trampoline names' }
LowtalkSLVMObjectModel >> messageSendTrampoline [
	^ messageSendTrampoline ifNil: [ 
		messageSendTrampoline := compiler ssaValueForObject: compiler objectModel sendTrampolineFunction
	]
]

{ #category : #'trampoline names' }
LowtalkSLVMObjectModel >> messageSuperSendTrampoline [
	^ messageSuperSendTrampoline ifNil: [ 
		messageSuperSendTrampoline := compiler ssaValueForObject: compiler objectModel superSendTrampolineFunction
	]
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> nonLocalReturnFunction [
	^ nonLocalReturnFunction ifNil: [
		nonLocalReturnFunction := compiler objectModel nonLocalReturnFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]
]

{ #category : #'trampoline names' }
LowtalkSLVMObjectModel >> objectHeaderSize [
	^ compiler objectModel headerType ssaType size
]

{ #category : #'trampoline names' }
LowtalkSLVMObjectModel >> objectHeaderType [
	^ compiler objectModel headerType ifNotNil: [:headerType | headerType ssaType]
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> objectToFloatFunction [
	^ objectToFloatFunction ifNil: [
		objectToFloatFunction := compiler objectModel objectToFloatFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> objectToPointerFunction [
	^ objectToPointerFunction ifNil: [
		objectToPointerFunction := compiler objectModel objectToPointerFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> pointerToObjectFunction [
	^ pointerToObjectFunction ifNil: [
		pointerToObjectFunction := compiler objectModel pointerToObjectFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> readBarrier [
	^ compiler ssaReadBarrier
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> releaseReference [
	^ compiler ssaReleaseReference
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> smallFloatShift [
	^ compiler objectModel smallFloatShift
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> smallFloatTag [
	^ compiler objectModel smallFloatTag
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> smallIntegerShift [
	^ compiler objectModel smallIntegerShift
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> smallIntegerTag [
	^ compiler objectModel smallIntegerTag
]

{ #category : #'trampoline names' }
LowtalkSLVMObjectModel >> stackLimitTrampoline [
	^ #_slvm_dynrun_stack_limit_trap
]

{ #category : #'as yet unclassified' }
LowtalkSLVMObjectModel >> trueValue [
	^ compiler objectModel trueVariable ssaValue initialValue
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> widowThisContextFunction [
	^ widowThisContextFunction ifNil: [
		widowThisContextFunction := compiler objectModel widowThisContextFunction ifNotNil: [:function | compiler ssaValueForObject: function ] ]
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> writeBarrier [
	^ compiler ssaWriteBarrier
]

{ #category : #accessing }
LowtalkSLVMObjectModel >> writeBarrierNoIncrement [
	^ compiler ssaWriteBarrierNoIncrement
]
