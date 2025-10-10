ad_page_contract {
    Multi Factor Authentication page

    @author Claudio Pasolini

}

auth::require_login

set title "Multi Factor Authentication"

set user_id [auth::require_login]
set admin_p [acs_user::site_wide_admin_p -user_id $user_id]

set page_title $title
set context $page_title

set verified_p [db_string get_user "select verified_p from mfa_users where user_id = :user_id" -default 0]

set buttons [list [list "Please choose one" new]]

ad_form -name mfa \
        -mode edit \
        -edit_buttons $buttons \
        -has_edit 1 \
        -form {

    {mfa_p:boolean(radio)
        {options {{"No" f} {"Yes" t} }}
        {label {Do you want to use the MFA?}}
	{help_text {If you select "Yes" you will be redirected to the MFA setup page, else to the site's Home Page}}
    }

} -on_submit {

    if {$mfa_p} {
	set return_url /mfa/setup
	if {$verified_p} {
	    set message "You were already using the MFA"
	} else {
	    set message "You have chosen to use MFA."
	}
    } else {
	set return_url /
	if {$verified_p} {
	    set message "You were using the MFA and your secret has been deleted."
	    # delete the user row 
	    db_dml auth_off "delete from mfa_users where user_id = :user_id"
	} else {
	    set message "You were not using the MFA."
	}
    } 

} -after_submit {

    ad_returnredirect -message "$message" $return_url
    ad_script_abort
}

if {[mfa::parameter_get]} {
    set mfa_mandatory_p 1
} else {
    set mfa_mandatory_p 0
}



