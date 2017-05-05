accessing
mangledName
	isVisibleInC ifTrue: [ ^ name ].
	^ definitionEnvironment mangledName , name size asString , name