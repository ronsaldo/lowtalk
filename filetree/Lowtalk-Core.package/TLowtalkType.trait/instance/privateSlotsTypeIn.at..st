accessing
privateSlotsTypeIn: environment at: node
	node semanticError: 'Cannot access private slots of object of type {1}.' format: { self name }
	