code generation
emitSSAVariableLoadWith: codeGenerator builder: builder at: node
	^ builder load: (self emitSSAVariableReferenceWith: codeGenerator builder: builder at: node)