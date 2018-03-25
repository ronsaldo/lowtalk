Class {
	#name : #LowtalkTypeFloat64,
	#superclass : #LowtalkFloatType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #testing }
LowtalkTypeFloat64 >> alignment [
	^ self ssaType alignment
]

{ #category : #accessing }
LowtalkTypeFloat64 >> buildSSAType [
	^ compilationTarget double
]

{ #category : #accessing }
LowtalkTypeFloat64 >> name [
	^ #Float64
]

{ #category : #testing }
LowtalkTypeFloat64 >> size [
	^ 8
]
