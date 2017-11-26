writing
writeClass: class
	out << 'Class <<< '; print: class name; lf.
	out tab << 'superclass: ' << class superclass name << ';'; lf.
	out tab << 'package: ' << class category printString << ';'; lf.
	
	out tab << 'slots: {'; lf.
	class slots do: [ :slot |
		out tab; tab; nextPutAll: slot definitionString; nextPutAll: '.'; lf
	].
	out tab << '};'; lf.
	
	class class slots ifNotEmpty: [ 
		out tab << 'classSlots: {'; lf.
		class class slots do: [ :slot |
			out tab; tab; nextPutAll: slot definitionString; nextPutAll: '.'; lf
		].
		out tab << '};'; lf.
	].
	
	class classVariables ifNotEmpty: [
		out tab << 'classVariables: {'; lf.
		class classVariables do: [ :slot |
			out tab; tab; nextPutAll: slot definitionString; nextPutAll: '.'; lf
		].
		out tab << '};'; lf.	
	].
	out tab << 'yourself. '; lf.
	out lf.
