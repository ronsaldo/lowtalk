as yet unclassified
zipValues: values types: types node: node
	| result |
	self assert: values size = types size.
	result := Array new: values size.
	1 to: values size do: [ :i |
		result at: i put: (self value: (values at: i) type: (types at: i) node: node)
	].
	^ result