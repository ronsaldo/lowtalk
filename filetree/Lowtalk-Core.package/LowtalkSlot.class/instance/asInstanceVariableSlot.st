converting
asInstanceVariableSlot
	| result |
	result := InstanceVariableSlot named: self name.
	properties ifNotNil: [
		properties keysAndValuesDo: [ :key :value |
			result propertyAt: key put: value
		]
	].

	^ result