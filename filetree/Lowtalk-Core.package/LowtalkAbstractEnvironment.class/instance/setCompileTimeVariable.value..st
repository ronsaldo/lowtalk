accessing
setCompileTimeVariable: name value: newValue
	self setSymbol: name
		value: (LowtalkCompileTimeVariable new
			name: name;
			value: newValue;
			compiler: self compiler;
			yourself)
		ifPresent: [ self error: 'already present' ].