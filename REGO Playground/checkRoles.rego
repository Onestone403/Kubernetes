###
### Api Demo-Policy for Playground
### Past this in the rego field on the rego playground
###

package app.rbac

import future.keywords.contains
import future.keywords.if
import future.keywords.in

default allow := false

allow if user_is_admin

allow if {
	some role in user_methods
	input.method == role.method
}

user_is_admin if "admin" in data.user_roles[input.user]

user_methods contains method if {
	some role in data.user_roles[input.user]
	some method in data.roles[role]
}

###
### Sample Inputs
### Past these in the input field on the rego playground
###

#1 --> granted
{
    "user": "tim",
    "method": "POST"
}

#2 --> denied
{
    "user": "jimmy",
    "method": "POST"
}

#3 --> granted
{
    "user": "jimmy",
    "method": "GET"
}
