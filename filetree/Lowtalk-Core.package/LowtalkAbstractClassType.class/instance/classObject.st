accessing
classObject
	classObject ifNil: [ self createClassObject ].
	^ classObject