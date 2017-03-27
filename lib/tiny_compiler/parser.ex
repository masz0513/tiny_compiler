defmodule TinyCompiler.Parser do
	@moduledoc """
	/**
	 * ============================================================================
	 *                                 ヽ/❀o ل͜ o\ﾉ
	 *                                THE PARSER!!!
	 * ============================================================================
	 */

	/**
	 * For our parser we're going to take our array of tokens and turn it into an
	 * AST.
	 *
	 *   [{ type: 'paren', value: '(' }, ...]   =>   { type: 'Program', body: [...] }
	 */	
	"""

	def parse(tokens) do
		%{type: "Program", body: [do_walk(tokens, %{type: ""})]}
	end

	defp do_walk([], ast), do: ast

	defp do_walk([%{type: "paren", value: "("} | t], %{type: ""}) do
		[name_token | rest] = t
		do_walk(rest, %{type: "CallExpression", name: name_token.value, params: []})
	end

	defp do_walk([%{type: "paren", value: "("} | t], ast) do
		[name_token | rest] = t
		{params, rest} = Enum.split_while(rest, &(&1.value != ")"))
		sub_ast = do_walk(params, %{type: "CallExpression", name: name_token.value, params: []})
		sub_ast = %{sub_ast | params: Enum.reverse(sub_ast.params)}
		do_walk(rest, %{ast | params: Enum.reverse([sub_ast | ast.params])})
	end

	defp do_walk([%{type: "number", value: val} | t], ast) do
		ast = %{ast | params: [%{type: "NumberLiteral", value: val} | ast.params]}
		do_walk(t, ast)
	end

	defp do_walk([%{type: "string", value: val} | t], ast) do
		ast = %{ast | params: [%{type: "StringLiteral", value: val} | ast.params]}
		do_walk(t, ast)
	end

	defp do_walk([%{type: "paren", value: ")"} | t], ast), do: do_walk(t, %{ast | params: Enum.reverse(ast.params)})

	defp do_walk([%{type: type, value: _} | _], _), do: raise "I dont know what this type is: #{type}"
end