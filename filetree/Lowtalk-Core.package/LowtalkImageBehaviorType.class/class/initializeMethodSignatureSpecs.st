initialization
initializeMethodSignatureSpecs
	MethodSignatureSpecs := IdentityDictionary newFromPairs: { 
		ProtoObject >> #class . '(ProtoObject) -> _SelfClassType'.
		Object >> #yourself . '(Object) -> _SelfType'.
		Behavior >> #basicNew . '(Behavior) -> _SelfInstanceType'.
		Behavior >> #basicNew: . '(Behavior , _DynamicObject) -> _SelfInstanceType'.
		Behavior >> #new . '(Behavior) -> _SelfInstanceType'.
		Behavior >> #new: . '(Behavior , _DynamicObject) -> _SelfInstanceType'.
	}