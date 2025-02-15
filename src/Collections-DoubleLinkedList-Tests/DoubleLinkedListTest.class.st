Class {
	#name : #DoubleLinkedListTest,
	#superclass : #TestCase,
	#category : #'Collections-DoubleLinkedList-Tests-Base'
}

{ #category : #'tests - adding' }
DoubleLinkedListTest >> testAddAfterLink [
	| list link |
	list := DoubleLinkedList new.
	list add: 1.
	link := list add: 2.
	list add: 3.
	list add: 0 afterLink: link.
	self assert: list asArray equals: #( 1 2 0 3 )
]

{ #category : #'tests - adding' }
DoubleLinkedListTest >> testAddBeforeLink [
	| list link |
	list := DoubleLinkedList new.
	list add: 1.
	link := list add: 2.
	list add: 3.
	list add: 0 beforeLink: link.
	self assert: list asArray equals: #( 1 0 2 3 )
]

{ #category : #'tests - adding' }
DoubleLinkedListTest >> testAddFirst [
	| list |
	list := DoubleLinkedList new.
	1 to: 3 do: [ :each | list add: each ].
	list addFirst: 0.
	self deny: list isEmpty.
	self assert: list first equals: 0.
	self assert: list last equals: 3.
	self assert: list asArray equals: #( 0 1 2 3 )
]

{ #category : #'tests - adding' }
DoubleLinkedListTest >> testAddLast [
	| list |
	list := DoubleLinkedList new.
	1 to: 3 do: [:each | list add: each ].
	list addLast: 0.
	self deny: list isEmpty.
	self assert: list first equals: 1.
	self assert: list last equals: 0.
	self assert: list asArray equals: #( 1 2 3 0 )
]

{ #category : #'tests - iterating' }
DoubleLinkedListTest >> testCollect [
	| list doubles |
	list := DoubleLinkedList new.
	list addAll: #(1 2 3).
	doubles := list collect: [ :each | each * 2 ].
	self assert: doubles asArray equals: #(2 4 6)
]

{ #category : #'tests - iterating' }
DoubleLinkedListTest >> testDo [
	| list value |
	list := DoubleLinkedList new.
	list addAll: (1 to: 10).
	value := 1.
	list do: [ :each |
		self assert: each equals: value.
		value := value + 1 ]
]

{ #category : #'tests - testing' }
DoubleLinkedListTest >> testEmpty [
	| list |
	list := DoubleLinkedList new.
	self assertEmpty: list.
	self should: [ list first ] raise: CollectionIsEmpty.
	self should: [ list last ] raise: CollectionIsEmpty.
	list do: [ :each | self fail ]
]

{ #category : #tests }
DoubleLinkedListTest >> testFirstAndLastLink [
	| list firstLink secondLink |
	list := DoubleLinkedList new.
	self should: [ list firstLink ] raise: CollectionIsEmpty.
	self should: [ list lastLink ] raise: CollectionIsEmpty.
	self should: [ list first ] raise: CollectionIsEmpty.
	self should: [ list last ] raise: CollectionIsEmpty.
	firstLink := list add: #one.
	self assert: list firstLink equals: firstLink.
	self assert: list first equals: list last.
	self assert: list firstLink equals: list lastLink.
	self assert: list firstLink value equals: #one.
	secondLink := list add: #two.
	self assert: list firstLink equals: firstLink.
	self assert: list lastLink equals: secondLink.
	self deny: list first equals: list last.
	self deny: list firstLink equals: list lastLink.
	self assert: list firstLink value equals: #one.
	self assert: list lastLink value equals: #two
]

{ #category : #'tests - testing' }
DoubleLinkedListTest >> testIncludes [
	| list |
	list := DoubleLinkedList new.
	list addAll: (1 to: 10).
	self assert: (list includes: 5).
	self deny: (list includes: 0)
]

{ #category : #'tests - iterating' }
DoubleLinkedListTest >> testLinksDo [
	| list links index |
	list := DoubleLinkedList new.
	links := OrderedCollection new.
	1 to: 10 do: [ :each |
		links add: (list add: each) ].
	index := 1.
	list linksDo: [ :each |
		self assert: each equals: (links at: index).
		self assert: each value equals: index.
		index := index + 1 ]
]

{ #category : #'tests - instance creation' }
DoubleLinkedListTest >> testNewFromCollection [

	|d|
	d := DoubleLinkedList newFrom: #(a b c).

	self assert: d firstLink value equals: #a.
	self assert: d lastLink value equals: #c.

	self assert: d firstLink nextLink value equals: #b.
	self assert: d lastLink previousLink value equals: #b
]

{ #category : #tests }
DoubleLinkedListTest >> testOne [
	| list |
	list := DoubleLinkedList new.
	list add: #one.
	self deny: list isEmpty.
	self assert: list first equals: #one.
	self assert: list last equals: #one.
	self assert: list asArray equals: #( one )
]

{ #category : #'tests - removing' }
DoubleLinkedListTest >> testOneRemoveFirst [
	| list |
	list := DoubleLinkedList new.
	list add: #one.
	list removeFirst.
	self assertEmpty: list.
	list add: #one.
	list removeLast.
	self assertEmpty: list
]

{ #category : #'tests - removing' }
DoubleLinkedListTest >> testOneRemoveLast [
	| list |
	list := DoubleLinkedList new.
	list add: #one.
	list removeLast.
	self assertEmpty: list.
	list add: #one.
	list removeLast.
	self assertEmpty: list
]

{ #category : #'tests - removing' }
DoubleLinkedListTest >> testReject [
	| list even |
	list := DoubleLinkedList new.
	list addAll: (1 to: 10).
	even := list reject: [ :each | each odd ].
	self assert: even asArray equals: #(2 4 6 8 10)
]

{ #category : #'tests - iterating' }
DoubleLinkedListTest >> testReverseDo [
	| list value |
	list := DoubleLinkedList new.
	list addAll: (1 to: 10).
	value := 10.
	list reverseDo: [ :each |
		self assert: each equals: value.
		value := value - 1 ]
]

{ #category : #'tests - iterating' }
DoubleLinkedListTest >> testReverseLinksDo [
	| list links index |
	list := DoubleLinkedList new.
	links := OrderedCollection new.
	1 to: 10 do: [ :each |
		links add: (list add: each) ].
	index := 10.
	list reverseLinksDo: [ :each |
		self assert: each equals: (links at: index).
		self assert: each value equals: index.
		index := index - 1 ]
]

{ #category : #tests }
DoubleLinkedListTest >> testSelect [
	| list even |
	list := DoubleLinkedList new.
	list addAll: (1 to: 10).
	even := list select: [ :each | each even ].
	self assert: even asArray equals: #(2 4 6 8 10)
]

{ #category : #tests }
DoubleLinkedListTest >> testThree [
	| list |
	list := DoubleLinkedList new.
	1 to: 3 do: [ :each | list add: each ].
	self deny: list isEmpty.
	self assert: list first equals: 1.
	self assert: list last equals: 3.
	self assert: list asArray equals: #( 1 2 3 )
]

{ #category : #'tests - removing' }
DoubleLinkedListTest >> testThreeRemoveFirst [
	| list link |
	list := DoubleLinkedList new.
	1 to: 3 do: [ :each | list add: each ].
	link := list removeFirst.
	self assert: link value equals: 1.
	self assert: list first equals: 2.
	self assert: list last equals: 3.
	self assert: list asArray equals: #( 2 3 )
]

{ #category : #'tests - removing' }
DoubleLinkedListTest >> testThreeRemoveLast [
	| list link |
	list := DoubleLinkedList new.
	1 to: 3 do: [ :each | list add: each ].
	link := list removeLast.
	self assert: link value equals: 3.
	self assert: list first equals: 1.
	self assert: list last equals: 2.
	self assert: list asArray equals: #( 1 2 )
]

{ #category : #'tests - removing' }
DoubleLinkedListTest >> testThreeRemoveLink [
	| list link |
	list := DoubleLinkedList new.
	list add: 1.
	link := list add: 2.
	list add: 3.
	list removeLink: link.
	self assert: list first equals: 1.
	self assert: list last equals: 3.
	self assert: list asArray equals: #( 1 3 )
]
