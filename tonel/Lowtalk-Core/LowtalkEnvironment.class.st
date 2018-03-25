Class {
	#name : #LowtalkEnvironment,
	#superclass : #LowtalkAbstractEnvironment,
	#instVars : [
		'symbols'
	],
	#category : 'Lowtalk-Core-Environment'
}

{ #category : #'gt-inspector-extension' }
LowtalkEnvironment >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 0>
	^ symbols gtInspectorItemsIn: composite
]

{ #category : #initialization }
LowtalkEnvironment >> initialize [
	super initialize.
	symbols := Dictionary new.
	
]

{ #category : #initialization }
LowtalkEnvironment >> lookSymbol: symbol [
	^ symbols at: symbol
]

{ #category : #initialization }
LowtalkEnvironment >> lookSymbol: symbol ifAbsent: aBlock [
	^ symbols at: symbol ifAbsent: aBlock
]

{ #category : #initialization }
LowtalkEnvironment >> lookSymbol: symbol ifAbsentPut: aBlock [
	^ symbols at: symbol ifAbsentPut: aBlock
]

{ #category : #initialization }
LowtalkEnvironment >> lookSymbol: symbol ifPresent: aBlock [
	^ symbols at: symbol ifPresent: aBlock
]

{ #category : #accessing }
LowtalkEnvironment >> namespaceEnvironment [
	^ parent namespaceEnvironment
]

{ #category : #initialization }
LowtalkEnvironment >> setSymbol: aSymbol value: aValue [
	symbols at: aSymbol put: aValue
]

{ #category : #initialization }
LowtalkEnvironment >> setSymbol: aSymbol value: aValue ifPresent: aBlock [
	symbols at: aSymbol ifPresent: aBlock ifAbsentPut: [ aValue ]
]
