Class {
	#name : #LowtalkGlobalBuilder,
	#superclass : #LowtalkGlobalObjectBuilder,
	#category : #'Lowtalk-Core-FrontEnd'
}

{ #category : #'as yet unclassified' }
LowtalkGlobalBuilder >> external: nameLazyValue C: cNameLazyValue type: typeLazyValue [
	<compileTime>
	<lazy>
	
	| result |
	result := self external: nameLazyValue symbol: cNameLazyValue type: typeLazyValue.
	result isVisibleInC: true.
	^ result
]

{ #category : #'as yet unclassified' }
LowtalkGlobalBuilder >> external: nameLazyValue symbol: symbolLazyValue type: typeLazyValue [
	<compileTime>
	<lazy>
	
	| result |
	result := self named: nameLazyValue symbol: symbolLazyValue type: typeLazyValue value: nil.
	result isExternal: true.
	^ result
]

{ #category : #'as yet unclassified' }
LowtalkGlobalBuilder >> external: nameLazyValue type: typeLazyValue [
	<compileTime>
	<lazy>
	
	| result |
	result := self named: nameLazyValue type: typeLazyValue value: nil.
	result isExternal: true.
	^ result
]

{ #category : #'as yet unclassified' }
LowtalkGlobalBuilder >> externalC: nameLazyValue type: typeLazyValue [
	<compileTime>
	<lazy>
	
	^ self external: nameLazyValue C: nameLazyValue type: typeLazyValue
]

{ #category : #'as yet unclassified' }
LowtalkGlobalBuilder >> named: nameLazyValue symbol: symbolLazyValue type: typeLazyValue value: lazyValue [
	<compileTime>
	<lazy>
	
	| baseEnvironment definitionEnvironment name global |
	name := nameLazyValue value.
	
	baseEnvironment := nameLazyValue environment.
	definitionEnvironment := baseEnvironment namespaceEnvironment.
	
	global := LowtalkGlobalVariable new
		name: symbolLazyValue value;
		definitionEnvironment: definitionEnvironment;
		compiler: definitionEnvironment compiler;
		typeExpression: typeLazyValue;
		valueExpression: lazyValue.
	definitionEnvironment setSymbol: name value: global ifPresent: [ 
		nameLazyValue node semanticError: 'Symbol {1} is already used.' format: { name printString }
	].

	compiler addPendingObject: global.
	^ global
]

{ #category : #'as yet unclassified' }
LowtalkGlobalBuilder >> named: nameLazyValue type: typeLazyValue [
	<compileTime>
	<lazy>
	
	^ self named: nameLazyValue type: typeLazyValue value: [typeLazyValue value defaultValue]
]

{ #category : #'as yet unclassified' }
LowtalkGlobalBuilder >> named: nameLazyValue type: typeLazyValue value: lazyValue [
	<compileTime>
	<lazy>
	
	^ self named: nameLazyValue symbol: nameLazyValue type: typeLazyValue value: lazyValue
]

{ #category : #'as yet unclassified' }
LowtalkGlobalBuilder >> named: nameLazyValue value: lazyValue [
	<compileTime>
	<lazy>
		
	^ self named: nameLazyValue type: lazyValue inferValueType value: lazyValue
]

{ #category : #'as yet unclassified' }
LowtalkGlobalBuilder >> namedC: nameLazyValue value: lazyValue [
	<compileTime>
	<lazy>
	^ (self named: nameLazyValue type: lazyValue inferValueType value: lazyValue)
		isVisibleInC: true;
		yourself

]
