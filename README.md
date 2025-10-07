# MFA (Multi-Factor Authentication) for OpenACS

This package provides **Time-based One-Time Password (TOTP)** two-factor authentication (2FA) for OpenACS / NaviServer applications, compatible with **Google Authenticator** and similar apps (Authy, Microsoft Authenticator, FreeOTP, etc.).

It integrates seamlessly into the OpenACS authentication flow and uses the built-in `ns_totp` command from NaviServer and 'qrencode' CLI via 'exec'.

---

## 🚀 Features

- Implements TOTP (RFC 6238) using `ns_totp`
- User setup with QR code and Base32 secret
- OTP verification with configurable time window tolerance (`skew`)
- The decision to use the 2FA is left to the user, who can opt in and out at any moment
- Optional enforcement of 2FA for all users (actually not implemented)
- PostgreSQL schema and setup/verify pages included

---


