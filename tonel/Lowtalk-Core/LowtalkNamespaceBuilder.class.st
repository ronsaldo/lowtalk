Class {
	#name : #LowtalkNamespaceBuilder,
	#superclass : #LowtalkGlobalObjectBuilder,
	#category : #'Lowtalk-Core-FrontEnd'
}

{ #category : #'as yet unclassified' }
LowtalkNamespaceBuilder >> named: nameLazyValue members: membersLazyValue [
	<compileTime>
	<lazy>
	
	| name membersNode baseEnvironment definitionEnvironment namespace localEnvironment isNewNamespace |
	name := nameLazyValue value.
	membersNode := membersLazyValue node.
	baseEnvironment := membersLazyValue environment.
	
	definitionEnvironment := baseEnvironment namespaceEnvironment.
	isNewNamespace := false.
	namespace := definitionEnvironment lookSymbol: name ifAbsentPut: [
		isNewNamespace := true.
		(LowtalkNamespace parent: definitionEnvironment)
			name: name;
			compiler: membersLazyValue compiler
	].

	isNewNamespace ifTrue: [ compiler addPendingObject: namespace ].
	
	"Do not use the namespace environment directly. Bring in the the local scopes that are still present."
	localEnvironment := LowtalkLocalEnvironment parent: (LowtalkEnvironmentWrapper new parent: baseEnvironment; environment: namespace).
	
	LowtalkEvaluator evaluate: membersNode body environment: localEnvironment.
	^ namespace
]
