defmodule TinyCompiler.CodeGenerator do
	@moduledoc """
	/**
	 * ============================================================================
	 *                               ヾ（〃＾∇＾）ﾉ♪
	 *                            THE CODE GENERATOR!!!!
	 * ============================================================================
	 */

	/**
	 * Now let's move onto our last phase: The Code Generator.
	 *
	 * Our code generator is going to recursively call itself to print each node in
	 * the tree into one giant string.
	 */
	"""
	
	def generate(txAst) do
		do_generate(txAst.body, "")
	end

	defp do_generate([], code), do: code

	defp do_generate([%{type: "ExpressionStatement", expression: expression} | _], _) do
		do_generate(expression, ";")
	end

	defp do_generate(%{type: "CallExpression", callee: callee, arguments: arguments}, code) do
		args = Enum.reduce(arguments, nil, fn(node, acc) ->
			if acc == nil, do: "#{do_generate(node)}", else: "#{acc}, #{do_generate(node)}" 
		end)

		"#{callee.name}(#{args})" <> code
	end

	defp do_generate(%{type: "NumberLiteral", value: value}), do: value

	defp do_generate(%{type: "StringLiteral", value: value}), do: value

	defp do_generate(%{type: "CallExpression"} = node), do: do_generate(node, "")
end