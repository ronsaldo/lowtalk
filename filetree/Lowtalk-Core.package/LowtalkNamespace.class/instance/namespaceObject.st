compilation
namespaceObject
	namespaceObject ifNotNil: [ ^ namespaceObject ].
	
	self concretizeAllPendingMethods.
	namespaceObject := compiler objectModel namespaceCreationFunction value: name value: symbols values value: methods values.
	self ssaValue initialValue: (compiler translateSSAConstant: namespaceObject type: compiler objectType).
	^ namespaceObject