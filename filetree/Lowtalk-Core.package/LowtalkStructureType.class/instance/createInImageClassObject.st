structure class
createInImageClassObject
	| layoutClass instanceSlots superClassObject |
	layoutClass := self inImageStructureLayoutClass.
	self slots.
	instanceSlots := allSlots collect: [:slot | (SLVMStructureFieldSlot named: slot name) type: slot type ssaType].
	
	self flag: 'HACK: remove the methods from the class to avoid triggering recompilation with the wrong compiler.'.
	(name isNotNil and: [ Smalltalk globals includesKey: name ]) ifTrue: [ 
		(Smalltalk globals at: name) methodDict removeAll.
		(Smalltalk globals at: name) class methodDict removeAll.
	].

	superClassObject := SLVMInternalStructure.
	classObject := superClassObject classInstaller make: [ :builder |
		name ifNotNil: [
			builder name: name asSymbol
		].
		builder 
			superclass: superClassObject;
			layoutClass: layoutClass;
			slots: instanceSlots;
			sharedVariables: '';
			sharedPools: '';
			category: self category
	].
	
	compiler importImageClassType: classObject importedValue: self.
	self createPublicAccessors