Class {
	#name : #LowtalkMethodAddition,
	#superclass : #Object,
	#instVars : [
		'behavior',
		'method',
		'category',
		'priorMethodOrNil',
		'priorCategoryOrNil'
	],
	#category : #'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkMethodAddition >> behavior [
	^ behavior
]

{ #category : #accessing }
LowtalkMethodAddition >> behavior: anObject [
	behavior := anObject
]

{ #category : #accessing }
LowtalkMethodAddition >> category [
	^ category
]

{ #category : #accessing }
LowtalkMethodAddition >> category: anObject [
	category := anObject
]

{ #category : #installation }
LowtalkMethodAddition >> finishApplying [
	self notifyObservers
]

{ #category : #installation }
LowtalkMethodAddition >> install [
	priorMethodOrNil := behavior compiledMethodAt: method selector ifAbsent: [ nil ].
	priorCategoryOrNil := behavior organization categoryOfElement: method selector.
	
	behavior addSelectorSilently: method selector withMethod: method
]

{ #category : #accessing }
LowtalkMethodAddition >> method [
	^ method
]

{ #category : #accessing }
LowtalkMethodAddition >> method: anObject [
	method := anObject
]

{ #category : #installation }
LowtalkMethodAddition >> notifyObservers [
	SystemAnnouncer uniqueInstance 
		suspendAllWhile: [behavior organization classify: method selector under: category].
	priorMethodOrNil 
		ifNil: [ SystemAnnouncer uniqueInstance methodAdded: method ]
		ifNotNil: [
			SystemAnnouncer uniqueInstance methodChangedFrom: priorMethodOrNil to: method oldProtocol: priorCategoryOrNil.
			priorCategoryOrNil = category ifFalse: [
       			SystemAnnouncer uniqueInstance methodRecategorized: method oldProtocol: priorCategoryOrNil ] ].
	behavior instanceSide 
		noteCompilationOfMethod: method
		meta: behavior isClassSide.
]
