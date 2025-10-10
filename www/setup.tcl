ad_page_contract {
    Setup 2FA for the logged in user
}

auth::require_login
set context [list "Multi Factor Authentication Setup"]
set user_id [ad_conn user_id]

if {[db_0or1row get_secret "select secret, verified_p from mfa_users where user_id = :user_id"]} {
    ns_log notice "\nsetup user exists verified_p=$verified_p secret:$secret"
    if {$verified_p} {
        set qrcode_p 0  ; # already verified, qrcode not needed
    } else {
        # creates the qrcode
        mfa::generate_qrcode -user_id $user_id -secret $secret	
	set qrcode_p 1  ; # user not verified
    }
} else {
    # no data in the mfa_users.  initialize user
    set verified_p 0
    ns_log notice "\nsetup user doesn't exists"
    set secret [mfa::init_user $user_id]
    # creates the qrcode
    mfa::generate_qrcode -user_id $user_id -secret $secret
    set qrcode_p 1  ; # initial setup with qrcode needed
}

ad_return_template
 
