<a href="compiler.go"><img width="731" alt="THE SUPER TINY COMPILER" src="https://cloud.githubusercontent.com/assets/952783/14413766/134c4068-ff39-11e5-996e-9452973299c2.png"/></a>

This is essentially just a port of [The Super Tiny Compiler][1] written in JavaScript by James Kyle.

### Installation

```
git clone git@github.com:masz0513/tiny_compiler.git
cd tiny_compiler
iex -S mix
```

### Usage

```elixir
iex> TinyCompiler.compile ~s/(add 4 (subtract 3 2))/
"add(4, subtract(3, 2));"
```

### Test

```elixir
$ mix test
```
