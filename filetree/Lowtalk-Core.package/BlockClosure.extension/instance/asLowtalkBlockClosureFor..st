*Lowtalk-Core
asLowtalkBlockClosureFor: interpreterMethod
	^ LowtalkCompiledMethodBlockClosure new closure: self; definition: interpreterMethod; yourself