accessing
instanceVariables: anArrayOfInstanceVariables
	<compileTime>
	
	slots := anArrayOfInstanceVariables collectWithIndex: [ :name :index|
		LowtalkSlot new
			name: name;
			type: compiler objectType;
			yourself
	]