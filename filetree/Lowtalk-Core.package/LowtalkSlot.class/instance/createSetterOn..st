accessor generation
createSetterOn: behavior	
	| source methodExpression |
	source := ByteString streamContents: [:out |
		out << ':[' << name << ': newValueFor_' << name; lf.
		out tab << name << ' := newValueFor_' << name; lf.
		out << ']'.
	].

	methodExpression := behavior compiler evaluateString: source.
	methodExpression node arguments first typeExpression: (LowtalkASTObjectLiteral new value: type).
	behavior category: 'accessing' methods: { methodExpression }