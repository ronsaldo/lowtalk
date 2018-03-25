Class {
	#name : #LowtalkCompileTimeArgumentLocalVariable,
	#superclass : #LowtalkCompileTimeLocalVariable,
	#category : 'Lowtalk-Core-Environment'
}

{ #category : #accessing }
LowtalkCompileTimeArgumentLocalVariable >> valueType: aValueType [
	valueType := aValueType.
	type := aValueType
]
