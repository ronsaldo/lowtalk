Class {
	#name : #LowtalkObjectHeaderPointer,
	#superclass : #LowtalkCompileTimePointer,
	#instVars : [
		'object'
	],
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #accessing }
LowtalkObjectHeaderPointer >> object [
	^ object
]

{ #category : #accessing }
LowtalkObjectHeaderPointer >> object: anObject [
	object := anObject
]

{ #category : #'as yet unclassified' }
LowtalkObjectHeaderPointer >> toSSAPointerConstantWith: aCompiler [
	| objectPointer headerPointerType |
	objectPointer := object toSSAPointerConstantWith: aCompiler.
	headerPointerType := aCompiler objectModel headerType pointer ssaType.
	^ SLVMConstant pointer: objectPointer castTo: headerPointerType
]

{ #category : #evaluating }
LowtalkObjectHeaderPointer >> value [
	<compileTime>
	^ object header
]
