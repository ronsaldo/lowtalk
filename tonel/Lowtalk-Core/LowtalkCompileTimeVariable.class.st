Class {
	#name : #LowtalkCompileTimeVariable,
	#superclass : #LowtalkAbstractCompileTimeVariable,
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #accessing }
LowtalkCompileTimeVariable >> resolveValueType [
	^ self rawValue inferLowtalkTypeWith: compiler
]
