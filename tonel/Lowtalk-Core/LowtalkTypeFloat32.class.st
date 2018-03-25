Class {
	#name : #LowtalkTypeFloat32,
	#superclass : #LowtalkFloatType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkTypeFloat32 >> alignment [
	^ 4
]

{ #category : #accessing }
LowtalkTypeFloat32 >> buildSSAType [
	^ SLVMType floatType
]

{ #category : #accessing }
LowtalkTypeFloat32 >> name [
	^ #Float32
]

{ #category : #testing }
LowtalkTypeFloat32 >> size [
	^ 4
]

{ #category : #converting }
LowtalkTypeFloat32 >> truncateLiteralValue: value at: aNode [
	^ Float fromIEEE32Bit: (value asIEEE32BitWord)
]
