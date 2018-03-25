Class {
	#name : #LowtalkTypeFloat16,
	#superclass : #LowtalkFloatType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkTypeFloat16 >> alignment [
	^ 2
]

{ #category : #accessing }
LowtalkTypeFloat16 >> name [
	^ #Float16
]

{ #category : #testing }
LowtalkTypeFloat16 >> size [
	^ 2
]
