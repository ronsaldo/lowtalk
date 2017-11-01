instance creation
basicNewValue
	<compileTime>
	self slots.
	
	^ LowtalkStructureInstance basicNew 
		type: self;
		slots: (self fields collect: [:fieldType | LowtalkStructureInstanceSlotVariable new valueType: fieldType; value: fieldType defaultValue ]);
		yourself