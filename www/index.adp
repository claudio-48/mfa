<master>
<property name="doc(title)">Multi Factor Authentication</property>
<property name="context">@context;literal@</property>

<if @mfa_mandatory_p@ true>
  <h2>The Multi Factor Authentication is mandatory for this site</h2>
</if>
<else>
  <h2>The Multi Factor Authentication is optional</h2>
  <formtemplate id="mfa"></formtemplate>
</else>

<if @admin_p@ true>
    <p>As an admin you can <a href="toggle">toggle</a> the parameter that allows an administrator to set MFA as mandatory for everyone or selectable on a per-user basis.</p>
</if>
