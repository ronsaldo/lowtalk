Class {
	#name : #LowtalkClassBuilder,
	#superclass : #LowtalkGlobalObjectBuilder,
	#category : 'Lowtalk-Core-FrontEnd'
}

{ #category : #building }
LowtalkClassBuilder >> <<< nameLazyValue [
	<compileTime>
	<lazy>
	| class variable baseEnvironment definitionEnvironment |
	class := self anon. 
	
	baseEnvironment := nameLazyValue environment.
	definitionEnvironment := baseEnvironment namespaceEnvironment.
	class environment: definitionEnvironment.

	variable := compiler globalBuilder named: nameLazyValue type: class metaType value: class.
	compiler registerVariable: variable objectInstanceValue: class.
	class name: nameLazyValue value.
	^ class
]

{ #category : #building }
LowtalkClassBuilder >> anon [
	<compileTime>
	| class |
	class := self typeClass target: compiler compilationTarget.
	class
		compiler: compiler.
	compiler addPendingObject: class.
	^ class
]

{ #category : #building }
LowtalkClassBuilder >> typeClass [
	^ compiler isSandboxed ifTrue: [ LowtalkBehaviorType ] ifFalse: [ LowtalkImageBehaviorType ]
]
