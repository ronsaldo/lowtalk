Class {
	#name : #LowtalkSandboxObjectModel,
	#superclass : #LowtalkObjectModel,
	#instVars : [
		'characterShift',
		'characterTag',
		'characterTagMask',
		'classVariableClass',
		'closureHeaderType',
		'closureInstantiateFunction',
		'convertArrayFunction',
		'convertBoxedFloat64Function',
		'convertByteStringFunction',
		'convertByteSymbolFunction',
		'convertMethodContextMetadataFunction',
		'createGlobalVariableAssociationFunction',
		'falseVariable',
		'floatToObjectFunction',
		'specialLiteralClasses',
		'getObjectClassFunction',
		'headerType',
		'globalVariableClass',
		'increaseReference',
		'marryThisContextFunction',
		'methodDictionarySlotIndex',
		'namespaceCreationFunction',
		'newObjectHeaderWithBytes',
		'newObjectHeaderWithPointers',
		'newObjectHeaderWithWeakPointers',
		'newObjectHeaderWithWords',
		'nonLocalReturnFunction',
		'objectToFloatFunction',
		'objectToPointerFunction',
		'objectVariableHeaderCreationFunction',
		'pointerToObjectFunction',
		'readBarrier',
		'releaseReference',
		'sendTrampolineFunction',
		'setIdentityHashFunction',
		'setObjectClassFunction',
		'smallFloatShift',
		'smallFloatTag',
		'smallFloatTagMask',
		'smallIntegerShift',
		'smallIntegerTag',
		'smallIntegerTagMask',
		'superClassSlotIndex',
		'superSendTrampolineFunction',
		'trueVariable',
		'truncateIdentityHashFunction',
		'widowThisContextFunction',
		'writeBarrier',
		'writeBarrierNoIncrement',
		'createNamedFormatSpec',
		'defaultSuperclass',
		'arrayClass'
	],
	#category : #'Lowtalk-Core-FrontEnd'
}

