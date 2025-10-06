ad_page_contract {
    Setup 2FA for the logged in user
}

set context [list "Multi Factor Authentication Setup"]

set user_id [ad_conn user_id]

# check if the user is already using the 2FA
set secret [db_string get_secret "select secret from mfa_users where user_id = :user_id" -default ""]

if {$secret eq ""} {

    # generates a new secret
    set secret [mfa::generate_secret]

    # store as not verified and not authorized
    db_dml insert_secret "
        insert into mfa_users (user_id, secret, verified_p, authorized_p)
        values (:user_id, :secret, 'f', 'f')
    "

    # generates URI otpauth
    set issuer "OpenACS"
    set account_name "[ad_conn user_id]@[ad_conn peeraddr]"
    set uri "otpauth://totp/${issuer}:${account_name}?secret=$secret&issuer=$issuer&digits=6"

    # generates the QR code PNG
    set png_path "[acs_root_dir]/packages/mfa/www/tmp/mfa_qr_$user_id.png"
    exec qrencode -o $png_path $uri
    
    set qrcode_p 1  ; # initial setup with qrcode needed

} else {

    set qrcode_p 0  ; # qrcode not needed

}

ad_return_template
