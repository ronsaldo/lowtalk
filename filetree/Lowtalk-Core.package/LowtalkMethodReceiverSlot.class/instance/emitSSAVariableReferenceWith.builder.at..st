code generation
emitSSAVariableReferenceWith: codeGenerator builder: builder at: node
	^ builder getReference: codeGenerator selfValue element: (SLVMConstantValue int: description index)