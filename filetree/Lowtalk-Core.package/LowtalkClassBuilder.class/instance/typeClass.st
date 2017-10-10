building
typeClass
	^ compiler isSandboxed ifTrue: [ LowtalkClassType ] ifFalse: [ LowtalkImageBehaviorType ]