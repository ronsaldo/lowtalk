instance creation
basicNew
	<compileTime>
	self slots.
	
	^ LowtalkStructureInstance basicNew 
		type: self;
		slots: (self fields collect: [:fieldType | LowtalkInstanceSlotVariable new valueType: fieldType; value: fieldType defaultValue ]);
		yourself