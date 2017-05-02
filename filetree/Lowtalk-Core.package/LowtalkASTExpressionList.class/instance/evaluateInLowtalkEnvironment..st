as yet unclassified
evaluateInLowtalkEnvironment: anEnvironment
	| result |
	result := nil.
	expressions do: [ :expr |
		result := expr evaluateInLowtalkEnvironment: anEnvironment
	].
	^ result