Class {
	#name : #LowtalkTypeInt32,
	#superclass : #LowtalkIntegerType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkTypeInt32 >> alignment [
	^ 4
]

{ #category : #accessing }
LowtalkTypeInt32 >> buildSSAType [
	^ SLVMType intType 
]

{ #category : #accessing }
LowtalkTypeInt32 >> name [
	^ #Int32
]

{ #category : #testing }
LowtalkTypeInt32 >> size [
	^ 4
]
