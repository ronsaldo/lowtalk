accessing
defaultValue
	baseType isIntegerType ifTrue: [ 
		baseType size = 1 ifTrue: [ ^ LowtalkArrayInstance new type: self; slots: (ByteArray new: elements) ].
	].

	^ LowtalkArrayInstance new
		type: self;
		slots: ((1 to: elements) collect: [ :index | baseType defaultValue ]);
		yourself