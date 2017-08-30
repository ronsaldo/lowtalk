# Lowtalk
### A new Smalltalk dialect to replace Slang

Lowtalk is a new Smalltalk dialect that can work without a VM, by generating
native machine into standard relocatable object files that can be linked with a
platform specific linker. This dialect introduces syntax extensions for communicating
with C function directly, to define variables and values with primitive types
that can be implemented efficiently with machine instructions, and also to define
the required

The Lowtalk compiler is completely implemented in Pharo, and it is implemented as
a meta-circular evaluator that is used to bootstrap the target Smalltalk object model and runtime. The front-end is in this repository and its end result is the SSA
intermediate representation of Slovim (Smalltalk Low Level Virtual Machine), a compiler infrastructure heavily inspired on LLVM but implemented completely in Pharo. The
Slovim intermediate representation is converted into the SAsm intermediate
representation which is inspired by the VirtualCPU for doing register allocation
and generating x86 or x86_64 assembly code that is converted into the relocatable
binary object file.

For debugging there is partial support for generating the debugging information in
the DWARF standard, which allows to set breakpoints and inspect global variables
in gdb. It is still missing the debugging support for inspecting local variables in
gdb.

For garbage collection we are currently using automatic reference counting, which
it is slow but allows to support real multi-threading easily, which of course we do.

## Loading an Image with the Lowtalk compiler.
For loading an image with the Lowtalk compiler, you should clone this repository
and execute the *newImage.sh* script.

## Compiler usage
The Lowtalk compiler can be invoked from a Pharo Playground, or from the command line.

### Compiler usage example in the playground
For compiling the *Hello World* sample into a relocatable object file, you can run this script on the playground:

```Smalltalk
compiler := LowtalkCompiler compilationTarget:
    SLVMSAsmCompilationTarget x86 withDebugInformation.
compiler
	evaluateFileNamed: 'runtime/runtime.ltk';
    evaluateFileNamed: 'samples/HelloWorld.ltk';
	optimizationLevel: 1;
	writeObjectToFileNamed: 'hello.o'
```

### Compiler usage example in the command line
The same *Hello World* sample can be compiled from the command line by using the
following command:

```bash
./ltkc -m32 -c -o hello.o -O1 -g runtime/runtime.ltk samples/HelloWorld.ltk
```

### Linking example

The resulting *hello.o* can be linked in Linux into an executable with the following
bash command:

```bash
gcc -m32 -no-pie -pthread -o hello hello.o
```

Because we do not have support position independent code yet, on OS X for linking it is required to use the following command:

```bash
clang -m32 -no-pie -o hello hello.o
```

## Syntax extensions

### Variables with types

```Smalltalk
[<Int32> :a<Int64> :b |
    | c c<Int32>|
]
```

### *let* variable definition expression

In addition to the normal way of defining variables in Smalltalk, there is a *let*
expression that allows to define variable. Unlike a normal variable definition,
a *let* definition without an explicit type will try to infer its type according
to the initial value that is given to it. For literal values, it will try to infer
a primitive type if possible.

```Smalltalk
let a := 5. "Int32 type"
let b := 1.0. "Float64 type"
let c<Float32> := 1.0. "Float64 type"
```

### C string style literal (e.g: c'Hello World\n')

By prefixing a string literal with the *c* character, it is possible to use C escape codes in the string literal.

### #{} C function style calling expression

```Smalltalk
LibC printf #{c'An Integer: %d\n' . 2}.
```

### Method AST expression
Because Smalltalk does not have an uniform syntax for method definitions, or DoIt expression, in Lowtalk to be able to keep everything in plain text files, there is an expression that returns the AST of a method.

```Smalltalk
:[addWith: other
    ^ self + other
]
```

This typically used in the following way:
```Smalltalk
Object category: 'sample' methods: {
:[addWith: other
    ^ self + other
]
}.
```

## Type System

In Lowtalk there two main categories of types: native types, and
dynamic object types. Native types are the types that have a direct correlation
with a C type. Dynamic object types, are used to represent a generic dynamic object (*_DynamicObject*), or a specific dynamic object that is used in very special circumstances, such as implementing *self*.

| Native Type         | C Type                           |
|---------------------|----------------------------------|
| Void                | Void                             |
| Int8                | char                             |
| Int16               | short                            |
| Int32               | int                              |
| Int64               | long/long long                   |
| IntPointer          | intptr_t                         |
| UInt8               | unsigned char                    |
| UInt16              | unsigned short                   |
| UInt32              | unsigned int                     |
| UInt64              | unsigned long/unsigned long long |
| UIntPointer         | uintptr_t                        |
| Float32             | long/long long                   |
| Float64             | long/long long                   |
| Void pointer        | void*                            |
| UInt8 const pointer | const char *                     |
| UInt8 array         | char[]                           |
| UInt8 array: 64     | char[64]                         |

Structures, unions, and packed structures (structure with alignment of 1) can be defined in the following ways:

```Smalltalk
Structure named: #MyPoint slots: {
    #x => Float32.
    #y => Float64.
}.

Union named: #MyUnion slots: {
    #p => MyPoint.
    #pt => (MyPoint pointer).
    #f => Float32.
    #d => Float64.
}.

PackedStructure named: #MyPackedStructure slots: {
    #a => UInt8.
    #b => UInt16.
}.
```

The evaluation of the slots of these types is done lazily to be able to resolve
circular dependencies between types, e.g:

```Smalltalk
Structure named: #LinkedListNode slots: {
    #next => LinkedListNode pointer.
    #value => Void pointer.
}.
```

## Future Work

This is a non-exhaustive list of future work stuff to do:

- Slovim was originally created to generate Spir-V and graphics API specific shader
code, so it should be possible
- A Lowcode backend for Slovim should make it possible to use Lowtalk in a Pharo
image.
- Replace the automatic reference counting with a concurrent garbage collector.
