defmodule TinyCompiler.Tokenizer do
	@moduledoc """
	/**
	 * ============================================================================
	 *                                   (/^▽^)/
	 *                                THE TOKENIZER!
	 * ============================================================================
	 */

	/**
	 * We're gonna start off with our first phase of parsing, lexical analysis, with
	 * the tokenizer.
	 *
	 * We're just going to take our string of code and break it down into an array
	 * of tokens.
	 *
	 *   (add 2 (subtract 4 2))   =>   [{ type: 'paren', value: '(' }, ...]
	 */
	"""
	
	def tokenize(input) do
		do_tokenize(input, [])
		|> Enum.reverse	
	end

	defp do_tokenize(<<>>, acc), do: acc

	defp do_tokenize("(" <> rest, acc), do: do_tokenize(rest, [%{type: "paren", value: "("} | acc])
	
	defp do_tokenize(")" <> rest, acc), do: do_tokenize(rest, [%{type: "paren", value: ")"} | acc])

	defp do_tokenize(~s(") <> rest, acc) do
		{str, rem} = parse_string(rest, {"", ""})
		do_tokenize(rem, [%{type: "string", value: str} | acc])
	end

	defp do_tokenize(<<h::utf8, rest::binary>> = input, acc) do
		h_str = to_string([h])

		cond do
			# ignore space
		  Regex.match?(~r/\s/, h_str) ->
		    do_tokenize(rest, acc)
		  # numbers
		  Regex.match?(~r/[0-9]/, h_str) ->
		  	{int_str, rem} = parse_number(input)
		    do_tokenize(rem, [%{type: "number", value: int_str} | acc])
		  # letters
		  Regex.match?(~r/[a-z]/i, h_str) ->
				{str, rem} = parse_function(input, {"", ""})
				do_tokenize(rem, [%{type: "name", value: str} | acc])
		  true ->
		  	raise "I don't know what this character is: #{h_str}"
		end
	end

	defp parse_string(~s(") <> rest, {acc, _}), do: {IO.iodata_to_binary(acc), rest}
	defp parse_string(<<h::utf8, rest::binary>>, {acc, _}), do: parse_string(rest, {[acc, h], ""})

	defp parse_function(<<h::utf8, rest::binary>> = rem, {acc, _}) do
		if Regex.match?(~r/[a-z]/i, to_string([h])) do
			parse_function(rest, {[acc, h], ""})
		else
			{IO.iodata_to_binary(acc), rem}
		end
	end

	defp parse_number(input) do
		int_str = elem(Integer.parse(input), 0)
		|> to_string()
		rem = elem(String.split_at(input, String.length(int_str)), 1)
		{int_str, rem}
	end
end