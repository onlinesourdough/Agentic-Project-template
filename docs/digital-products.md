# Static storefronts and paid digital products

Static hosting and paid delivery solve different problems.

## Public storefront

GitHub Pages can safely host:

- product pages and documentation
- public samples and free resources
- pricing and checkout links
- first-party analytics that do not expose private material

Everything in a public repository or Pages artifact must be treated as public.
CSS-hidden routes, unlinked files, client-side flags, and JavaScript access
checks do not protect paid content.

## Developer-product delivery

A developer product can combine:

1. a static Pages storefront
2. a Stripe Payment Link on the seller's account
3. backend-owned fulfillment that grants access to a private repository

This is appropriate only when every buyer can use GitHub and repository access
is the real entitlement. Fulfillment must reconcile payments with actual
access, retry expired invitations, revoke access after refunds when required,
and use least-privilege Stripe and GitHub credentials.

The public preview documents this pattern but does not ship a polling or
fulfillment engine.

## Paid libraries

A paid library for a broader audience should use:

```text
checkout -> signed webhook -> entitlement store
login -> server-side session -> server-side authorization
content request -> entitlement check -> protected response
```

Cloudflare Workers with D1 are a good first profile for straightforward
entitlements. Convex fits when the product also needs realtime state,
collaboration, scheduling, or shared application data.

Paid videos, downloads, and source files should use an access-controlled origin
and short-lived signed delivery where practical.

## Merchant responsibility

Stripe Payment Links do not make the seller a merchant of record. Tax,
invoicing, refunds, chargebacks, and consumer obligations remain business
responsibilities. Compare that operational burden with a merchant-of-record
provider before choosing direct Stripe delivery.
