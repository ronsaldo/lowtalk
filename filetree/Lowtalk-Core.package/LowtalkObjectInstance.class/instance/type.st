accessing
type
	| behavior |
	behavior := self behavior.
	(compiler objectModel isRegisteredClass: behavior) ifFalse: [ 
		self error: 'Using object without a class.'
	].
	^ compiler classTypeForObject: behavior