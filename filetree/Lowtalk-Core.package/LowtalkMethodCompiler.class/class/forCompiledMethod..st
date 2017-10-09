as yet unclassified
forCompiledMethod: aCompiledMethod
	^ self new
		environment: aCompiledMethod methodClass environment;
		class: aCompiledMethod methodClass;
		yourself