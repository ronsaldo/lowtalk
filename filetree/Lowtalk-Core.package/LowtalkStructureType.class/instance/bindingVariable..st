accessing
bindingVariable: aVariable
	bindingVariable := aVariable.
	(compiler isSandboxed not and: [ classObject isNotNil ]) ifTrue: [ 
		bindingVariable ssaBindingValue: classObject binding
	]