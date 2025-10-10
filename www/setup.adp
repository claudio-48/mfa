<master>
<property name="doc(title)">Multi Factor Authentication Setup</property>
<property name="context">@context;literal@</property>
  

<h2>Two Factor Authentication Setup</h2>

<if @qrcode_p;noquote@ true and @verified_p@ false>
  <p>Please scan the QR code with Google Authenticator or Authy:</p>
  <img src="/mfa/tmp/mfa_qr_@user_id;noquote@.png" alt="QR code" width="200" heigth="200" />
</if>

<div>
<form method="post" action="/mfa/verify">
  Insert the app generated code: <input type="text" name="code"/>
  <input type="submit" value="Verify"/>
</form>
</div>
<div>
  <p>If you can't enter a valid code, for example because you lost your smartphone, visit the
    <a href="/mfa/">MFA home page</a> and select No.</p>
</div>
