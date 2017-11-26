accessor generation
createGetterOn: behavior
	| source methodExpression |
	source := ByteString streamContents: [:out |
		out << ':[' << name; lf.
		out tab << ' ^ ' << name; lf.
		out << ']'.
	].

	methodExpression := behavior compiler evaluateString: source.
	methodExpression node returnTypeExpression: (LowtalkASTObjectLiteral new value: type).
	behavior category: 'accessing' methods: { methodExpression }