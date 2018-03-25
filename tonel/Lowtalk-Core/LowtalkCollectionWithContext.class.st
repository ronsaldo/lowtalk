Class {
	#name : #LowtalkCollectionWithContext,
	#superclass : #Object,
	#instVars : [
		'collection',
		'name',
		'newlines'
	],
	#category : 'Lowtalk-Core-Parser'
}

{ #category : #converting }
LowtalkCollectionWithContext >> asLowtalkCollectionWithContext [
	^ self
]

{ #category : #converting }
LowtalkCollectionWithContext >> asPetitStream [
	^ PPStream on: self
]

{ #category : #converting }
LowtalkCollectionWithContext >> at: index [
	^ collection at: index
]

{ #category : #accessing }
LowtalkCollectionWithContext >> collection [
	^ collection
]

{ #category : #accessing }
LowtalkCollectionWithContext >> collection: anObject [
	collection := anObject
]

{ #category : #converting }
LowtalkCollectionWithContext >> copyFrom: start to: stop [
	^ collection copyFrom: start to: stop
]

{ #category : #initialization }
LowtalkCollectionWithContext >> initialize [
	super initialize.
	name := 'unnamed'
]

{ #category : #accessing }
LowtalkCollectionWithContext >> lineColumnAt: aPosition [
	| newlineList start end m v bestResult line column el |
	newlineList := self newlines.
	start := 1.
	end := newlineList size + 1.
	bestResult := nil.
	[ start < end ] whileTrue: [ 
		m := start + ((end - start) // 2).
		v := newlineList at: m.
		
		v <= aPosition ifTrue: [
			bestResult := m.
			start := m + 1
		] ifFalse: [ 
			end := m
		]
	].

	self assert: bestResult isNotNil.
	line := bestResult.
	column := 1.
	(newlineList at: line) to: aPosition - 1 do: [ :i |
		el := collection at: i.
		el = Character tab ifTrue: [
			column := ((column + 3) // 4) * 4 + 1
		] ifFalse: [
			column := column + 1
		]
	].

	^ { line . column }
]

{ #category : #accessing }
LowtalkCollectionWithContext >> name [
	^ name
]

{ #category : #accessing }
LowtalkCollectionWithContext >> name: anObject [
	name := anObject
]

{ #category : #accessing }
LowtalkCollectionWithContext >> newlines [
	| index size el |
	newlines ifNotNil: [ ^ newlines ].
	^ newlines := Array streamContents: [ :out |
		index := 1.
		out nextPut: index. "Line 1"
		
		size := collection size.
		[ index <= size ] whileTrue: [ 
			el := collection at: index.
			el = Character cr ifTrue: [ 
				index := index + 1.
				index <= size ifTrue: [
					el := collection at: index.
					el = Character lf ifTrue: [ 
						index := index + 1.
					].
				].
				out nextPut: index.
			] ifFalse: [
				el = Character lf ifTrue: [ 
					index := index + 1.
					out nextPut: index.
				] ifFalse: [ 
					index := index + 1.
				]
			]
		]
	]
]

{ #category : #converting }
LowtalkCollectionWithContext >> size [
	^ collection size
]
