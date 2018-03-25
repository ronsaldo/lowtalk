Class {
	#name : #LowtalkVoidType,
	#superclass : #LowtalkOpaqueType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #associating }
LowtalkVoidType >> -> returnType [
	<compileTime>
	^ (LowtalkFunctionType target: compilationTarget)
		arguments: #();
		returnType: returnType;
		yourself
]

{ #category : #accessing }
LowtalkVoidType >> buildSSAType [
	^ SLVMType voidType
]

{ #category : #coercions }
LowtalkVoidType >> irCoerceImplicitlyTo: targetType with: irBuilder at: node [
	targetType isNilType ifTrue: [ ^ self ].
	^ super irCoerceImplicitlyTo: targetType with: irBuilder at: node
]

{ #category : #testing }
LowtalkVoidType >> isVoidType [
	^ true
]

{ #category : #accessing }
LowtalkVoidType >> name [
	^ #Void
]
