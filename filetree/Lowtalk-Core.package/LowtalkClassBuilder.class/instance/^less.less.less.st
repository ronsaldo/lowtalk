building
<<< nameLazyValue
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