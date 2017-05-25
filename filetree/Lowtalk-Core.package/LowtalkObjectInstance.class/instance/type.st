accessing
type
	| behavior |
	behavior := self behavior.
	(compiler objectModel isRegisteredClass: behavior) ifFalse: [ 
		self error: 'Using object without a class.'
	].

	^ (LowtalkClassType target: compiler compilationTarget) classObject: behavior