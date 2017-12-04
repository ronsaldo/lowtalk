converting
asSLVMStructureFieldSlot
	| result |
	result := SLVMStructureFieldSlot named: self name.
	result type: self type ssaType.
	properties ifNotNil: [
		properties keysAndValuesDo: [ :key :value |
			result propertyAt: key put: value
		]
	].

	^ result