initialization
initialize
	SelectorsAlwaysAllowed := Set newFrom: #(
		yourself
		
		"Comparisons"
		= ==
		~= ~~
		hash
		identityHash
		
		"Copy"
		copy
		copyWith:
		
		"Arithmetic"
		+ - * / % * // \\ sqrt
		< <= > >=
		negated
		
		bitAnd: bitOr: bitXor:
		bitInvert bitInvert32
		bitShift
		<< >> | &
		
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
		#basicAtOffset: #basicAtOffset:receiver:arguments:inSuperclass:node:compiler:
		#basicAtOffset:put: #basicAtOffsetPut:receiver:arguments:inSuperclass:node:compiler:
		#atOffset: #atOffset:receiver:arguments:inSuperclass:node:compiler:
		#atOffset:put: #atOffsetPut:receiver:arguments:inSuperclass:node:compiler:

		#castTo: #castTo:receiver:arguments:inSuperclass:node:compiler:
		#identityHash #identityHash:receiver:arguments:inSuperclass:node:compiler:
	).
	
	OverridenMethods := Dictionary newFromPairs: { 
		Symbol >> #=> . #createSlotNamedOverrideSelector:receiver:arguments:inSuperclass:node:compiler:
	}.
	