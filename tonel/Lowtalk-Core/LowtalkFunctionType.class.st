Class {
	#name : #LowtalkFunctionType,
	#superclass : #LowtalkType,
	#instVars : [
		'callingConvention',
		'arguments',
		'returnType',
		'variadic',
		'name'
	],
	#category : 'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkFunctionType >> arguments [
	^ arguments
]

{ #category : #accessing }
LowtalkFunctionType >> arguments: anObject [
	arguments := anObject
]

{ #category : #'as yet unclassified' }
LowtalkFunctionType >> block [
	^ (LowtalkBlockObjectType target: compilationTarget) functionType: self
]

{ #category : #accessing }
LowtalkFunctionType >> buildSSAType [
	^ (SLVMFunctionType callingConvention: callingConvention arguments: (arguments collect: #ssaType) returnType: returnType ssaType) variadic: variadic
]

{ #category : #accessing }
LowtalkFunctionType >> callingConvention [
	^ callingConvention
]

{ #category : #accessing }
LowtalkFunctionType >> callingConvention: anObject [
	callingConvention := anObject
]

{ #category : #'calling conventions' }
LowtalkFunctionType >> cdecl [
	<compileTime>
	self callingConvention: SLVMFunctionType cdeclCallingConvention.
	
]

{ #category : #'as yet unclassified' }
LowtalkFunctionType >> cvariadic [
	<compileTime>
	^ self copy variadic: true
]

{ #category : #testing }
LowtalkFunctionType >> hasSmalltalkConvention [
	^ callingConvention == SLVMFunctionType smalltalkCallingConvention
]

{ #category : #initialization }
LowtalkFunctionType >> initialize [
	super initialize.
	callingConvention := SLVMFunctionType smalltalkCallingConvention.
	variadic := false.
	readOnly := true.
]

{ #category : #testing }
LowtalkFunctionType >> isFunctionType [
	^ true
]

{ #category : #'as yet unclassified' }
LowtalkFunctionType >> moreArguments [
	<compileTime>
	^ self copy variadic: true
]

{ #category : #accessing }
LowtalkFunctionType >> name [
	^ name ifNil: [name := ByteString streamContents: [ :out |
		out nextPut: $(.
		arguments doWithIndex: [ :arg :index|
			index > 1 ifTrue: [out nextPutAll: ', '].
			out nextPutAll: arg name.
		].
		out nextPutAll: ') -> '; nextPutAll: returnType name.
		variadic ifTrue: [ out nextPutAll: ' cvariadic' ].
	 ]]
]

{ #category : #printing }
LowtalkFunctionType >> printOn: aStream [
	aStream nextPutAll: '('.
	arguments doWithIndex: [ :arg :index |
		index > 1 ifTrue: [ 
			aStream nextPutAll: ', '.
		].
		aStream print: arg
	].

	aStream nextPutAll: ') -> '; print: returnType.
]

{ #category : #accessing }
LowtalkFunctionType >> returnType [
	^ returnType
]

{ #category : #accessing }
LowtalkFunctionType >> returnType: anObject [
	returnType := anObject
]

{ #category : #'calling conventions' }
LowtalkFunctionType >> smalltalk [
	<compileTime>
	self callingConvention: SLVMFunctionType smalltalkCallingConvention.
	
]

{ #category : #'calling conventions' }
LowtalkFunctionType >> stdcall [
	<compileTime>
	self callingConvention: SLVMFunctionType stdcallCallingConvention.
	
]

{ #category : #accessing }
LowtalkFunctionType >> variadic [
	^ variadic
]

{ #category : #accessing }
LowtalkFunctionType >> variadic: anObject [
	variadic := anObject
]
