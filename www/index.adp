<master>
<property name="doc(title)">Multi Factor Authentication</property>
<property name="context">@context;literal@</property>

<if @mfa_mandatory_p@ true>
  <h2>The Multi Factor Authentication is mandatory for this site</h2>
  <p>@user_status;literal@</p>
</if>
<else>
  <h2>The Multi Factor Authentication is optional</h2>
    <p>@user_status;literal@</p>
  <formtemplate id="mfa"></formtemplate>
</else>

<p>In the context of this package <i>verified</i> means that the user has already done the initial setup with QR code and Base32 secret shared with Google Authenticator or one of the apps compliant with RFC 6238. <i>authorized</i> means that the user is already verified and entered a valid OTP.</p>

<if @admin_p@ true>
    <p>As an admin you can <a href="toggle">toggle</a> the parameter that allows an administrator to set MFA as mandatory for everyone or selectable on a per-user basis.</p>
</if>
