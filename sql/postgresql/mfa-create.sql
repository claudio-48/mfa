--
-- a row in this table means that the user chose the Multi Factor Authentication
--
create table mfa_users (
    user_id     integer primary key
                references users(user_id)
                on delete cascade,
    secret      varchar(64) not null,
    -- false until the user enters a valid OTP during setup
    verified_p   boolean default 'f',
    -- false until the user enters a valid OTP during login    
    authorized_p boolean default 'f'
);


  



