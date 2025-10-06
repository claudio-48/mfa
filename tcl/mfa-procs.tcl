ad_library {
    Two Factor Authentication helper procs
}

namespace eval mfa {}

ad_proc -private mfa::generate_secret {} {
    Generate the secret Base32
} {
    package require base32
    
    set raw [ns_crypto::randombytes 20]
    return [base32::encode $raw]
}

ad_proc mfa::totp {
    -secret:required
    {-for_time ""}
    {-time_step 30}
    {-digits 6}
} {
    # generates current TOTP (6 digits, 30 seconds step)
} {
    package require base32
    
    if {$for_time eq ""} {
        set for_time [clock seconds]
    }

    set counter [expr {int($for_time / $time_step)}]
    set key [base32::decode $secret]

    return [ns_totp -key $key \
                    -time $for_time \
                    -interval $time_step \
                    -digits $digits \
                    -digest sha1]    
    
}

ad_proc mfa::verify {
    -secret:required
    -code:required
    {-time_step 30}
    {-skew 1}
    {-digits 6}
} {
    Compares the secret with the code entered by the user (skew ±1 for clock tolerance)
} {
    set code [string trim $code]
    for {set i -$skew} {$i <= $skew} {incr i} {
        set t [expr {[clock seconds] + $i * $time_step}]
	set totp_code [mfa::totp \
		 -secret    $secret \
		 -for_time  $t \
		 -time_step $time_step \
		 -digits    $digits]
        if {$totp_code eq $code} {
            return 1
        }
    }
    return 0
}


ad_proc -private mfa::check_if_needed {
    user_id
} {
    Checks if the user chose to use the MFA
} {
    set mfa_p [db_string check_2fa {	
        select 't' from mfa_users where user_id = :user_id
    } -default "f"]

    return $mfa_p
}


ad_proc -private mfa::totp_check {} {
    This proc is called by a filter and redirects to mfa login page until the user enters a valid OTP.
} {

    set url [ad_conn url]
    #ns_log notice "mfa::totp_check processing $url"
    
    set user_id [ad_conn user_id]

    if {![string is integer $user_id] && $user_id > 0} {
	#ns_log notice "mfa::totp_check user $user_id not logged in"
	# user is not logged in: let's go
	return filter_ok
    }

    # user is logged in
    
    if {![mfa::check_if_needed $user_id]} {
	#ns_log notice "mfa::totp_check OTP not needed"	
	# OTP not required: let's go  
	return filter_ok
    }

    # the mfa_users thable has one row for this user

    if {[string match /register* $url] || [string match /mfa* $url]} {
	# set OTP authorization to false and let the user go
	db_dml auth_false "update mfa_users set authorized_p = 'f' where user_id = :user_id"
	#ns_log notice "\nmfa::totp_check authorization flag of user $user_id forced to false."
	return filter_ok
    }
    
    if {[db_string otp_check "select authorized_p from mfa_users where user_id = :user_id"]} {
        #ns_log notice "mfa::totp_check user $user_id is authorized"        
	return filter_ok
    } 

    # user not authorized: redirect to mfa login page
    #ns_log notice "mfa::totp_check user redirected to OTP"    
    rp_internal_redirect "/packages/mfa/www/setup"
    return filter_return

}


# Redirects to MFA login page until user authorized
ad_register_filter -critical "t" postauth * /* mfa::totp_check 
