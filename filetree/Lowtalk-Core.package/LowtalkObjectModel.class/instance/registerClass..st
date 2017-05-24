class creation
registerClass: aClassObject
	<compileTime>
	| description |
	description := LowtalkClassDescription new
		compiler: compiler;
		classObject: aClassObject;
		yourself.
		
	classes at: aClassObject put: description.
	^ description