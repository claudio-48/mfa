ad_page_contract {
    Multi Factor Authentication page

    @author Claudio Pasolini

}

set title "Multi Factor Authentication"

set user_id [auth::require_login]

set page_title $title
set context $page_title

set buttons [list [list "Please choose one" new]]

ad_form -name mfa \
        -mode edit \
        -edit_buttons $buttons \
        -has_edit 1 \
        -form {

    {mfa_p:boolean(radio)
        {options {{"No" f} {"Yes" t} }}
        {label {Do you want to start using MFA?}}
	{help_text {If you select "Yes" you will be rediirected to the MFA setup page, else to the site's Home Page}}
    }

} -on_submit {

    if {$mfa_p} {
	set return_url /mfa/setup
    } else {
	set return_url /
	# delete the eventual user row 
	db_dml auth_off "delete from mfa_users where user_id = :user_id"
    } 

} -after_submit {

    ad_returnredirect $return_url
    ad_script_abort
}
