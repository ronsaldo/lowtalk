compiling
convertParseFailure: aFailure collection: collection
	| position |
	aFailure isPetitFailure ifFalse: [ ^ self ].
	position := LowtalkASTPosition new collection: collection; start: aFailure position; stop: aFailure position.
	self error: position asString , ': ' , aFailure message.