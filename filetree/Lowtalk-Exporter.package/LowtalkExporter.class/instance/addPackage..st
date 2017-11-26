adding
addPackage: packageName
	| package |
	package := RPackage organizer packageNamed: packageName.
	packages add: package.
	
	self addClasses: package classes.
	self addExtensionMethods: package extensionMethods