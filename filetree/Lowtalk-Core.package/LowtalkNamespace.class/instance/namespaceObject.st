compilation
namespaceObject
	namespaceObject ifNotNil: [ ^ namespaceObject ].
	
	self concretizeAllPendingMethods.
	compiler objectModel namespaceCreationFunction ifNil: [ ^ nil ].
	
	namespaceObject := compiler objectModel namespaceCreationFunction value: name value: symbols values value: methodDict values.
	self ssaValue initialValue: (compiler translateSSAConstant: namespaceObject type: compiler objectType).
	^ namespaceObject