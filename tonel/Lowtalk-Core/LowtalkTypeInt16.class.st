Class {
	#name : #LowtalkTypeInt16,
	#superclass : #LowtalkIntegerType,
	#category : #'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkTypeInt16 >> alignment [
	^ 2
]

{ #category : #accessing }
LowtalkTypeInt16 >> buildSSAType [
	^ SLVMType shortType
]

{ #category : #accessing }
LowtalkTypeInt16 >> name [
	^ #Int16
]

{ #category : #testing }
LowtalkTypeInt16 >> size [
	^ 2
]
