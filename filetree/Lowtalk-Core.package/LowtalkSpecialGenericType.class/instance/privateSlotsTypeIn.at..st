accessing
privateSlotsTypeIn: environment at: node
	^ (self evaluateInEnvironment: environment at: node) privateSlotsTypeIn: environment at: node