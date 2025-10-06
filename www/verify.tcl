ad_page_contract {
    Verify the OTP code
} {
    code:notnull
}

set user_id [ad_conn user_id]
set secret [db_string get_secret {select secret from mfa_users where user_id = :user_id} -default ""]

if {[mfa::verify -secret $secret -code $code]} {

    # authorize the user for the current session
    db_dml mark_authorized {
        update mfa_users set
	  verified_p   = 't',
	  authorized_p = 't'   	  -- mark status as authorized for the current session
        where user_id = :user_id
    }

    ad_returnredirect "/"
    
} else {

    # don't authorize the user for the current session
    db_dml mark_not_authorized {
        update mfa_users set
	  authorized_p = 'f'   	  -- mark status as not authorized for the current session
        where user_id = :user_id
    }

    ad_return_complaint 1 "The Code is not valid, retry."
}
