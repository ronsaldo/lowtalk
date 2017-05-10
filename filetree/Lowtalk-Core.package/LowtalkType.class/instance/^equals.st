comparing
= other
	^ (self class == other class) and: [ readOnly = other readOnly ]