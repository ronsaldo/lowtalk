accessing
name
	classObject ifNotNil: [ 
		^ self getClassDescription name.
	].
	
	^ super name