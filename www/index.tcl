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

if {![db_0or1row get_user "select verified_p, authorized_p from mfa_users where user_id = :user_id"]} {
    set verified_p   "f"
    set authorized_p "f"
}

set user_status {}
if {$verified_p} {
    if {$authorized_p} {
	append user_status "You are already a verified and authorized user of the MFA. "
    } else { 
	append user_status "You are a verified but not yet authorized user of the MFA. "
    }
} else {
    append user_status "You are not a verified user of the MFA. "
}

if {[mfa::parameter_get]} {
    set mfa_mandatory_p 1
} else {
    set mfa_mandatory_p 0
    if {$verified_p} {
        append user_status "You can opt out from the MFA by selecting 'No' in the form below."
    } else {
        append user_status "You can start using it by selecting 'Yes' in the form below."
    }
}

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





