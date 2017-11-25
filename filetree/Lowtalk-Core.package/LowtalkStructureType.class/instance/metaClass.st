accessing
metaClass
	^ compiler isSandboxed ifTrue: [ self sandbox_metaClass ] ifFalse: [ self image_metaClass ]