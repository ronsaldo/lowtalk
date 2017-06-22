comparing
= other
	^ self class == other class and:
		[ collection  == other collection and:
		[ start = other start and:
		[ stop = other stop ] ] ]