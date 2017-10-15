accessing
classObject
	<compileTime>
	classObject ifNil: [ self createClassObject ].
	^ classObject