trampoline names
messageSendTrampoline
	^ messageSendTrampoline ifNil: [ 
		messageSendTrampoline := compiler ssaValueForObject: compiler objectModel sendTrampolineFunction
	]