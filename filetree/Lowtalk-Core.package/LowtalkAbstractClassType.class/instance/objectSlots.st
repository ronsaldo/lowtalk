accessing
objectSlots
	objectSlots ifNil: [ self buildSlots ].
	^ objectSlots