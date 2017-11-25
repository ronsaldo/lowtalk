accessing
createClassObject
	compiler isSandboxed ifTrue: [ self createSandboxedClassObject ] ifFalse: [ self createInImageClassObject ]