defmodule TinyCompilerTest do
  use ExUnit.Case
	import TinyCompiler.{Tokenizer, Parser, Transformer}
  doctest TinyCompiler

	@input  "(add 2 (subtract 4 2))";
	@output "add(2, subtract(4, 2));";

	@tokens [
  	%{ type: "paren",  value: "("        },
	  %{ type: "name",   value: "add"      },
	  %{ type: "number", value: "2"        },
	  %{ type: "paren",  value: "("        },
	  %{ type: "name",   value: "subtract" },
	  %{ type: "number", value: "4"        },
	  %{ type: "number", value: "2"        },
	  %{ type: "paren",  value: ")"        },
	  %{ type: "paren",  value: ")"        }
	];

	@ast %{
	  type: "Program",
	  body: [%{
	    type: "CallExpression",
	    name: "add",
	    params: [
	    	%{
		      type: "NumberLiteral",
		      value: "2"
	    	}, 
	    	%{
		      type: "CallExpression",
		      name: "subtract",
		      params: [
		      	%{
			        type: "NumberLiteral",
			        value: "4"
			      }, 
			      %{
			        type: "NumberLiteral",
			        value: "2"
			      }
			    ]
	    	}
	    ]
	  }]
	};

	@newAst %{
	  type: "Program",
	  body: [%{
	    type: "ExpressionStatement",
	    expression: %{
	      type: "CallExpression",
	      callee: %{
	        type: "Identifier",
	        name: "add"
	      },
	      arguments: [%{
	        type: "NumberLiteral",
	        value: "2"
	      }, %{
	        type: "CallExpression",
	        callee: %{
	          type: "Identifier",
	          name: "subtract"
	        },
	        arguments: [%{
	          type: "NumberLiteral",
	          value: "4"
	        }, %{
	          type: "NumberLiteral",
	          value: "2"
	        }]
	      }]
	    }
	  }]
	};

  test "Tokenizer should turn input string into tokens array" do
    assert @tokens == tokenize(@input)
  end

  test "Parser should turn tokens array into ast" do
  	assert @ast == parse(@tokens)
  end

  test "Transformer should turn ast into a newAst" do
  	assert @newAst == transform(@ast)
  end

  test "Compiler should turn #{@input} into #{@output}" do
  	assert @output == TinyCompiler.compile(@input)
  end
end
