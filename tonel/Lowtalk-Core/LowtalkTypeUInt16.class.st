Class {
	#name : #LowtalkTypeUInt16,
	#superclass : #LowtalkTypeInt16,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkTypeUInt16 >> buildSSAType [
	^ SLVMType ushortType
]

{ #category : #testing }
LowtalkTypeUInt16 >> isSigned [
	^ false
]

{ #category : #accessing }
LowtalkTypeUInt16 >> name [
	^ #UInt16
]