{ #category : #initialization }
LowtalkSandboxObjectModel class >> initialize [
	SpecialLiterals := #(nil true false).
	
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> arrayClass [
	<compileTime>
	^ arrayClass
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> arrayClass: aClass [
	<compileTime>
	arrayClass := aClass
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> characterShift [
	<compileTime>
	^ characterShift
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> characterShift: anObject [
	<compileTime>
	characterShift := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> characterTag [
	<compileTime>
	^ characterTag
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> characterTag: anObject [
	<compileTime>
	characterTag := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> characterTagMask [
	<compileTime>
	^ characterTagMask
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> characterTagMask: anObject [
	<compileTime>
	characterTagMask := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> classVariableClass [
	<compileTime>
	^ classVariableClass
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> classVariableClass: anObject [
	<compileTime>
	classVariableClass := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> closureHeaderType [
	<compileTime>
	^ closureHeaderType
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> closureHeaderType: anObject [
	<compileTime>
	closureHeaderType := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> closureInstantiateFunction [
	<compileTime>
	^ closureInstantiateFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> closureInstantiateFunction: anObject [
	<compileTime>
	closureInstantiateFunction := anObject
]

{ #category : #'object creation' }
LowtalkSandboxObjectModel >> convertAdditionalMethodState: methodState [
	^ self convertByteSymbol: methodState selector
]

{ #category : #'object creation' }
LowtalkSandboxObjectModel >> convertArray: anArray [
	^ convertArrayFunction value: anArray
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> convertArrayFunction [
	<compileTime>
	^ convertArrayFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> convertArrayFunction: anObject [
	<compileTime>
	convertArrayFunction := anObject
]

{ #category : #'object creation' }
LowtalkSandboxObjectModel >> convertBoxedFloat64: aFloat [
	| data bytes |
	data := ((aFloat basicAt: 1) << 32) | (aFloat basicAt: 2).
	bytes := ByteArray new: 8.
	bytes unsignedLongLongAt: 1 put: data.
	^ convertBoxedFloat64Function value: bytes
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> convertBoxedFloat64Function [
	<compileTime>
	^ convertBoxedFloat64Function
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> convertBoxedFloat64Function: anObject [
	<compileTime>
	convertBoxedFloat64Function := anObject
]

{ #category : #'object creation' }
LowtalkSandboxObjectModel >> convertByteString: anString [
	^ convertByteStringFunction value: anString
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> convertByteStringFunction [
	<compileTime>
	^ convertByteStringFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> convertByteStringFunction: anObject [
	<compileTime>
	convertByteStringFunction := anObject
]

{ #category : #'object creation' }
LowtalkSandboxObjectModel >> convertByteSymbol: aSymbol [
	^ convertByteSymbolFunction value: aSymbol
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> convertByteSymbolFunction [
	<compileTime>
	^ convertByteSymbolFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> convertByteSymbolFunction: anObject [
	<compileTime>
	convertByteSymbolFunction := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> convertMethodContextMetadataFunction [
	<compileTime>
	^ convertMethodContextMetadataFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> convertMethodContextMetadataFunction: anObject [
	<compileTime>
	convertMethodContextMetadataFunction := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> createGlobalVariableAssociationFunction [
	<compileTime>
	^ createGlobalVariableAssociationFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> createGlobalVariableAssociationFunction: anObject [
	<compileTime>
	createGlobalVariableAssociationFunction := anObject
]

{ #category : #'class creation' }
LowtalkSandboxObjectModel >> createNamedFormat: formatName withInstanceSize: instanceSize [
	^ createNamedFormatSpec lowtalkValueWithArguments: { formatName . instanceSize } types: { compiler objectType . compiler integerLiteralType } compiler: compiler at: nil
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> createNamedFormatSpec [
	<compileTime>
	^ createNamedFormatSpec
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> createNamedFormatSpec: aFunction [
	<compileTime>
	createNamedFormatSpec := aFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> defaultSuperclass [
	<compileTime>
	^ defaultSuperclass
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> defaultSuperclass: aDefaultSuperclass [
	<compileTime>
	defaultSuperclass := aDefaultSuperclass
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> falseVariable [
	<compileTime>
	^ falseVariable
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> falseVariable: anObject [
	<compileTime>
	falseVariable := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> floatToObjectFunction [
	<compileTime>
	^ floatToObjectFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> floatToObjectFunction: anObject [
	<compileTime>
	floatToObjectFunction := anObject
]

{ #category : #'object accessing' }
LowtalkSandboxObjectModel >> getObject: object slot: slot [
	<compileTime>
	self assert: object class == LowtalkObjectInstance.
	^ object slots at: slot
]

{ #category : #'class creation' }
LowtalkSandboxObjectModel >> getObjectClass: anObject [
	<compileTime>
	(SpecialLiterals includes: anObject) ifTrue: [
		^ specialLiteralClasses at: anObject
	].

	^ (getObjectClassFunction lowtalkValueWithArguments: { anObject headerPointer } types: { headerType pointer } compiler: compiler at: nil) object
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> getObjectClassFunction [
	<compileTime>
	^ getObjectClassFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> getObjectClassFunction: anObject [
	<compileTime>
	getObjectClassFunction := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> globalVariableClass [
	<compileTime>
	^ globalVariableClass
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> globalVariableClass: anObject [
	<compileTime>
	globalVariableClass := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> headerType [
	<compileTime>
	^ headerType
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> headerType: anObject [
	<compileTime>
	headerType := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> increaseReference [
	<compileTime>
	^ increaseReference
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> increaseReference: anObject [
	<compileTime>
	increaseReference := anObject
]

{ #category : #initialization }
LowtalkSandboxObjectModel >> initialize [
	super initialize.
	specialLiteralClasses := Dictionary new.
]

{ #category : #testing }
LowtalkSandboxObjectModel >> isSandboxObjectModel [
	^ true
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> marryThisContextFunction [
	<compileTime>
	^ marryThisContextFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> marryThisContextFunction: anObject [
	<compileTime>
	marryThisContextFunction := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> methodDictionarySlotIndex [
	<compileTime>
	^ methodDictionarySlotIndex
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> methodDictionarySlotIndex: anObject [
	<compileTime>
	methodDictionarySlotIndex := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> namespaceCreationFunction [
	<compileTime>
	^ namespaceCreationFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> namespaceCreationFunction: anObject [
	<compileTime>
	namespaceCreationFunction := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> newObjectHeaderWithBytes [
	<compileTime>
	^ newObjectHeaderWithBytes
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> newObjectHeaderWithBytes: anObject [
	<compileTime>
	newObjectHeaderWithBytes := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> newObjectHeaderWithPointers [
	<compileTime>
	^ newObjectHeaderWithPointers
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> newObjectHeaderWithPointers: anObject [
	<compileTime>
	newObjectHeaderWithPointers := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> newObjectHeaderWithWeakPointers [
	<compileTime>
	^ newObjectHeaderWithWeakPointers
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> newObjectHeaderWithWeakPointers: anObject [
	<compileTime>
	newObjectHeaderWithWeakPointers := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> newObjectHeaderWithWords [
	<compileTime>
	^ newObjectHeaderWithWords
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> newObjectHeaderWithWords: anObject [
	<compileTime>
	newObjectHeaderWithWords := anObject
]

{ #category : #'object creation' }
LowtalkSandboxObjectModel >> newObjectWithBytes: slotCount [
	<compileTime>
	| header |
	header := newObjectHeaderWithBytes value: slotCount.
	^ LowtalkObjectInstance new
		compiler: compiler;
		header: header;
		slots: (ByteArray new: slotCount);
		yourself
	
]

{ #category : #'object creation' }
LowtalkSandboxObjectModel >> newObjectWithPointers: slotCount [
	<compileTime>
	| header |
	header := newObjectHeaderWithPointers value: slotCount.
	^ LowtalkObjectInstance new
		compiler: compiler;
		header: header;
		slots: (Array new: slotCount);
		yourself
	
]

{ #category : #'object creation' }
LowtalkSandboxObjectModel >> newObjectWithWeakPointers: slotCount [
	<compileTime>
	| header |
	header := newObjectHeaderWithWeakPointers value: slotCount.
	^ LowtalkObjectInstance new
		compiler: compiler;
		header: header;
		slots: (WeakArray new: slotCount);
		yourself
	
]

{ #category : #'object creation' }
LowtalkSandboxObjectModel >> newObjectWithWords: slotCount [
	<compileTime>
	| header |
	header := newObjectHeaderWithWords value: slotCount.
	^ LowtalkObjectInstance new
		compiler: compiler;
		header: header;
		slots: (WordArray new: slotCount);
		yourself
	
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> nonLocalReturnFunction [
	<compileTime>
	^ nonLocalReturnFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> nonLocalReturnFunction: anObject [
	<compileTime>
	nonLocalReturnFunction := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> objectToFloatFunction [
	<compileTime>
	^ objectToFloatFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> objectToFloatFunction: anObject [
	<compileTime>
	objectToFloatFunction := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> objectToPointerFunction [
	<compileTime>
	^ objectToPointerFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> objectToPointerFunction: anObject [
	<compileTime>
	objectToPointerFunction := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> objectVariableHeaderCreationFunction [
	<compileTime>
	^ objectVariableHeaderCreationFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> objectVariableHeaderCreationFunction: anObject [
	<compileTime>
	objectVariableHeaderCreationFunction := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> pointerToObjectFunction [
	<compileTime>
	^ pointerToObjectFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> pointerToObjectFunction: anObject [
	<compileTime>
	pointerToObjectFunction := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> readBarrier [
	<compileTime>
	^ readBarrier
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> readBarrier: anObject [
	<compileTime>
	readBarrier := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> releaseReference [
	<compileTime>
	^ releaseReference
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> releaseReference: anObject [
	<compileTime>
	releaseReference := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> sendTrampolineFunction [
	<compileTime>
	^ sendTrampolineFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> sendTrampolineFunction: anObject [
	<compileTime>
	sendTrampolineFunction := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> setIdentityHashFunction [
	<compileTime>
	^ setIdentityHashFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> setIdentityHashFunction: anObject [
	<compileTime>
	setIdentityHashFunction := anObject
]

{ #category : #'class creation' }
LowtalkSandboxObjectModel >> setObject: anObject class: class [
	<compileTime>
	(SpecialLiterals includes: anObject) ifTrue: [
		^ specialLiteralClasses at: anObject put: class
	].

	setObjectClassFunction lowtalkValueWithArguments: { anObject headerPointer. class headerPointer } types: { headerType pointer . headerType pointer } compiler: compiler at: nil.
	^ anObject
]

{ #category : #'object accessing' }
LowtalkSandboxObjectModel >> setObject: object identityHash: identityHash [
	<compileTime>
	setIdentityHashFunction lowtalkValueWithArguments: { object headerPointer . identityHash } types: { headerType pointer . compiler uintPointerType} compiler: compiler at: nil
]

{ #category : #'object accessing' }
LowtalkSandboxObjectModel >> setObject: object slot: slot value: value [
	<compileTime>
	self assert: object class == LowtalkObjectInstance.
	object slots at: slot put: value
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> setObjectClassFunction [
	<compileTime>
	^ setObjectClassFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> setObjectClassFunction: anObject [
	<compileTime>
	setObjectClassFunction := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> smallFloatShift [
	<compileTime>
	^ smallFloatShift
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> smallFloatShift: anObject [
	<compileTime>
	smallFloatShift := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> smallFloatTag [
	<compileTime>
	^ smallFloatTag
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> smallFloatTag: anObject [
	<compileTime>
	smallFloatTag := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> smallFloatTagMask [
	<compileTime>
	^ smallFloatTagMask
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> smallFloatTagMask: anObject [
	<compileTime>
	smallFloatTagMask := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> smallIntegerShift [
	<compileTime>
	^ smallIntegerShift
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> smallIntegerShift: anObject [
	<compileTime>
	smallIntegerShift := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> smallIntegerTag [
	<compileTime>
	^ smallIntegerTag
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> smallIntegerTag: anObject [
	<compileTime>
	smallIntegerTag := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> smallIntegerTagMask [
	<compileTime>
	^ smallIntegerTagMask
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> smallIntegerTagMask: anObject [
	<compileTime>
	smallIntegerTagMask := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> superClassSlotIndex [
	<compileTime>
	^ superClassSlotIndex
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> superClassSlotIndex: anObject [
	<compileTime>
	superClassSlotIndex := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> superSendTrampolineFunction [
	<compileTime>
	^ superSendTrampolineFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> superSendTrampolineFunction: anObject [
	<compileTime>
	superSendTrampolineFunction := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> trueVariable [
	<compileTime>
	^ trueVariable
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> trueVariable: anObject [
	<compileTime>
	trueVariable := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> truncateIdentityHash: anIdentityHash [
	^ truncateIdentityHashFunction value: anIdentityHash
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> truncateIdentityHashFunction [
	<compileTime>
	^ truncateIdentityHashFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> truncateIdentityHashFunction: anObject [
	<compileTime>
	truncateIdentityHashFunction := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> widowThisContextFunction [
	<compileTime>
	^ widowThisContextFunction
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> widowThisContextFunction: anObject [
	<compileTime>
	widowThisContextFunction := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> writeBarrier [
	<compileTime>
	^ writeBarrier
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> writeBarrier: anObject [
	<compileTime>
	writeBarrier := anObject
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> writeBarrierNoIncrement [
	<compileTime>
	^ writeBarrierNoIncrement
]

{ #category : #accessing }
LowtalkSandboxObjectModel >> writeBarrierNoIncrement: anObject [
	<compileTime>
	writeBarrierNoIncrement := anObject
]
