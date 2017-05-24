accessing
instanceVariables: anArrayOfInstanceVariables
	<compileTime>
	slots := anArrayOfInstanceVariables collect: [ :name | LowtalkSlot new name: name; type: compiler objectType ]