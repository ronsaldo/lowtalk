trampoline names
messageSuperSendTrampoline
	^ messageSuperSendTrampoline ifNil: [ 
		messageSuperSendTrampoline := compiler ssaValueForObject: compiler objectModel superSendTrampolineFunction
	]