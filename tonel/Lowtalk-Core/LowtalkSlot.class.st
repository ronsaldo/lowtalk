Class {
	#name : #LowtalkSlot,
	#superclass : #LowtalkBObject,
	#instVars : [
		'name',
		'type',
		'index',
		'offset',
		'ssaReceiverCastType',
		'visibility',
		'properties'
	],
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #converting }
LowtalkSlot >> asInstanceVariableSlot [
	| result |
	result := InstanceVariableSlot named: self name.
	properties ifNotNil: [
		properties keysAndValuesDo: [ :key :value |
			result propertyAt: key put: value
		]
	].

	^ result
]

{ #category : #converting }
LowtalkSlot >> asLowtalkSlotWith: aCompiler [
	^ self
]

{ #category : #converting }
LowtalkSlot >> asSLVMStructureFieldSlot [
	| result |
	result := SLVMStructureFieldSlot named: self name.
	result type: self type ssaType.
	properties ifNotNil: [
		properties keysAndValuesDo: [ :key :value |
			result propertyAt: key put: value
		]
	].

	^ result
]

{ #category : #'accessor generation' }
LowtalkSlot >> createGetterOn: behavior [
	| source methodExpression |
	source := ByteString streamContents: [:out |
		out << ':[' << name; lf.
		out tab << '<accessor>'; lf.
		out tab << ' ^ ' << name; lf.
		out << ']'.
	].

	methodExpression := behavior compiler evaluateString: source.
	methodExpression node returnTypeExpression: (LowtalkASTObjectLiteral new value: type).
	behavior category: 'accessing' methods: { methodExpression }
]

{ #category : #'as yet unclassified' }
LowtalkSlot >> createPublicAccessorsOn: behavior [
	self isPrivate ifTrue: [ ^ self ].
	self createGetterOn: behavior.
	self createSetterOn: behavior.
]

{ #category : #'accessor generation' }
LowtalkSlot >> createSetterOn: behavior [	
	| source methodExpression |
	source := ByteString streamContents: [:out |
		out << ':[' << name << ': newValueFor_' << name; lf.
		out tab << '<accessor>'; lf.
		out tab << name << ' := newValueFor_' << name; lf.
		out << ']'.
	].

	methodExpression := behavior compiler evaluateString: source.
	methodExpression node arguments first typeExpression: (LowtalkASTObjectLiteral new value: type).
	behavior category: 'accessing' methods: { methodExpression }
]

{ #category : #defaults }
LowtalkSlot >> defaultValue [
	^ type defaultValue
]

{ #category : #'code generation' }
LowtalkSlot >> emitSSASlotReferenceOf: objectValue builder: builder at: node [
	| slotContainerValue |
	slotContainerValue := objectValue.
	(ssaReceiverCastType isNotNil and: [ objectValue type isDynamicObjectType ]) ifTrue: [ 
		self assert: ssaReceiverCastType isPointerType.
		"Get a pointer to the first slot."
		slotContainerValue := (builder getReference: slotContainerValue element: (SLVMConstantValue int: 0)).
		
		"Cast the pointer of the first slot."
		slotContainerValue := builder bitCast: slotContainerValue target: ssaReceiverCastType
	].

	^ builder getReference: slotContainerValue element: (builder constInt: index)

]

{ #category : #accessing }
LowtalkSlot >> index [
	^ index
]

{ #category : #accessing }
LowtalkSlot >> index: anObject [
	index := anObject.
]

{ #category : #visibility }
LowtalkSlot >> isPrivate [
	^ visibility == #private
]

{ #category : #visibility }
LowtalkSlot >> isProtected [
	^ visibility == #protected
]

{ #category : #visibility }
LowtalkSlot >> isPublic [
	^ visibility == #public
]

{ #category : #accessing }
LowtalkSlot >> name [
	^ name
]

{ #category : #accessing }
LowtalkSlot >> name: anObject [
	name := anObject
]

{ #category : #accessing }
LowtalkSlot >> offset [
	^ offset
]

{ #category : #accessing }
LowtalkSlot >> offset: anObject [
	offset := anObject
]

{ #category : #printing }
LowtalkSlot >> printOn: aStream [
	aStream print: name; nextPutAll:  ' => '; print: type
]

{ #category : #visibility }
LowtalkSlot >> private [
	<compileTime>
	self visibility: #private
]

{ #category : #properties }
LowtalkSlot >> properties [
	^ properties
]

{ #category : #properties }
LowtalkSlot >> propertyAt: propertyName [
	<compileTime>
	properties ifNil: [ self error: 'Property is not present.' ].
	^ properties at: propertyName
]

{ #category : #properties }
LowtalkSlot >> propertyAt: propertyName ifAbsent: aBlock [
	<compileTime>
	properties ifNil: [ ^ aBlock value ].
	^ properties at: propertyName ifAbsent: aBlock
]

{ #category : #properties }
LowtalkSlot >> propertyAt: propertyName ifAbsentPut: aBlock [
	<compileTime>
	properties ifNil: [ properties := Dictionary new ].
	^ properties at: propertyName ifAbsentPut: aBlock
]

{ #category : #properties }
LowtalkSlot >> propertyAt: propertyName put: propertyValue [
	<compileTime>
	properties ifNil: [ properties := Dictionary new ].
	^ properties at: propertyName put: propertyValue
]

{ #category : #visibility }
LowtalkSlot >> protected [
	<compileTime>
	self visibility: #protected
]

{ #category : #visibility }
LowtalkSlot >> public [
	<compileTime>
	self visibility: #public
]

{ #category : #'as yet unclassified' }
LowtalkSlot >> setterSpecialSelectorType [
	^ #SetSlot
]

{ #category : #accessing }
LowtalkSlot >> slot [
	<compileTime>
	^ self
]

{ #category : #'as yet unclassified' }
LowtalkSlot >> specialSelectorType [
	^ #Slot
]

{ #category : #accessing }
LowtalkSlot >> ssaReceiverCastType [
	^ ssaReceiverCastType
]

{ #category : #accessing }
LowtalkSlot >> ssaReceiverCastType: anObject [
	ssaReceiverCastType := anObject
]

{ #category : #accessing }
LowtalkSlot >> type [
	^ type
]

{ #category : #accessing }
LowtalkSlot >> type: anObject [
	type := anObject
]

{ #category : #'as yet unclassified' }
LowtalkSlot >> validStructureFieldName [
	^ name ifNil: [ ('f' , index asString) asSymbol ]
]

{ #category : #'gpu attributes' }
LowtalkSlot >> vertexFormat: formatName [
	<compileTime>
	self propertyAt: #vertexFormat put: formatName
]

{ #category : #'gpu attributes' }
LowtalkSlot >> vertexLocation: bindingLocation [
	<compileTime>
	self propertyAt: #vertexLocation put: bindingLocation
]

{ #category : #accessing }
LowtalkSlot >> visibility [
	^ visibility
]

{ #category : #accessing }
LowtalkSlot >> visibility: anObject [
	visibility := anObject
]
