Class {
	#name : #LowtalkCommandLineHandler,
	#superclass : #CommandLineHandler,
	#category : 'Lowtalk-Core-FrontEnd'
}

{ #category : #accessing }
LowtalkCommandLineHandler class >> commandName [
	^ 'lowtalk'
]

{ #category : #accessing }
LowtalkCommandLineHandler class >> description [
	^ 'Invokes the Lowtalk compiler'
]

{ #category : #activation }
LowtalkCommandLineHandler >> activate [
	| architecture arguments argumentIndex arg withDebugInformation compilationCommands skipCount outputFileName writeObject target compiler optimizationLevel |
	self activateHelp
		ifTrue: [  ^ self ].
		
	architecture := #x86.
	outputFileName := 'a.o'.
	withDebugInformation := false.
	writeObject := false.
	optimizationLevel := 0.
	
	arguments := self arguments.
	argumentIndex := 1.
	
	compilationCommands := OrderedCollection new.
	
	[argumentIndex <= arguments size] whileTrue: [
		arg := arguments at: argumentIndex.
		skipCount := 1.
		
		arg = '-m32' ifTrue: [ 
			architecture := #x86.
		].
		arg = '-m64' ifTrue: [  
			architecture := #x86.
		].
		arg = '-g' ifTrue: [  
			withDebugInformation := true.
		].
		arg = '-c' ifTrue: [ 
			writeObject := true
		].
		arg = '-O0' ifTrue: [ 
			optimizationLevel := 0
		].
		arg = '-O1' ifTrue: [ 
			optimizationLevel := 1
		].
		arg = '-O2' ifTrue: [ 
			optimizationLevel := 2
		].

		arg = '-o' ifTrue: [
			argumentIndex + 1 > arguments size ifTrue: [ self error: 'Expected an argument after -o' ].
			outputFileName := arguments at: argumentIndex + 1.
			skipCount := 2
		].
	
		arg = '-eval' ifTrue: [
			| evalSource |
			argumentIndex + 1 > arguments size ifTrue: [ self error: 'Expected an argument after -eval' ].
			evalSource := arguments at: argumentIndex + 1.
			evalSource = '-' ifTrue: [
				self flag: 'TODO: Implement this case'
			] ifFalse: [
				compilationCommands add: [ :comp | comp evaluateString: evalSource ].
			].
			skipCount := 2
		].
	
		(arg beginsWith: '-') ifFalse: [
			|fileName|
			fileName := arg.
			compilationCommands add: [ :comp | comp evaluateFileNamed: fileName ].
		].

		argumentIndex := argumentIndex + skipCount
	].

	target := SLVMSAsmCompilationTarget perform: architecture.
	withDebugInformation ifTrue: [
		target withDebugInformation
	].

	compiler := LowtalkCompiler compilationTarget: target.
	compiler optimizationLevel: optimizationLevel.
	[
		compilationCommands do: [ :cmd | cmd cull: compiler ].
	] on: LTCError do: [ :err |
		stderr nextPutAll: err description; lf.
		^ Exit new status: 1; signal
	].
	
	(writeObject and: [ outputFileName isNotNil ]) ifTrue: [
		compiler writeObjectToFileNamed: outputFileName
	].

	self exitSuccess.
]
