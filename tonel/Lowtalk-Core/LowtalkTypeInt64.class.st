Class {
	#name : #LowtalkTypeInt64,
	#superclass : #LowtalkIntegerType,
	#category : #'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkTypeInt64 >> alignment [
	^ 8
]

{ #category : #accessing }
LowtalkTypeInt64 >> buildSSAType [
	^ SLVMType longType
]

{ #category : #accessing }
LowtalkTypeInt64 >> name [
	^ #Int64
]

{ #category : #testing }
LowtalkTypeInt64 >> size [
	^ 8
]
