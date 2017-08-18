*Lowtalk-Core
asLowtalkBlockClosureFor: interpreterMethod
	FileStream stdout nextPutAll: 'Closure for: '; print: interpreterMethod selector; lf.
	^ LowtalkCompiledMethodBlockClosure new closure: self; definition: interpreterMethod; yourself