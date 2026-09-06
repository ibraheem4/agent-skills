# Entra guest access

The tenant may not own the operator's email domain, which makes the operator a B2B guest and
makes the CLI fail in ways that read as permissions rather than identity. Check before blaming
permissions:

- `login.microsoftonline.com/<domain>/v2.0/.well-known/openid-configuration` returning
  `AADSTS90002` means the domain is not an Entra tenant at all.
- `getuserrealm.srf?login=<upn>&json=1` returning `NameSpaceType: Unknown` means the same.
- An ID token with `idp: mail` is an email one-time-passcode B2B guest.

An OTP guest has no home tenant, so plain `az login` fails with *"couldn't find an account
with that username"* — it defaults to the `organizations` authority. Name the tenant, and ask
for a Graph scope rather than the default ARM one:

```
az login --use-device-code --tenant <tenant> --allow-no-subscriptions \
  --scope "https://graph.microsoft.com//.default"
```

A guest with no cloud RBAC cannot get an ARM token, and the browser then shows *"sign-in was
successful but you don't have permission"* — **while the CLI still receives its Graph token.**
That page is cosmetic; check `az ad signed-in-user show` before believing it failed.

⚠️ `az account show` stays green on an expired refresh token. Guard on a real Graph call.
