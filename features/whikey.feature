# encoding: utf-8

Feature: Wiki JSON format is handled like a charm

Scenario: Get remote JSON
	Given we have a term "Barcelona"
	When we retrieve the content from remote
	Then the result is stored in cache folder

	Scenario: Get remote JSON
		Given we have a term "Barce"
		When we retrieve the content from remote
		Then the result is stored in cache folder

	Scenario Outline: Retrieve every data for term
		Given we have a term "Barcelona"
		When we initialize 'Parser' with this term
		 And we request <input> tag from parser
		Then the result equals to <output>

		Examples:
        | input                          | output                             |
        | "geo"                  | "41.38333333333333,2.183333333333333" |

###############################################################################
