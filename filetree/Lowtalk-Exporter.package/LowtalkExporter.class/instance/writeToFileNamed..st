writing
writeToFileNamed: aFileName
	aFileName asFileReference writeStreamDo: [ :o |
		o truncate.
		out := o.
		
		out << 'Compiler'; lf.
		packages do: [ :pkg |
			out tab << 'declarePackage: ' << pkg name printString << ';'; lf
		].
		
		out tab << 'yourself.'; lf.
		
		self
			writeClasses;
			writeMethods;
			writeExtensionMethods
	]