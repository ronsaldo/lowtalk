writing
writeToDirectory: aDirectoryName
	| directory |
	directory := aDirectoryName asFileReference.
	directory exists ifFalse: [ directory createDirectory ].
	self sortClasses.
	classes do: [ :cls |
		directory / (cls name , '.ltk') writeStreamDo: [ :o | 
			o truncate.
			out := o.
			self writeClass: cls.
			self writeClassMethods: cls
		]
	].

	extensionMethods ifNotEmpty: [ 
		directory / 'extensions.ltk' writeStreamDo: [ :o | 
			o truncate.
			out := o.
			self writeExtensionMethods.
		]
	].

	directory / 'package.ltk' writeStreamDo: [ :o |
		o truncate.
		out := o.
		
		out << 'Compiler'; lf.
		packages do: [ :pkg |
			out tab << 'declarePackage: ' << pkg name printString << ';'; lf
		].
	
		classes do: [ :cls |
			out tab << 'evaluateFileNamed: ' << (cls name , '.ltk') asString printString << ';'; lf
		].
		extensionMethods ifNotEmpty: [
			out tab << 'evaluateFileNamed: ''extensions.ltk'';'; lf
		].

		out tab << 'yourself.'; lf.
	].
