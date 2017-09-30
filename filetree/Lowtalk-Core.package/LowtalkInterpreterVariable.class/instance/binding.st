accessing
binding
	^ binding ifNil: [ binding := LiteralVariable key: (self name ifNil: #anon) ]