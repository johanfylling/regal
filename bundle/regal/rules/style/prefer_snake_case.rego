# METADATA
# description: Prefer snake_case for names
package regal.rules.style["prefer-snake-case"]

import future.keywords.contains
import future.keywords.if
import future.keywords.in

import data.regal.ast
import data.regal.result
import data.regal.util

report contains violation if {
	some rule in input.rules
	some ref in ast.named_refs(rule.head.ref)
	not util.is_snake_case(ref.value)

	violation := result.fail(rego.metadata.chain(), result.location(location_of(ref, rule)))
}

report contains violation if {
	some var in ast.find_vars(input.rules)
	not util.is_snake_case(var.value)

	violation := result.fail(rego.metadata.chain(), result.location(var))
}

# annoyingly, rule head refs are missing location when a rule.head.name is present,
# or rather when there's only a single item in the ref.. this inconsistency should
# probably be fixed in OPA, but until then, there's this.
location_of(ref, rule) := ref if ref.location

else := rule.head
