defmodule TinyCompiler.Transformer do
	@moduledoc """
	/**
	 * ============================================================================
	 *                                   ⁽(◍˃̵͈̑ᴗ˂̵͈̑)⁽
	 *                              THE TRANSFORMER!!!
	 * ============================================================================
	 */

	/**
	 * Next up, the transformer. Our transformer is going to take the AST that we
	 * have built and create a new ast.
	 *
	 * ----------------------------------------------------------------------------
	 *   Original AST                     |   Transformed AST
	 * ----------------------------------------------------------------------------
	 *   {                                |   {
	 *     type: 'Program',               |     type: 'Program',
	 *     body: [{                       |     body: [{
	 *       type: 'CallExpression',      |       type: 'ExpressionStatement',
	 *       name: 'add',                 |       expression: {
	 *       params: [{                   |         type: 'CallExpression',
	 *         type: 'NumberLiteral',     |         callee: {
	 *         value: '2'                 |           type: 'Identifier',
	 *       }, {                         |           name: 'add'
	 *         type: 'CallExpression',    |         },
	 *         name: 'subtract',          |         arguments: [{
	 *         params: [{                 |           type: 'NumberLiteral',
	 *           type: 'NumberLiteral',   |           value: '2'
	 *           value: '4'               |         }, {
	 *         }, {                       |           type: 'CallExpression',
	 *           type: 'NumberLiteral',   |           callee: {
	 *           value: '2'               |             type: 'Identifier',
	 *         }]                         |             name: 'subtract'
	 *       }]                           |           },
	 *     }]                             |           arguments: [{
	 *   }                                |             type: 'NumberLiteral',
	 *                                    |             value: '4'
	 * ---------------------------------- |           }, {
	 *                                    |             type: 'NumberLiteral',
	 *                                    |             value: '2'
	 *                                    |           }]
	 *  (sorry the other one is longer.)  |         }
	 *                                    |       }
	 *                                    |     }]
	 *                                    |   }
	 * ----------------------------------------------------------------------------
	 */
	"""

	def transform(ast) do
		%{
			type: "Program", 
			body: [%{type: "ExpressionStatement", expression: do_transform(ast.body, %{type: ""})}]
		}
	end

	defp do_transform([], txAst), do: txAst

	defp do_transform([%{type: "CallExpression", name: name, params: params} | _], %{type: ""}) do
		txAst = %{
			type: "CallExpression", 
			callee: %{type: "Identifier", name: name},
			arguments: []
		}
		do_transform(Enum.reverse(params), txAst)
	end

	defp do_transform([%{type: "CallExpression", name: name, params: params} | t], txAst) do
		subTxAst = %{
			type: "CallExpression", 
			callee: %{type: "Identifier", name: name},
			arguments: []
		}
		subTxAst = do_transform(Enum.reverse(params), subTxAst)
		do_transform(t, %{txAst | arguments: [subTxAst | txAst.arguments]})
	end

	defp do_transform([%{type: "NumberLiteral", value: value} | t], txAst) do
		txAst = %{txAst | arguments: [%{type: "NumberLiteral", value: value} | txAst.arguments]}
		do_transform(t, txAst)
	end

	defp do_transform([%{type: "StringLiteral", value: value} | t], txAst) do
		txAst = %{txAst | arguments: [%{type: "StringLiteral", value: value} | txAst.arguments]}
		do_transform(t, txAst)
	end
end