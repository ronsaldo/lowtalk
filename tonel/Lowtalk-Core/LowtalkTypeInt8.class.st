Class {
	#name : #LowtalkTypeInt8,
	#superclass : #LowtalkIntegerType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkTypeInt8 >> alignment [
	^ 1
]

{ #category : #accessing }
LowtalkTypeInt8 >> buildSSAType [
	^ SLVMType charType 
]

{ #category : #accessing }
LowtalkTypeInt8 >> name [
	^ #Int8
]

{ #category : #testing }
LowtalkTypeInt8 >> size [
	^ 1
]
