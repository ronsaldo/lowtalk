building
typeClass
	^ compiler isSandboxed ifTrue: [ LowtalkBehaviorType ] ifFalse: [ LowtalkImageBehaviorType ]