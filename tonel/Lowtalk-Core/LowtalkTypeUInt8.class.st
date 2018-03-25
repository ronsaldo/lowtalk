Class {
	#name : #LowtalkTypeUInt8,
	#superclass : #LowtalkTypeInt8,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkTypeUInt8 >> buildSSAType [
	^ SLVMType ucharType 
]

{ #category : #testing }
LowtalkTypeUInt8 >> isSigned [
	^ false
]

{ #category : #accessing }
LowtalkTypeUInt8 >> name [
	^ #UInt8
]
