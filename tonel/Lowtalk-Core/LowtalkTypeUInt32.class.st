Class {
	#name : #LowtalkTypeUInt32,
	#superclass : #LowtalkTypeInt32,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkTypeUInt32 >> buildSSAType [
	^ SLVMType uintType 
]

{ #category : #testing }
LowtalkTypeUInt32 >> isSigned [
	^ false
]

{ #category : #accessing }
LowtalkTypeUInt32 >> name [
	^ #UInt32
]
