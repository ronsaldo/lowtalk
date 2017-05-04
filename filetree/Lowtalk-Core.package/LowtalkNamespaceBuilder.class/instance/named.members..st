as yet unclassified
named: nameLazyValue members: membersLazyValue
	<compileTime>
	<lazy>
	
	| name membersNode baseEnvironment definitionEnvironment namespace localEnvironment |
	name := nameLazyValue value.
	membersNode := membersLazyValue node.
	baseEnvironment := membersLazyValue environment.
	
	definitionEnvironment := baseEnvironment namespaceEnvironment.
	namespace := definitionEnvironment lookSymbol: name ifAbsentPut: [ LowtalkNamespace parent: definitionEnvironment ].
	
	"Do not use the namespace environment directly. Bring in the the local scopes that are still present."
	localEnvironment := LowtalkLocalEnvironment parent: (LowtalkEnvironmentWrapper new parent: baseEnvironment; environment: namespace).
	
	LowtalkEvaluator evaluate: membersNode body environment: localEnvironment.
	^ namespace