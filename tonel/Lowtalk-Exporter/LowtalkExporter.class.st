"
I am an exporter from Pharo into Lowtalk.
"
Class {
	#name : #LowtalkExporter,
	#superclass : #Object,
	#instVars : [
		'packages',
		'classes',
		'extensionMethods',
		'out'
	],
	#category : 'Lowtalk-Exporter'
}

{ #category : #'as yet unclassified' }
LowtalkExporter class >> package: packageName toDirectory: fileName [
	^ self new package: packageName toDirectory: fileName
]

{ #category : #'as yet unclassified' }
LowtalkExporter class >> package: packageName toFileNamed: fileName [
	^ self new package: packageName toFileNamed: fileName
]

{ #category : #adding }
LowtalkExporter >> addClasses: aCollectionOfClasses [
	classes addAll: aCollectionOfClasses
]

{ #category : #adding }
LowtalkExporter >> addExtensionMethods: aCollectionOfExtensionMethods [
	extensionMethods addAll: aCollectionOfExtensionMethods
]

{ #category : #adding }
LowtalkExporter >> addPackage: packageName [
	| package |
	package := RPackage organizer packageNamed: packageName.
	packages add: package.
	
	self addClasses: package classes.
	self addExtensionMethods: package extensionMethods
]

{ #category : #initialization }
LowtalkExporter >> initialize [
	packages := OrderedCollection new.
	classes := OrderedCollection new.
	extensionMethods := OrderedCollection new.
	
]

{ #category : #'as yet unclassified' }
LowtalkExporter >> package: packageName toDirectory: fileName [
	self addPackage: packageName.
	self writeToDirectory: fileName
]

{ #category : #'as yet unclassified' }
LowtalkExporter >> package: packageName toFileNamed: fileName [
	self addPackage: packageName.
	self writeToFileNamed: fileName
]

{ #category : #writing }
LowtalkExporter >> sortClass: class visited: visitedSet available: availableSet sorted: sorted [
	(visitedSet includes: class) ifTrue: [ ^ self ].
	visitedSet add: class.
	
	(availableSet includes: class superclass) ifTrue: [ 
		self sortClass: class superclass visited: visitedSet available: availableSet sorted: sorted
	].
 
	sorted add: class
]

{ #category : #writing }
LowtalkExporter >> sortClasses [
	| visitedSet availableSet sorted |
	visitedSet := IdentitySet new.
	availableSet := IdentitySet newFrom: classes.
	sorted := OrderedCollection new.
	classes sort: [ :a :b | a name < b name ].
	classes do: [ :cls | self sortClass: cls visited: visitedSet available: availableSet sorted: sorted ].
	classes := sorted
]

{ #category : #writing }
LowtalkExporter >> writeBehaviorMethods: behavior [
	| organization protocol |
	organization := behavior organization.
	organization categoriesSorted reject: [ :cat | (cat beginsWith: '+') or: [cat = '-- all --']] thenDo: [ :cat |
		protocol := organization protocolNamed: cat.
		protocol methods ifNotEmpty: [
			out << behavior name << ' category: ' << cat printString << ' methods: {'; lf.
			protocol methods asArray sorted doWithIndex: [:selector :index |
				index > 1 ifTrue: [ out lf ].
				self writeMethod: (behavior methodDict at: selector)
			].
			out << '}.';lf; lf
		].
	]
]

{ #category : #writing }
LowtalkExporter >> writeClass: class [
	out << 'Class <<< '; print: class name; lf.
	out tab << 'superclass: ' << class superclass name << ';'; lf.
	out tab << 'package: ' << class category printString << ';'; lf.
	
	out tab << 'slots: {'; lf.
	class slots do: [ :slot |
		out tab; tab; nextPutAll: slot definitionString; nextPutAll: '.'; lf
	].
	out tab << '};'; lf.
	
	class class slots ifNotEmpty: [ 
		out tab << 'classSlots: {'; lf.
		class class slots do: [ :slot |
			out tab; tab; nextPutAll: slot definitionString; nextPutAll: '.'; lf
		].
		out tab << '};'; lf.
	].
	
	class classVariables ifNotEmpty: [
		out tab << 'classVariables: {'; lf.
		class classVariables do: [ :slot |
			out tab; tab; nextPutAll: slot definitionString; nextPutAll: '.'; lf
		].
		out tab << '};'; lf.	
	].
	out tab << 'yourself. '; lf.
	out lf.

]

{ #category : #writing }
LowtalkExporter >> writeClassMethods: class [
	self writeBehaviorMethods: class class;
		writeBehaviorMethods: class

]

{ #category : #writing }
LowtalkExporter >> writeClasses [
	self sortClasses.
	classes do: [ :cls | self writeClass: cls ]
]

{ #category : #writing }
LowtalkExporter >> writeExtensionMethods [
	extensionMethods ifEmpty: [ ^ self ].
	self halt
]

{ #category : #writing }
LowtalkExporter >> writeMethod: aCompiledMethod [
	out nextPutAll: ':['; nextPutAll: aCompiledMethod sourceCode withUnixLineEndings; lf.
	out nextPutAll: '].'; lf
]

{ #category : #writing }
LowtalkExporter >> writeMethods [
	classes do: [ :cls | self writeClassMethods: cls ]
]

{ #category : #writing }
LowtalkExporter >> writeToDirectory: aDirectoryName [
	| directory |
	directory := aDirectoryName asFileReference.
	directory exists ifFalse: [ directory createDirectory ].
	self sortClasses.
	classes do: [ :cls |
		directory / (cls name , '.ltk') writeStreamDo: [ :o | 
			o truncate.
			out := o.
			self writeClass: cls.
			self writeClassMethods: cls
		]
	].

	extensionMethods ifNotEmpty: [ 
		directory / 'extensions.ltk' writeStreamDo: [ :o | 
			o truncate.
			out := o.
			self writeExtensionMethods.
		]
	].

	directory / 'package.ltk' writeStreamDo: [ :o |
		o truncate.
		out := o.
		
		out << 'Compiler'; lf.
		packages do: [ :pkg |
			out tab << 'declarePackage: ' << pkg name printString << ';'; lf
		].
	
		classes do: [ :cls |
			out tab << 'evaluateFileNamed: ' << (cls name , '.ltk') asString printString << ';'; lf
		].
		extensionMethods ifNotEmpty: [
			out tab << 'evaluateFileNamed: ''extensions.ltk'';'; lf
		].

		out tab << 'yourself.'; lf.
	].

]

{ #category : #writing }
LowtalkExporter >> writeToFileNamed: aFileName [
	aFileName asFileReference writeStreamDo: [ :o |
		o truncate.
		out := o.
		
		out << 'Compiler'; lf.
		packages do: [ :pkg |
			out tab << 'declarePackage: ' << pkg name printString << ';'; lf
		].
		
		out tab << 'yourself.'; lf.
		
		self
			writeClasses;
			writeMethods;
			writeExtensionMethods
	]
]
