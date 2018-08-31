Class {
	#name : #LowtalkStructureBuilder,
	#superclass : #LowtalkGlobalObjectBuilder,
	#category : #'Lowtalk-Core-FrontEnd'
}

{ #category : #building }
LowtalkStructureBuilder >> <<< nameLazyValue [
	<compileTime>
	<lazy>
	| structure |
	structure := self anon. 
	compiler globalBuilder named: nameLazyValue type: structure metaType value: structure.
	structure name: nameLazyValue value.
	^ structure
]

{ #category : #building }
LowtalkStructureBuilder >> anon [
	<compileTime>
	| structure |
	structure := self typeClass target: compiler compilationTarget.
	structure
		compiler: compiler.
	compiler addPendingObject: structure.
	^ structure
]

{ #category : #building }
LowtalkStructureBuilder >> typeClass [
	^ LowtalkStructureType
]
