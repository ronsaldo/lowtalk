public access
evaluateValue: aNode
	| result |
	result := self evaluate: aNode.
	^ self removeReferencesOfValue: result type: aNode type.