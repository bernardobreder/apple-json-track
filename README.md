# Introdução

O componente JsonTrack tem o objetivo registrar todas as modificações realizadas no Json de tal forma a pode reverter as modificações e aplicar novamente caso tenha sido revertido.

# Exemplo

O exemplo abaixo irá criar um Json, aplicando algumas mudanças e revertendo

```swift
let json = Json([:])
let track = JsonTrack(json: json)

track.apply("a", "b", "c", value: 1)
print(json) // { a: { b: { c: 1 } } }
track.changes.count == 3
track.changes[0] == InsertDictionaryJsonTrackChange(["a"])
track.changes[1] == InsertDictionaryJsonTrackChange(["a", "b"])
track.changes[2] == UpdateJsonTrackChange(["a", "b", "c"], from: nil, to: 1)

track.apply("a", "b", "d", "e", "f", value: 2)
print(json) // { a: { b: { c: 1, d: { e: { f: 2 } } } } }
track.changes.count == 6
track.changes[3] == InsertDictionaryJsonTrackChange(["a", "b", "d"])
track.changes[4] == InsertDictionaryJsonTrackChange(["a", "b", "d", "e"])
track.changes[5] == UpdateJsonTrackChange(["a", "b", "d", "e", "f"], from: nil, to: 2)

track.changes.removeLast().revert(json: json)
print(json) // { a: { b: { c: 1, d: { e: {} } } } }
track.changes.removeLast().revert(json: json)
print(json) // { a: { b: { c: 1, d: {} } } }
track.changes.removeLast().revert(json: json)
print(json) // { a: { b: { c: 1 } } }
track.changes.count == 3

track.changes.removeLast().revert(json: json)
print(json) // { a: { b: {} } }
track.changes.removeLast().revert(json: json)
print(json) // { a: {} }
track.changes.removeLast().revert(json: json)
print(json) // {}
track.changes.count == 0
```

# Api

## Construtor

* Constrói o componente com um Json associado

```swift
init(json: Json)
```

## Campos

* Campo que retorna o Json que está monitorando

```swift
let json: Json 
```

* Retorna todas as mudanças monitorada

```swift
let changes: [JsonTrackChange]
```

## Funções

* Aplica uma mudança de um caminho atribuindo um valor

```swift
func apply(_ paths: IndexLiteral..., value: Literal) -> Self
```


