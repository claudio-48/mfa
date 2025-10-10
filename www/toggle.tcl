ad_page_contract {
    Toggle the content of the parameter enforce_2fa_p

    @author Claudio Pasolini

}

if {[acs_user::site_wide_admin_p -user_id [ad_conn user_id]]} {
    if {[mfa::parameter_get]} {
	parameter::set_from_package_key -package_key mfa -parameter enforce_2fa_p -value "0"
    } else {
	parameter::set_from_package_key -package_key mfa -parameter enforce_2fa_p -value "1"
    }
    set message "The parameter has been changed as required."
} else {
    set message "Sorry, you have to be an admin to toggle the parameter."
}

ad_returnredirect -message "$message" /mfa/
ad_script_abort 
