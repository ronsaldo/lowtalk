slots
fillSlotDictionary
	slotsList do: [ :slot |
		slots at: slot name ifPresent: [ 
			slot node semanticError: 'Class {1} slot name {1} is already in use.'
				format: { self validName . slot name printString }
		] ifAbsentPut: [ slot ].
	].