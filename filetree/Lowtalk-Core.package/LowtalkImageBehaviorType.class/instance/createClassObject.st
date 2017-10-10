as yet unclassified
createClassObject
	| superclassType sc instanceSlots layoutClass |
	self assert: classObject isNil.
	superclassType := self superclass.
	
	"Override the super class for the when having native slots."
	sc := superclassType ifNotNil: [ superclassType classObject ].
	(self nativeSlots isNotEmpty and: [sc == self defaultSuperclass ]) ifTrue: [ sc := SLVMInternalStructure ].
	
	layoutClass := self selectLayoutClassWithSuperclass: sc.
	instanceSlots := self convertSlots.
	
	self flag: 'HACK: remove the methods from the class to avoid triggering recompilation with the wrong compiler.'.
	(name isNotNil and: [ Smalltalk globals includesKey: name ]) ifTrue: [ 
		(Smalltalk globals at: name) methodDict removeAll.
		(Smalltalk globals at: name) class methodDict removeAll.
	].
	
	classObject := sc classInstaller make: [ :builder |
		name ifNotNil: [
			builder name: name asSymbol
		].
		builder 
			superclass: sc;
			layoutClass: layoutClass;
			slots: instanceSlots;
			sharedVariables: '';
			sharedPools: '';
			category: self category
	].
