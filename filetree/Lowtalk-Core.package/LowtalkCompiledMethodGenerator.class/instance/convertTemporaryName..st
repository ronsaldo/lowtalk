as yet unclassified
convertTemporaryName: temporaryName
	| result |
	result := temporaryName.
	[usedNames includes: result] whileTrue: [
		result := result , usedNameCount asString.
		usedNameCount := usedNameCount + 1.
	].
	result := result asSymbol.
	usedNames add: result.
	^ result