accessing
binding
	compiler isSandboxed ifTrue: [
		self halt
	] ifFalse: [
		^ self classObject binding
	]