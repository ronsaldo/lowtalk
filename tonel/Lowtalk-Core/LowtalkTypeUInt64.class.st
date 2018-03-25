Class {
	#name : #LowtalkTypeUInt64,
	#superclass : #LowtalkTypeInt64,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkTypeUInt64 >> buildSSAType [
	^ SLVMType ulongType
]

{ #category : #testing }
LowtalkTypeUInt64 >> isSigned [
	^ false
]

{ #category : #accessing }
LowtalkTypeUInt64 >> name [
	^ #UInt64
]
