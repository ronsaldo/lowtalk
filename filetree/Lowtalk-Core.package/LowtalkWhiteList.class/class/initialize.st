initialization
initialize
	SelectorsAlwaysAllowed := Set newFrom: #(
		yourself
		
		"Comparisons"
		= ==
		~= ~~
		hash
		identityHash
		
		"Arithmetic"
		+ - * / % * // \\ sqrt
		< <= > >=
		negated
		
		bitAnd: bitOr: bitXor:
		bitInvert bitInvert32
		
		or: and:
		
		"Collection accessors"
		basicSize size
		basicAt: at:
		basicAt:put: at:put:
		
		at:ifAbsent:
		at:ifAbsentPut:
		at:ifPresent:
		at:ifPresent:ifAbsent:
		at:ifPresent:ifAbsentPut:
		
		"Collection iteration"
		do:
		to:by:
		to:by:do:
		to:do:
		
		"Sequences operations"
		,
	).

	AddedMethods := Dictionary newFromPairs: #(
		#castTo: #castTo:receiver:arguments:inSuperclass:node:
	).
	
	OverridenMethods := Dictionary newFromPairs: { 
		Symbol >> #=> . #createSlotNamedOverrideSelector:receiver:arguments:inSuperclass:node:
	}.
	