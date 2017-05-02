accessing
lineColumnAt: aPosition
	| newlineList start end m v bestResult line column el |
	newlineList := self newlines.
	start := 1.
	end := newlineList size + 1.
	bestResult := nil.
	[ start < end ] whileTrue: [ 
		m := start + ((end - start) // 2).
		v := newlineList at: m.
		
		v <= aPosition ifTrue: [
			bestResult := m.
			start := m + 1
		] ifFalse: [ 
			end := m
		]
	].

	self assert: bestResult isNotNil.
	line := bestResult.
	column := 1.
	(newlineList at: line) to: aPosition - 1 do: [ :i |
		el := collection at: i.
		el = Character tab ifTrue: [
			column := ((column + 3) // 4) * 4 + 1
		] ifFalse: [
			column := column + 1
		]
	].

	^ { line . column }