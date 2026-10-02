# Provider guide

This source-backed reference covers every value in `Social`. It separates authentication from service authorization, official controls from package presets, and public evidence from unknowns. The primary evidence was checked on 2026-09-29.

All 35 providers now have package PNG defaults. Google, Apple, Microsoft,
Kakao, Naver, LINE, X, LinkedIn, Twitch, Spotify, and Bitbucket use reviewed
provider-supplied originals. The other 24 use package adaptations rendered
from pinned Simple Icons SVGs. `asset.official` records source origin only,
not provider approval or package-redistribution permission. Neither source
category makes the shared `SocialButton` geometry an official provider control.

Official values below are copied only when a first-party source states them. Package colors, shared shapes, and hover, focus, pressed, and disabled states remain package presets unless a provider section explicitly says otherwise. Public asset availability does not by itself grant redistribution, and missing public terms do not prove prohibition or a partner-only rule.

## Provider index

| Provider | Identifier | Research group |
| --- | --- | --- |
| [Facebook](#facebook) | `facebook` | A |
| [GitHub](#github) | `github` | A |
| [Microsoft](#microsoft) | `microsoft` | A |
| [X](#x) | `x` | A |
| [LINE](#line) | `line` | A |
| [Discord](#discord) | `discord` | A |
| [LinkedIn](#linkedin) | `linkedin` | A |
| [Slack](#slack) | `slack` | A |
| [Twitch](#twitch) | `twitch` | A |
| [Spotify](#spotify) | `spotify` | A |
| [Steam](#steam) | `steam` | A |
| [Reddit](#reddit) | `reddit` | A |
| [Dropbox](#dropbox) | `dropbox` | B |
| [GitLab](#gitlab) | `gitlab` | B |
| [Bitbucket](#bitbucket) | `bitbucket` | B |
| [PayPal](#paypal) | `paypal` | B |
| [Telegram](#telegram) | `telegram` | B |
| [Instagram](#instagram) | `instagram` | B |
| [WeChat](#wechat) | `wechat` | B |
| [Pinterest](#pinterest) | `pinterest` | B |
| [Snapchat](#snapchat) | `snapchat` | B |
| [VK](#vk) | `vk` | B |
| [Weibo](#weibo) | `weibo` | B |
| [QQ](#qq) | `qq` | B |
| [Epic Games](#epicGames) | `epicGames` | C |
| [PlayStation](#playstation) | `playstation` | C |
| [Nintendo](#nintendo) | `nintendo` | C |
| [Xbox](#xbox) | `xbox` | C |
| [Zoom](#zoom) | `zoom` | C |
| [Kakao](#kakao) | `kakao` | C |
| [Naver](#naver) | `naver` | C |
| [Google](#google) | `google` | C |
| [Apple](#apple) | `apple` | C |
| [TikTok](#tiktok) | `tiktok` | C |
| [Notion](#notion) | `notion` | C |

<a id="facebook"></a>

## 1. Facebook

### Purpose

Facebook Login authenticates a person to an app and can then authorize API
calls on that person's behalf. The official button documentation says that
after the login flow completes, the JavaScript SDK can make API calls for the
person. This is more than a decorative link to Facebook.

### Official sources

- Login/control:
  [developers.facebook.com, login button](https://developers.facebook.com/docs/facebook-login/web/login-button/)
- General brand assets:
  [meta.com, logo](https://www.meta.com/brand/resources/facebook/logo/)
- General logo pack (official CDN; URL may rotate):
  [scontent-ssn1-1.xx.fbcdn.net, Facebook Brand Asset Pack.zip](https://scontent-ssn1-1.xx.fbcdn.net/v/t39.8562-6/380701377_2250872795121673_2315381206050858273_n.zip/Facebook-Brand-Asset-Pack.zip)

### Stated control and brand constraints

- Control wording: **“Continue with Facebook”** replaces earlier Login button
  versions.
- SDK button sizes are named **`small`**, **`medium`**, and **`large`**. The
  public text inspected does not state pixel dimensions, radius, or a full
  interaction-state palette.
- The official Login button is “only designed to work in connection with the
  JavaScript SDK.”
- General logo rules state:
  - current complete logo, not the isolated `f`;
  - primary expression is Facebook Blue with a white `f`;
  - secondary expression is white with a transparent `f`;
  - clear space is **one quarter of the logo width**;
  - minimum digital width is **16 px** and print width is **6 mm**;
  - do not recolor, outline, add effects, make 3D, or alter the complete logo.
- No exact numeric Facebook Blue value is stated on the inspected official
  page. `#0866FF` in the package is therefore not documented here as an
  official login-button color.

### Permission conditions and uncertainty

> “The Login button is a simple way to trigger the Facebook Login process”

> “Meta's trademarks are owned by Meta and may only be used as provided in
> these guidelines or with Meta’s permission.”

The explicit SDK control is an authorized integration use. The brand page also
offers a current logo pack after accepting the applicable guidelines. However,
the inspected pages do not expressly grant copying a standalone Facebook login
logo into a reusable Flutter package. The general-logo warning not to place the
word “Facebook” next to the logo should not be blindly applied to Meta's own
SDK-rendered “Continue with Facebook” control; these are distinct contexts.

### Package status and user caveats

- **Current bundle:** `assets/social/facebook.png`, a pinned Simple Icons-derived package PNG; it is not provider-supplied or an official login control.
- Prefer the provider-rendered SDK control on web.
- On native platforms, follow the platform-specific Facebook Login flow rather
  than pretending the web SDK button is portable.
- A package-built button may launch a valid login flow, but it should not claim
  to reproduce Meta's official control unless it actually uses the current
  provider asset and applicable specification.
- The absence of a standalone login ZIP does **not** establish prohibition; it
  leaves redistribution and a custom Flutter rendering unverified.

---

<a id="github"></a>

## 2. GitHub

### Purpose

GitHub OAuth Apps and GitHub Apps use OAuth 2.0 primarily to authorize access.
GitHub documents a sign-in use case with basic user information, but the OAuth
flow can also request repository and other scopes. It is therefore important to
distinguish “sign in with a GitHub account” from broader GitHub authorization.

### Official sources

- OAuth authorization:
  [docs.github.com, authorizing oauth apps](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps)
- Official logo and trademark guidance:
  [github.com, logos](https://github.com/logos)

### Stated control and brand constraints

- No official login-button wording, dimensions, radius, state colors, or
  login-specific artwork were found in the inspected official sources.
- The primary pictogram is the **Invertocat**.
- The standalone Invertocat is for GitHub-owned environments or places where
  the brand is already clearly established; the wordmark lockup is used in most
  places.
- Marks should appear only in **white**, **black**, or in limited cases
  **grey** or **green**, with sufficient contrast.
- Do not rearrange, add effects, place over busy/low-contrast backgrounds,
  compress, distort, skew, stretch, recolor, or otherwise alter the mark.
- GitHub is one word with capital **G** and **H**.

### Permission conditions and uncertainty

> “Use a permitted GitHub logo to inform others that your project integrates
> with GitHub.”

> “No adaptation or use of any kind of any of our registered trademarks or
> copyrights ... is allowed without the express written permission of GitHub,
> Inc.”

> “Do not use GitHub trademarks, logos, or artwork without GitHub’s prior
> written permission.”

The page expressly lists linking, social-profile links, and showing an
integration as allowed examples, while its legal section broadly reserves
permission. A GitHub OAuth integration can reasonably be described as an
integration, but authentication-button redistribution is not expressly named.
The balanced conclusion is **unclear / permission-sensitive**, not “OAuth logo
use is definitely prohibited.”

### Package status and user caveats

- **Current bundle:** `assets/social/github.png`, a pinned Simple Icons-derived package PNG; it is not provider-supplied or an official login control.
- Treat the package's black surface and white text as a package adaptation, not
  a GitHub OAuth-button standard.
- Request only scopes needed for sign-in. GitHub explicitly distinguishes a
  sign-in-only token from a separate workflow needing private repository access.
- Revalidate the user's identity after every sign-in as GitHub instructs.
- Use a current permitted GitHub mark without modification and avoid implying
  endorsement. For redistributed package artwork, obtain clarification or
  written permission rather than relying only on the “show integration” example.

---

<a id="microsoft"></a>

## 3. Microsoft

### Purpose

The Microsoft identity platform supports authentication for personal and
work/school accounts and authorization to protected APIs. OIDC scopes can return
an ID token for sign-in; OAuth scopes govern API access and consent.

### Official sources

- Sign-in branding and downloadable controls:
  [learn.microsoft.com, howto add branding in apps](https://learn.microsoft.com/en-us/entra/identity-platform/howto-add-branding-in-apps)
- Authorization code flow:
  [learn.microsoft.com, v2 oauth2 auth code flow](https://learn.microsoft.com/en-us/entra/identity-platform/v2-oauth2-auth-code-flow)
- Official dark SVG:
  [learn.microsoft.com, ms symbollockup signin dark.svg](https://learn.microsoft.com/en-us/entra/identity-platform/media/howto-add-branding-in-apps/ms-symbollockup_signin_dark.svg)
- Official light SVG:
  [learn.microsoft.com, ms symbollockup signin light.svg](https://learn.microsoft.com/en-us/entra/identity-platform/media/howto-add-branding-in-apps/ms-symbollockup_signin_light.svg)
- Official logo-only PNG:
  [learn.microsoft.com, ms symbollockup mssymbol 19.png](https://learn.microsoft.com/en-us/entra/identity-platform/media/howto-add-branding-in-apps/ms-symbollockup_mssymbol_19.png)

### Stated control and brand constraints

- Approved wording is **“Sign in with Microsoft”**, or **“Sign in”** when space
  is insufficient.
- Both **light** and **dark** complete-button schemes are supplied in PNG and
  SVG, with long and short variants.
- The logo plus “Sign in with Microsoft” uniquely represents Microsoft Entra ID
  among identity providers.
- Do not alter the Microsoft logo.
- Do not expose end users to the **Azure** or **Active Directory** brands.
  Describe organizational accounts as **“work or school accounts.”**
- The page contains a redline diagram, but its measurements are not exposed as
  textual numeric values. No additional dimensions or state colors are asserted
  here.

### Permission conditions and uncertainty

> “Download the official ‘Sign in’ or ‘Sign in with Microsoft’ images to use in
> your app”

> “To download the official Microsoft logo for use in your app, right-click
> the one you want to use and then save it to your computer.”

> “DON’T alter the Microsoft logo.”

This is an explicit app sign-in use, not merely a general trademark download.
It supports both the supplied complete controls and the separately supplied
four-color symbol for app use. The package preserves the official PNG bytes
unchanged; the symbol still does not turn the shared package geometry into
Microsoft's complete official sign-in control.

### Package status and user caveats

- **Current bundle:** `assets/social/microsoft.png`, a byte-for-byte copy of
  the official 21 × 21 four-color symbol preserved as
  `assets/original/microsoft/ms-symbollockup_mssymbol_19.png`.
- Prefer the complete official SVG/PNG rather than rebuilding it from package
  colors.
- A generic Flutter button using `#2F2F2F` is not automatically the supplied
  official Microsoft control.
- Use OIDC (`openid`) when authentication is required. An access token for an
  API is not a substitute for identity validation.
- Separate ordinary user sign-in from administrator consent/acquisition when
  admin-only permissions or organizational licensing are involved.

---

<a id="x"></a>

## 4. X

### Purpose

X OAuth 1.0a and OAuth 2.0 user context authorize an app to access information
or act on behalf of an X account. The current authentication overview calls
this “authenticate on behalf of another account,” but the inspected sources do
not publish an OIDC identity-verification product or a current visual “Sign in
with X” control.

### Official sources

- Current authentication overview:
  [docs.x.com, overview](https://docs.x.com/fundamentals/authentication/overview.md)
- Brand toolkit:
  [about.x.com, brand resources](https://about.x.com/en_us/company/brand-resources.html)
- Brand Guidelines PDF:
  [about.x.com, x brand guidelines](https://about.x.com/content/dam/about-twitter/x/brand-toolkit/x-brand-guidelines.pdf)

### Stated control and brand constraints

- No login-specific wording, size, shape, radius, or interaction-state rules
  were found in the accessible official text.
- The brand page says to use embed codes when “Publishing a post or button”;
  that statement concerns X publishing/embed controls and is not evidence for
  an authentication button.
- The official PDF was reachable but its body was not text-extractable through
  the available fetcher. Exact logo geometry, clear space, colors, and toolkit
  file formats are therefore **unknown in this review** rather than inferred.

### Permission conditions and uncertainty

> “By using the X trademarks and resources on this site, you agree to follow
> the X Trademark Guidelines in our Brand Guidelines”

> “OAuth 2.0 User Context allows you to authenticate on behalf of another
> account with greater control over an application's scope”

X explicitly supports user-context integration and provides a brand toolkit.
The public text inspected does not expressly approve or prohibit a custom
third-party login button or package redistribution. General trademark
conditions and an authorized OAuth integration must therefore be considered
together; absence of a login-specific kit is not a prohibition.

### Package status and user caveats

- **Current bundle:** `assets/social/x.png`, the unchanged official
  `logo-white.png` member from X's public logo toolkit ZIP. Its origin does not
  make the shared package button an official X authentication control.
- Use the current X toolkit, not legacy Twitter bird artwork.
- Treat the package's black background as a package preset, not a verified X
  login specification.
- Select OAuth 1.0a or OAuth 2.0 user context according to required endpoints
  and scopes; do not describe app-only access as user sign-in.
- Review the PDF manually before shipping a copied asset because exact current
  logo constraints were not recoverable in this pass.

---

<a id="line"></a>

## 5. LINE

### Purpose

LINE Login is an authentication product: the control starts the flow that lets
users log in to an application with LINE.

### Official sources

- Login button design:
  [developers.line.biz, login button](https://developers.line.biz/en/docs/line-login/login-button/)
- Binding usage guidelines:
  [terms2.line.me, LINE Developers Guidelines for Login Button](https://terms2.line.me/LINE_Developers_Guidelines_for_Login_Button)
- Official template ZIP:
  [vos.line-scdn.net, LINE Login Button Image.zip](https://vos.line-scdn.net/line-developers/docs/media/line-login/login-button/LINE_Login_Button_Image.zip)

### Stated control and brand constraints

- Recommended English wording: **“Log in with LINE”**; short form:
  **“Log in”**.
- Recommended Korean wording: **“LINE으로 로그인”**; short form:
  **“로그인”**.
- Custom text must not wrap and must clearly indicate login with LINE.
- A logo-only LINE Login button is expressly allowed.
- Base: **`#06C755`**.
- Hover: base plus **`#000000` at 10% opacity**.
- Press: base plus **`#000000` at 30% opacity**.
- Disabled base: **`#FFFFFF`**.
- Normal logo/text: **`#FFFFFF`**.
- Disabled logo/text: **`#1E1E1E` at 20% opacity**.
- Normal separator: **`#000000` at 8% opacity**.
- Disabled separator and border: **`#E5E5E5` at 60% opacity**.
- Scaling is allowed only while preserving the icon aspect ratio and legibility.
- Horizontal text padding is at least one icon-speech-bubble width (**X**);
  recommended vertical padding is at least **X/2**.
- Isolation space is at least the left padding of the icon speech bubble.
- Do not use non-designated colors, outdated or modified icons, multi-line
  text, or a size/quality that harms legibility.

### Permission conditions and uncertainty

> “The Company grants permission to the Installer to install the LINE Login
> Button and to use the LINE Login Button Image free of charge”

> “The LINE Login Button Image may only be used for the purpose of installing
> the LINE Login Button or as a text link icon.”

Permission is explicit but purpose-limited and conditional on the guidelines.
Downloading or installing is deemed acceptance. The image may not become an app
icon, package brand, profile image, background, or link to an unrelated service.
Whether a general-purpose package may redistribute a cropped member of the ZIP
for downstream installers is not separately spelled out; preserve the original
archive and terms evidence.

### Package status and user caveats

- **Current bundle:** `assets/social/line.png`.
- The provider renderer uses LINE's verified white foreground, separator,
  hover, pressed, disabled, and disabled-border values.
- This remains a package-rendered common button. Use the complete official
  template when the provider's exact complete-control geometry is required.
- Link the control only to LINE Login and update it when LY Corporation requests
  an asset change.

---

<a id="discord"></a>

## 6. Discord

### Purpose

Discord OAuth2 authorizes apps to access Discord data and integrations.
`identify` returns basic user information and can support account sign-in;
other scopes install bots, add commands, join guilds, create webhooks, or access
additional data. Those integration flows should not all be labeled “login.”

### Official sources

- OAuth2:
  [discord.com, oauth2](https://discord.com/developers/docs/topics/oauth2)
- Brand guidance:
  [discord.com, branding](https://discord.com/branding)
- Official full-logo SVG:
  [cdn.prod.website-files.com, 6762811c5036d0e1a924c424 Logo.svg](https://cdn.prod.website-files.com/6257adef93867e50d84d30e2/6762811c5036d0e1a924c424_Logo.svg)
- Official symbol SVG:
  [cdn.prod.website-files.com, 6762812affa5eaf1bedc0c42 Symbol.svg](https://cdn.prod.website-files.com/6257adef93867e50d84d30e2/6762812affa5eaf1bedc0c42_Symbol.svg)

### Stated control and brand constraints

- No official login-button wording, dimensions, radius, or interaction-state
  specification was found.
- Official colors listed are **Blurple `#5865F2`**, **Light Blurple `#E0E3FF`**,
  and **Black `#000000`**. These are general brand colors, not OAuth-button
  state tokens.
- The logo may be used in color, black, or white.
- Use the symbol only when Discord is already clearly visible or established.
- Do not edit, change, distort, recolor, or reconfigure the logo.
- Permitted public uses are digital-only and must not imply that the user or
  product is Discord, sponsored by Discord, or acting for Discord.

### Permission conditions and uncertainty

> “Feel free to use our logo in color, black or white.”

> “You must have permission from Discord before using any of the Discord Marks
> or Brand Assets except as permitted here.”

> “Use the Discord Marks to inform people that you are a Discord user and/or
> that you have a Discord server”

The page offers official SVGs and specifies some public digital uses. OAuth2 is
an explicit developer integration, but a reusable authentication-button asset
is not expressly named. This is **unclear for package redistribution**, not a
finding that all Discord login-logo use is forbidden.

### Package status and user caveats

- **Current bundle:** `assets/social/discord.png`, a pinned Simple Icons-derived package PNG; it is not provider-supplied or an official login control.
- `#5865F2` is verified as Blurple but not as an OAuth-button background.
- For sign-in, request `identify` and only any additionally needed scopes.
  Several scopes require partner approval.
- Always generate and verify OAuth `state`; Discord strongly recommends it.
- A symbol-only button needs nearby context that clearly identifies Discord.

---

<a id="linkedin"></a>

## 7. LinkedIn

### Purpose

Sign In with LinkedIn uses OIDC to authenticate a member and return a lite
profile. LinkedIn explicitly says this does **not** verify the person's real
identity and must not be marketed as identity verification.

### Official sources

- OIDC sign-in:
  [learn.microsoft.com, sign in with linkedin v2](https://learn.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin-v2)
- Brand guidance:
  [brand.linkedin.com, en us](https://brand.linkedin.com/en-us)
- Approved logo downloads:
  [brand.linkedin.com, downloads](https://brand.linkedin.com/downloads)

### Stated control and brand constraints

- No current official button label, pixel dimensions, radius, state colors, or
  sign-in-specific artwork were found in the accessible official text.
- The approved download page exposes the **`[in]` Logo** and **LinkedIn Logo**.
- Use only approved assets from LinkedIn's official site.
- Do not create confusion about source, sponsorship, affiliation, or
  endorsement, and do not imitate the LinkedIn platform's overall look and feel.
- No numeric LinkedIn login palette is asserted here.

### Permission conditions and uncertainty

> “By downloading our logos, you agree to comply with the terms of the LinkedIn
> Brand and User Agreements.”

> “Our Brand may only be used as outlined in these guidelines or with express
> written permission”

> “Sign In with LinkedIn using OpenID Connect does not verify user identities
> and should not be marketed as such.”

LinkedIn expressly offers OIDC sign-in and approved logo downloads under its
agreements. The accessible public pages do not expressly define a third-party
button or grant package redistribution. That gap is **unknown**, not proof that
using an approved LinkedIn mark to identify the documented integration is
prohibited.

### Package status and user caveats

- **Current bundle:** `assets/social/linkedin.png`, the unchanged official
  `in-logo/InBug-White.png` member from LinkedIn's approved download ZIP.
  Package redistribution remains subject to the linked Brand and User
  Agreements and is not separately stated.
- Request the “Sign in with LinkedIn using OpenID Connect” product in the
  Developer Portal and use `openid`; `profile` and `email` return their stated
  claims.
- `email` and `email_verified` may be absent.
- Never market the login as proof of a member's real-world identity.
- The package's blue preset and “Continue with LinkedIn” wording are not
  verified as an official control specification.

---

<a id="slack"></a>

## 8. Slack

### Purpose

Sign in with Slack is explicitly an OIDC authentication flow for logging into a
service with a Slack profile. It is separate from ordinary Slack app
installation OAuth; Slack says the OIDC scopes and non-sign-in scopes must be
requested in separate OAuth flows.

### Official sources

- Current Sign in with Slack and visual specification:
  [docs.slack.dev, sign in with slack](https://docs.slack.dev/authentication/sign-in-with-slack/)
- Official button generator:
  [api.slack.com, sign in with slack button generator](https://api.slack.com/sign-in-with-slack-button-generator)
- General brand assets and terms:
  [slack.com, brand guidelines](https://slack.com/brand-guidelines)

### Stated control and brand constraints

- Prefer the official generator. A custom or modified button should:
  - be prominent and above the fold;
  - always include the Slack logo;
  - say exactly **“Sign in with Slack”**, capitalizing `S`;
  - match the size of other sign-in options.
- Full button sizes:
  - maximum **296 × 56 px**, **18 px Lato bold**, logo **24 × 24 px**;
  - default **256 × 48 px**, **16 px Lato bold**, logo **20 × 20 px**;
  - minimum **224 × 44 px**, **14 px Lato bold**, logo **16 × 16 px**.
- Logo spacing is **12 px** when center-aligned or **16 px left margin** when
  border-aligned.
- Icon-only sizes:
  - maximum **56 × 56 px**, logo **28 × 28 px**;
  - default **48 × 48 px**, logo **24 × 24 px**;
  - minimum **36 × 36 px**, logo **18 × 18 px**.
- Corner radius may range from **4 px** to **the full button height**.
- The retrieved page contained additional color-theme guidance after the
  inspected section, but the response was truncated. Exact theme colors are
  therefore not repeated here without complete source verification.

### Permission conditions and uncertainty

> “You should use our button generator to create a Sign in with Slack button.”

> “But if you need to modify that button or create your own, here are some
> basic design guidelines you should follow”

> “By using the Slack marks you agree to follow these guidelines as well as our
> Terms of Service”

Slack explicitly permits a generator-produced button and contemplates a custom
one that follows the specification. That is stronger than merely having a
general brand kit. The inspected text still does not state that a package may
redistribute Slack's source logo files to unrelated downstream apps.

### Package status and user caveats

- **Current bundle:** `assets/social/slack.png` for the default/dark appearance
  and `assets/social/slack-light.png` for the light appearance. Both are pinned
  Simple Icons-derived package PNGs; neither is provider-supplied or an
  official login control.
- The package's `#4A154B` preset is not documented here as a verified
  Sign in with Slack state color.
- Use `/openid/connect/authorize` with `openid` and optional `profile`/`email`,
  not the ordinary installation endpoint.
- Do not combine Sign in with Slack scopes with non-sign-in Slack scopes in one
  flow.
- If a custom Flutter button cannot meet the measured variants, wording, logo,
  spacing, and visibility rules, use generated artwork rather than calling it
  an official Slack button.

---

<a id="twitch"></a>

## 9. Twitch

### Purpose

Twitch OAuth grants access to Twitch resources. User access tokens authorize
API actions; app access tokens represent an app. Twitch also documents OIDC
flows returning an ID token specifically for signing users in. An ID token
cannot replace an access token for Twitch API calls.

### Official sources

- Authentication overview:
  [dev.twitch.tv, authentication](https://dev.twitch.tv/docs/authentication/)
- Brand asset portal:
  [brand.twitch.tv, official source](https://brand.twitch.tv/)
- Trademark guidelines:
  [twitch.tv, trademark](https://www.twitch.tv/p/en/legal/trademark/)

### Stated control and brand constraints

- No official login-button wording, dimensions, radius, state palette, or
  login-specific asset was found in accessible public text.
- The asset portal was reachable but exposed only its title/intro through the
  text fetcher; exact downloadable file URLs and formats remain **unknown**.
- Do not modify or alter Twitch assets, including color or design.
- Do not imply affiliation, partnership, sponsorship, or endorsement.
- Exact Twitch Purple is not asserted here because it was not stated in the
  official pages successfully extracted in this pass.

### Permission conditions and uncertainty

> “We support and encourage ideas, services, tools and other creative works
> that use and supplement Twitch Brand Assets”

> “If there is express language on this page stating that you can use particular
> Twitch Brand Assets, advance written permission is not necessary.”

> “We generally do not approve the use of the Twitch logos in third-party
> marketing materials.”

The marketing restriction includes websites and demos, but an OAuth/OIDC
control is also part of an expressly supported developer integration and is not
specifically analyzed by the trademark page. The correct conclusion is
**permission-sensitive / unresolved for a reusable login asset**, not a blanket
statement that Twitch authentication buttons are prohibited.

### Package status and user caveats

- **Current bundle:** `assets/social/twitch.png`, the unchanged official flat
  white Glitch PNG from `Twitch-Brand.zip`. Authentication-package
  redistribution remains permission-sensitive under the linked trademark
  guidance.
- Use OIDC and validate the ID token when sign-in is the goal; use a user access
  token with scopes for API authorization.
- Third-party apps maintaining OAuth sessions must call Twitch's `/validate`
  endpoint.
- Treat package purple as an unverified preset, not a Twitch login requirement.
- Before bundling, obtain a current asset from the official portal and confirm
  the intended authentication use with Twitch if the public terms remain
  ambiguous.

---

<a id="spotify"></a>

## 10. Spotify

### Purpose

Spotify describes its OAuth 2.0 product as **authorization**: users grant access
to Spotify data and features. The inspected source does not present Spotify
OAuth as a general OIDC or identity-verification login service.

### Official sources

- Authorization:
  [developer.spotify.com, authorization](https://developer.spotify.com/documentation/web-api/concepts/authorization)
- Developer design and brand assets:
  [developer.spotify.com, design](https://developer.spotify.com/documentation/design)
- Official full-logo SVG:
  [developer-assets.spotifycdn.com, logo.svg](https://developer-assets.spotifycdn.com/images/guidelines/design/logo.svg)
- Official icon SVG:
  [developer-assets.spotifycdn.com, icon1.svg](https://developer-assets.spotifycdn.com/images/guidelines/design/icon1.svg)

### Stated control and brand constraints

- No login-specific wording, button measurements, shape, or interaction-state
  colors were found.
- For partner integrations, use the **full logo**; use the icon alone only when
  there is insufficient room or the Spotify brand is already established.
- Spotify Green logo: only on black, white, or non-duotone photography.
- On other backgrounds use monochrome; black on light backgrounds and white on
  dark backgrounds.
- Exclusion space equals **half the icon height**.
- Minimum digital sizes: full logo **70 px**, icon **21 px**. Print minimums are
  **20 mm** and **6 mm**, respectively.
- Do not rotate, fill the logo lines, stretch/alter the shape, use it as a
  letter, make new shapes, or place it in busy/low-contrast areas.
- `#191414` is stated only as a playback-view background fallback when artwork
  color extraction is unavailable. It is **not** a login-button token.
- The official page names Spotify Green but does not state a numeric value in
  the extracted text, so no exact green value is asserted here.

### Permission conditions and uncertainty

> “We want to make it easy for you to integrate Spotify in your platform while
> respecting our brand and legal/licensing restrictions.”

> “By using these resources, you accept our Developer Terms of Service.”

The developer page explicitly supplies assets for Spotify integrations.
However, it does not define a Spotify login control or say that those files may
be redistributed in a general UI package. An integration may use the official
assets within the stated rules; package-level redistribution remains unclear.

### Package status and user caveats

- **Current bundle:** `assets/social/spotify.png`, a faithful 128×128
  resize of Spotify's standalone black PNG from its official
  [Logo and Brand Assets](https://newsroom.spotify.com/media-kit/logo-and-brand-assets/).
  The full transparent original is preserved; no demonstration frame is included.
- Do not claim that Spotify OAuth is identity verification or OIDC login.
- For mobile, desktop, or browser code that cannot protect a secret, Spotify
  recommends Authorization Code with PKCE.
- A 24 px logo slot can fit the 21 px minimum icon, but cannot fit the 70 px
  minimum full logo. Use of the icon still depends on the contextual rule.
- The package's `#1ED760` background and “Connect Spotify” text are
  package choices, not a verified Spotify authentication-button design.

---

<a id="steam"></a>

## 11. Steam

### Purpose

Steam supports several authentication mechanisms. For a third-party website,
Steam is an **OpenID 2.0 Provider** that returns a SteamID for authentication or
account linking. Steamworks session tickets and encrypted tickets serve game,
peer, server, backend, and ownership-verification scenarios; they are not
interchangeable with the browser sign-in control.

### Official sources

- Authentication and browser OpenID control:
  [partner.steamgames.com, auth](https://partner.steamgames.com/doc/features/auth#website)
- Large bordered PNG:
  [shared.fastly.steamstatic.com, sits large border.png](https://shared.fastly.steamstatic.com/community_assets/images/steamworks_docs/english/sits_large_border.png)
- Large borderless PNG:
  [shared.fastly.steamstatic.com, sits large noborder.png](https://shared.fastly.steamstatic.com/community_assets/images/steamworks_docs/english/sits_large_noborder.png)
- Small PNG:
  [shared.fastly.steamstatic.com, sits small.png](https://shared.fastly.steamstatic.com/community_assets/images/steamworks_docs/english/sits_small.png)

### Stated control and brand constraints

- Steam provides exactly three complete images on the authentication page:
  `sits_large_border.png`, `sits_large_noborder.png`, and `sits_small.png`.
- The page does not state their pixel dimensions, color tokens, radius,
  interaction states, translation rules, or permission to modify them.
- The images are specifically for linking to the **Steam sign-in page**.

### Permission conditions and uncertainty

> “Steam provides the following images which may be used by 3rd party sites
> when linking to the Steam sign in page”

This is an explicit third-party authentication use and is stronger than a
general press-kit download. The public sentence does not expressly address
repackaging the PNGs inside a reusable library or modifying/cropping them into a
logo-only common button. Preserve and use a complete supplied image for its
stated link purpose; seek clarification before redistribution.

### Package status and user caveats

- **Current bundle:** `assets/social/steam.png`, a pinned Simple Icons-derived package PNG; it is not provider-supplied or an official login control.
- Use the complete Steam image for browser OpenID rather than extracting its
  logo into the package's generic circular treatment.
- Steam OpenID 2.0 returns a SteamID; it does not provide the same claims model
  as OIDC.
- Ownership checks require the relevant Steamworks Web API step after identity
  is established.
- The package's black surface and “Continue with Steam” wording are not stated
  Steam control rules.

---

<a id="reddit"></a>

## 12. Reddit

### Purpose

Reddit OAuth authorizes access to Reddit APIs on behalf of a user or app. The
official archived Reddit OAuth wiki says OAuth2 can authenticate users on
non-Reddit apps, but it is an archived source rather than current product
documentation. Treat current sign-in positioning as uncertain and scope API
access minimally.

### Official sources

- Current brand page:
  [redditinc.com, brand](https://redditinc.com/brand)
- Current trademark policy:
  [redditinc.com, trademark use policy](https://www.redditinc.com/policies/trademark-use-policy)
- Official archived OAuth2 documentation:
  [github.com, OAuth2](https://github.com/reddit-archive/reddit/wiki/OAuth2)
- Current brand-guideline portal linked by Reddit:
  [reddit.lingoapp.com, oYYL4W](https://reddit.lingoapp.com/k/oYYL4W)

### Stated control and brand constraints

- No current official login-button wording, dimensions, shape, or state palette
  was found.
- The current logo is a stylized Snoo head inside an **OrangeRed `#FF4500`**
  conversation bubble, typically paired with the Reddit wordmark.
- The Reddit icon should appear on marketing and communications about Reddit.
  That statement is not itself an authentication-control specification.
- No package-safe standalone asset URL or file format was exposed in the
  accessible current brand-page text.

### Permission conditions and uncertainty

> “OAuth2 support allows you to use reddit to authenticate on non-reddit
> websites and applications.” , official archived Reddit wiki

> “you must have our permission to use Reddit’s trademarks and other brand
> assets, including as authorized under our brand guidelines”

> “You may only use Reddit trademarks and brand assets in accordance with our
> brand guidelines and this policy or as otherwise permitted by Reddit in
> writing.”

The archived integration text establishes historical authentication use; the
current trademark policy allows uses authorized by the current brand
guidelines. The accessible sources do not expressly connect a current logo
asset to a login button or package redistribution. This is **unknown /
permission-sensitive**, not proof that Reddit login branding is prohibited.

### Package status and user caveats

- **Current bundle:** `assets/social/reddit.png`, a pinned Simple Icons-derived package PNG; it is not provider-supplied or an official login control.
- `#FF4500` is verified as OrangeRed for the current logo, not as an OAuth-button
  background or state color.
- Because the detailed OAuth source is an official archive, verify current
  endpoints, app-registration policy, and platform access requirements before
  implementation.
- Request only needed scopes, preserve and validate `state`, and do not imply
  Reddit endorsement.
- Obtain an approved current asset from the linked brand portal before shipping
  artwork; do not extract a runtime image or treat the package's generic button
  as official Reddit UI.

<a id="dropbox"></a>

## 13. Dropbox

### Purpose and official control

- **Purpose:** authorization first. Dropbox says the app accesses Dropbox
  “on behalf of your users”; users sign in at Dropbox to grant access and the
  app receives an access token. This is not a published Dropbox identity/OIDC
  login-button contract.
- OAuth guide:
  [developers.dropbox.com, oauth guide](https://developers.dropbox.com/oauth-guide)
- Official login/control documentation: **none found in the bounded official
  review**. The OAuth guide instructs an app to present the authorization URL;
  it does not specify a reusable “Continue with Dropbox” control.
- Brand asset page:
  [brand.dropbox.com, logo](https://brand.dropbox.com/logo)
- Color page:
  [brand.dropbox.com, color](https://brand.dropbox.com/color)
- Asset URL/format: the official logo page is the asset source, but the
  accessible page did not expose a stable standalone download URL or file
  format.

### Stated visual constraints

- The full logo consists of the glyph and word mark.
- The Tab combines the glyph with a plane and is “most often accompanied by
  the word mark somewhere in the composition.”
- The color page names **Dropbox Blue**, **Coconut**, and **Graphite** as core
  colors, but exposed no numeric values relevant to a login control.
- No official login wording, size, radius, border, or interaction-state rule
  was found.

### Permission and uncertainty

> “The Dropbox logo is made up of two elements: the glyph and the word mark.”

> “The Tab is a combination of the glyph within a plane. It’s most often
> accompanied by the word mark somewhere in the composition.”

The accessible brand pages explain composition, not third-party package
redistribution. The previously plausible Dropbox trademark-help URL returned
an official 4xx page during this review. Therefore redistribution is
**unclear**, not proved prohibited and not proved licensed.

### Package-user caveats

- The current `#0061FF` background is a package preset supported only by the
  package's secondary palette reference, not a numeric login color verified
  on the official color page.
- Do not treat the Tab or bare glyph as an official social-login icon.
- An app using Dropbox OAuth should request least privilege; Dropbox explicitly
  says, “Always ask for the least amount permissions required.”

<a id="gitlab"></a>

## 14. GitLab

### Purpose and official control

- **Purpose:** both authentication and delegated authorization. GitLab states
  that it can be an OAuth 2 authentication identity provider and can enable
  users to sign in to another application; broader scopes authorize GitLab API
  access.
- OAuth provider documentation:
  [docs.gitlab.com, oauth provider](https://docs.gitlab.com/integration/oauth_provider/)
- Official login/control documentation: the OAuth provider page documents the
  flow, scopes, and endpoints, but no official login-button artwork or visual
  control.
- Brand and asset sources:
  - [about.gitlab.com, press kit](https://about.gitlab.com/press/press-kit/)
  - [design.gitlab.com, core logo](https://design.gitlab.com/brand-logo/core-logo/)
  - Direct official logomark SVG:
    [about.gitlab.com, gitlab logo 500 rgb.svg](https://about.gitlab.com/images/press/gitlab-logo-500-rgb.svg)
- Permission source:
  [handbook.gitlab.com, trademark guidelines](https://handbook.gitlab.com/handbook/marketing/brand-and-product-marketing/brand/brand-activation/trademark-guidelines/)

### Stated visual constraints

- Core-logo clear space equals the x-height of the wordmark's letter `a`.
- Minimum size is **20 px digital** and **0.4 in (11 mm) print**.
- Full-color is the default; white or charcoal one-color variants are for
  restricted single-color use or established brand-awareness contexts.
- The wordmark cannot be used independently from the logomark.
- The source says not to stroke, recolor, transform, rearrange, shadow, rotate,
  distort, frame imagery with, or place the logo in running text.
- These are general-logo constraints, not login-button colors, dimensions,
  wording, or states.

### Permission and uncertainty

> “Use of the Logos is not permitted under these Guidelines, except for the
> limited purpose set out in Section 3.1.”

Section 3.1 permits retaining marks already included when distributing an
unmodified copy of GitLab CE. That exception does not cover bundling a press-kit
logo in this Flutter package. GitLab permits truthful use of the **name** for
compatibility/integration subject to attribution and other conditions, but
logo use needs another applicable agreement or permission. This is an express
restriction, not merely a missing grant.

### Package-user caveats

- A press-kit download is not permission to redistribute it as package login
  artwork.
- The package's orange/black combination is not an official GitLab login
  palette.
- For actual sign-in, use the OAuth/OIDC scopes needed by the app; `openid`,
  `profile`, and `email` are identity scopes, while `api` grants broad
  read/write API access.

<a id="bitbucket"></a>

## 15. Bitbucket

### Purpose and official control

- **Purpose:** OAuth 2 authorization to Bitbucket Cloud resources. The
  `email` scope says it “should make it easier to use Bitbucket Cloud as a
  login provider,” and `account` exposes account information, so a client can
  build login on the authorized identity; the documentation is primarily an
  API-authorization contract.
- OAuth documentation:
  [developer.atlassian.com, oauth 2](https://developer.atlassian.com/cloud/bitbucket/oauth-2/)
- Official login/control documentation: no Bitbucket login-button visual
  specification found.
- Brand asset source:
  [atlassian.design, logos](https://atlassian.design/foundations/logos/)
- Direct official asset packages:
  - App logo:
    [atlassian.design, bitbucket app.zip](https://atlassian.design/assets/599d0f58b052/logos/bitbucket_app.zip)
  - Attribution logo:
    [atlassian.design, bitbucket attribution.zip](https://atlassian.design/assets/599d0f58b052/logos/bitbucket_attribution.zip)
- Trademark conditions:
  [atlassian.com, trademark](https://www.atlassian.com/legal/trademark)

### Stated visual constraints

- Use the app logo when Atlassian context is clear; use the attribution logo
  when the app needs to be connected to Atlassian.
- Downloaded packages include isolated logomarks and wordmark lockups.
- A lone logomark is for very clear contexts and should be paired with
  descriptive text where possible.
- The logo component's logomark has a predefined radius that should not be
  altered, and “Logomarks should never be nested inside additional
  containers.”
- The source supplies approved variations but states no Bitbucket login
  wording, login size, interaction states, or numeric color pair.

### Permission and uncertainty

> “This page includes downloadable logo files for use in marketing contexts
> as well as specific usage guidance for app or marketing contexts.”

> “While authorized Atlassian partners and vendors may use Atlassian
> trademarks and logos, subject to these and any other applicable Guidelines,
> to promote Atlassian and identify compatibility, any such permissible use
> does not confer any ownership.”

The design site expressly supplies assets for specified contexts, but the
review found no public text expressly extending that use to redistribution
inside a generic login-button package. Status is **unclear**, not prohibited by
absence of a grant and not unlimited because a ZIP is downloadable.

### Package-user caveats

- **Current bundle:** `assets/social/bitbucket.png`, the unchanged
  `Bitbucket/PNG@2x/Bitbucket_icon.png` member from the provider-owned app-logo
  ZIP. Its origin does not make the shared button an official OAuth control.
- A circular wrapper conflicts with the current app-logomark rule against an
  additional container.
- Choose app versus attribution artwork by context; neither is documented as
  an OAuth button.
- Request only needed OAuth scopes. Bitbucket's current page says the implicit
  grant and resource-owner-password grant are no longer supported.

<a id="paypal"></a>

## 16. PayPal

### Purpose and official control

- **Purpose:** PayPal's official product is titled **Log in with PayPal** and
  is intended as a user login/identity integration. The current developer page
  was reachable, but its content was reduced to the PayPal cookie notice in
  this review, so current scopes and UI behavior could not be independently
  quoted.
- Login documentation:
  [developer.paypal.com, log in with paypal](https://developer.paypal.com/docs/log-in-with-paypal/)
- Attempted child pages, also without extractable documentation body:
  - [developer.paypal.com, integrate](https://developer.paypal.com/docs/log-in-with-paypal/integrate/)
  - [developer.paypal.com, reference](https://developer.paypal.com/docs/log-in-with-paypal/reference/)
- Brand asset source:
  [newsroom.paypal-corp.com, media resources](https://newsroom.paypal-corp.com/media-resources)
- Direct official PNGs:
  - Black primary logo:
    [newsroom.paypal-corp.com, PayPal Logo Black 3x2.png](https://newsroom.paypal-corp.com/image/PayPal_Logo_Black_3x2.png)
  - White primary logo:
    [newsroom.paypal-corp.com, PayPal Logo White 3x2.png](https://newsroom.paypal-corp.com/image/PayPal_Logo_White_3x2.png)
  - Full-color monogram:
    [newsroom.paypal-corp.com, PayPal Monogram FullColor 3x2.png](https://newsroom.paypal-corp.com/image/PayPal_Monogram_FullColor_3x2.png)

### Stated visual constraints

- The newsroom labels the available assets **PayPal Primary Logo Black**,
  **PayPal Primary Logo White**, and **PayPal Monogram**.
- No extractable official login wording, numeric colors, dimensions, shape,
  border, or interaction-state specification was available.
- The newsroom's 3x2 filenames describe media framing, not an approved login
  button ratio.

### Permission and uncertainty

> “From brand logos to our latest research, we have the assets to support your
> story.”

That newsroom language supplies press/media assets, but it does not state that
the files may be repackaged as authentication UI. The inaccessible developer
body prevents a stronger current login-control conclusion. Redistribution is
**unclear**: availability is not an unlimited license, while the missing grant
is not proof of prohibition.

### Package-user caveats

- Do not infer that newsroom black/white logos are official “Log in with
  PayPal” button assets.
- The package's `#002991` background and all states are package presets, not a
  verified PayPal login specification.
- Re-check the logged-in developer portal or a provider contact before
  shipping PayPal artwork in an app or package.

<a id="telegram"></a>

## 17. Telegram

### Purpose and official control

- **Purpose:** current Telegram Login is authentication via OpenID Connect. It
  can additionally authorize `profile`, `phone`, and
  `telegram:bot_access`; those optional scopes should not be conflated with
  bare authentication.
- Current login documentation and customization tool:
  [core.telegram.org, login](https://core.telegram.org/widgets/login)
- OIDC discovery:
  [oauth.telegram.org, openid configuration](https://oauth.telegram.org/.well-known/openid-configuration)
- Archived legacy widget:
  [core.telegram.org, login legacy](https://core.telegram.org/widgets/login-legacy)
- Brand/login asset URL: no standalone official login artwork was verified.
  The current page provides a compact customization tool/library, plus official
  native SDK links, which render or initiate the control.

### Stated visual constraints

- Current docs describe a customizable login button but the accessible text
  did not expose fixed colors, dimensions, radius, labels, or interaction
  states.
- Telegram strongly recommends that the bot profile picture correspond to the
  website logo and that the bot name reflect the connection.
- No standalone Telegram logo rule can be inferred from the generated control.

### Permission and uncertainty

> “Telegram offers a compact tool to quickly add Telegram login buttons to
> your interface.”

> “For mobile developers, we also provide ready-to-use Native SDKs for iOS and
> Android.”

This expressly supports using the provider library/generated control for
Telegram Login. It does not expressly grant redistribution of a copied logo
inside this package. Generated-control use is **permitted for the documented
integration**; standalone asset redistribution remains **unclear**.

### Package-user caveats

- Prefer OIDC, the Telegram Login library, or an official native SDK over a
  reconstructed logo button.
- Validate the ID token server-side. Telegram says to verify signature,
  issuer, audience, and expiry.
- `phone` requires user consent; `telegram:bot_access` permits bot messages.
- The current package blue, black text, translated label, and widget states
  are not provider-approved control values.

<a id="instagram"></a>

## 18. Instagram

### Purpose and official control

- **Purpose:** authorization/integration for **Instagram professional
  accounts**, not general consumer identity login. Business Login asks for
  permissions and returns a token for Instagram API operations such as media,
  comments, insights, and messaging.
- Platform overview:
  [developers.facebook.com, instagram api with instagram login](https://developers.facebook.com/docs/instagram-platform/instagram-api-with-instagram-login/)
- Business Login:
  [developers.facebook.com, business login](https://developers.facebook.com/documentation/instagram-platform/instagram-api-with-instagram-login/business-login)
- Brand source and logo-pack control:
  [meta.com, instagram brand](https://www.meta.com/brand/resources/instagram/instagram-brand/)
- Official pack URL exposed on the brand page (Meta CDN URL may rotate):
  [scontent-ssn1-1.xx.fbcdn.net, IG brand asset pack 2023.zip](https://scontent-ssn1-1.xx.fbcdn.net/v/t39.8562-6/10000000_295565596234104_6752419821643487968_n.zip/IG_brand_asset_pack_2023.zip?sdl=1)

### Stated visual constraints

- Business Login tells developers to paste the generated **Embed URL** into an
  anchor or button; it does not specify a branded button's visual design.
- The brand page says to keep the `I` in Instagram capitalized and at the same
  font size/style as surrounding text.
- Do not modify, abbreviate, or translate “Instagram,” replace it with a logo,
  combine `Insta`/`gram` with another brand, or imply partnership,
  sponsorship, or endorsement.
- No official login color, dimension, shape, border, or interaction-state rule
  was found.

### Permission and uncertainty

> “Anyone using Instagram’s assets should only use the logos and screenshots
> found on our Brand Resource Center site and follow these guidelines.”

> “Only those planning to use Instagram’s assets in any broadcast, radio,
> out-of-home advertising or print larger than 8.5 x 11 inches (A4 size) need
> to request permission.”

> “I have read and accept the applicable guidelines and other terms for use.”

The page permits guideline-compliant asset use and identifies when a separate
request is needed, but the download acceptance and brand rules do not expressly
grant repackaging in a software package. Package redistribution remains
**unclear**; it is not automatically forbidden and not an unlimited license.

### Package-user caveats

- Do not market this API as generic “Instagram account login.” It is for
  businesses and creators.
- Use current `instagram_business_*` scopes; the older `business_*` names were
  deprecated on 2025-01-27.
- The package's `#FF0069`, black text, Korean translation, and interaction
  states are not official Business Login specifications.

<a id="wechat"></a>

## 19. WeChat

### Purpose and official control

- **Purpose:** OAuth 2.0 authorized login. It logs a Weixin user into an
  approved third-party website app and authorizes access-token-backed API
  calls for permitted user information.
- Website App login and embedded QR control:
  [developers.weixin.qq.com, Wechat Login](https://developers.weixin.qq.com/doc/oplatform/en/Website_App/WeChat_Login/Wechat_Login.html)
- Authorized-interface details:
  [developers.weixin.qq.com, Authorized Interface Calling UnionID](https://developers.weixin.qq.com/doc/oplatform/Website_App/WeChat_Login/Authorized_Interface_Calling_UnionID.html)
- General brand source:
  [wechat.design, main brand](https://wechat.design/brand/main-brand)
- Asset URL/format: no standalone official login-logo file was verified. The
  official JS renders the QR login surface.

### Stated visual constraints

- Embedded QR login `style` is `black` or `white`; black descriptive text is
  the default for light backgrounds and white text is for dark backgrounds.
- An `href` may point to a custom stylesheet and the FAQ expressly gives
  reducing an overly large QR code as an example.
- General-brand guidance recommends the white speech-bubble logo on grey
  backgrounds other than 10% black; on colored/image backgrounds it recommends
  a simpler monochrome logo in 80% black or white. These are general-logo
  rules, not compact login-button tokens.
- No fixed login wording, dimensions, radius, or interaction states were
  stated.

### Permission and uncertainty

> “We allow websites to embed Weixin login QR codes in their webpages.”

> “Third parties can replace the default style as needed.”

These statements permit the documented embedded control and its CSS
customization. They do not state that a standalone WeChat logo may be extracted
and redistributed. Provider-rendered/control use is **permitted**;
standalone-asset redistribution is **unclear**.

### Package-user caveats

- The website app must be reviewed and approved before use; `snsapi_login` is
  the website scope.
- Prefer the JS-rendered QR surface. A circular Flutter icon is not equivalent
  to that control.
- The package's `#07C160`, black text, translated label, and state colors are
  package presets, not verified QR-control values.

<a id="pinterest"></a>

## 20. Pinterest

### Purpose and official control

- **Purpose:** Pinterest's developer flow is OAuth/API authorization. The
  attempted current official authentication URLs returned no extractable body,
  so a current login-as-identity claim could not be verified.
- Attempted official authorization pages:
  - [developers.pinterest.com, authentication](https://developers.pinterest.com/docs/getting-started/authentication/)
  - [developers.pinterest.com, authorization](https://developers.pinterest.com/docs/getting-started/authorization/)
- Brand guidelines:
  [business.pinterest.com, brand guidelines](https://business.pinterest.com/en/brand-guidelines/)
- Official logo asset portal:
  [pinterest-assets.com, 2THWMKDBK3GQ](https://www.pinterest-assets.com/asset-management/2THWMKDBK3GQ?WS=AssetManagement&Flat=y&FR_=1&W=1504&H=694)
- Official login/control documentation: none verified.

### Stated visual constraints

- For the documented marketing use, use only the Pinterest badge, not the
  wordmark, and include a call to action.
- The primary logo is a white script `P` in a red circle; black or white is
  allowed when color is limited.
- Use the supplied EPS and high-resolution PNG assets.
- Do not outline the logo, add filters/effects, remove the `P` from the
  circle, or alter the logo color.
- These are presence-marketing rules. They do not state OAuth-button wording,
  dimensions, radius, or states, and no numeric red value is stated.

### Permission and uncertainty

> “These guidelines are for businesses promoting their presence on Pinterest.”

> “Use the EPS and high resolution PNGs provided below.”

> “If you’re creating an app, website or other service designed to be used
> with Pinterest, develop your own branding that doesn’t use Pinterest brand
> elements.”

The page permits supplied assets for its stated presence-marketing context and
restricts using Pinterest elements as an app's own branding. It does not
directly decide a truthful OAuth trigger or package redistribution. Therefore
login-button redistribution is **unclear** rather than proved prohibited.

### Package-user caveats

- Do not reuse “Follow on Pinterest” marketing CTA guidance as authentication
  copy.
- The package's `#BD081C` and states are secondary/package values, not an
  official login palette.
- Re-check authenticated developer documentation or seek provider
  clarification before presenting Pinterest as identity login.

<a id="snapchat"></a>

## 21. Snapchat

### Purpose and official control

- **Purpose:** Login Kit is Snap's OAuth 2.0 authentication and identity
  integration. It authenticates the Snapchat account and can provide optional
  display-name or Bitmoji metadata; it does not expose private messages,
  shared content, or contacts.
- Login Kit:
  [developers.snap.com, overview](https://developers.snap.com/snap-kit/login-kit/overview)
- Integration brand rules:
  [developers.snap.com, brand guidelines](https://developers.snap.com/snap-kit/app-review/brand-guidelines)
- General brand page:
  [snap.com, brand guidelines](https://www.snap.com/en-US/brand-guidelines)
- Official Ghost download control:
  [vault.snap.com, x8v786i766jpg8x4l26hnp6151a5450r](https://vault.snap.com/Share/x8v786i766jpg8x4l26hnp6151a5450r?FR_=1&W=1438&H=1189&lang=en-US)

### Stated visual constraints

- Official login wording is **“Log in with Snapchat.”**
- Integrations must have original names and branding and must not imply
  endorsement, partnership, or affiliation.
- The app name, icon, UI, and branding cannot confusingly resemble Snap
  products; do not use the Ghost Logo or “Snapchat yellow” as a dominant color
  in the integration's own design/icon.
- The reviewed sources state no numeric yellow, login-button dimensions,
  shape, border, or interaction-state values.

### Permission and uncertainty

> “Add a ‘Log in with Snapchat’ Button.”

> “Please only use the official Ghost logo, available for download here.”

> “Any use of Snap brand features including the Snapchat Ghost logo must be
> accurate, transparent, and clear.”

The docs support a truthful Login Kit control and direct users to official
Ghost artwork, subject to Snap's guidelines. They do not expose an express
software-package redistribution grant. Login/integration use is supported;
bundling the Ghost in this package remains **unclear**, not automatically
forbidden or unlimited.

### Package-user caveats

- Current Login Kit must be integrated directly through OAuth 2; Snap says the
  older wrapper SDKs are being deprecated.
- Use authorization code with PKCE for public/mobile clients. Keep a client
  secret only on a server.
- The package's `#FFFC00`, black text, Korean translation, and states are not
  verified official button values.

<a id="vk"></a>

## 22. VK

### Purpose and official control

- **Purpose:** VK ID SDK performs user authentication over OAuth 2.1. It can
  request user scopes such as `phone` and `email`.
- Official SDK repository/mirror:
  [github.com, vkid web sdk](https://github.com/VKCOM/vkid-web-sdk)
- Design rules:
  [id.vk.ru, design rules oauth](https://id.vk.ru/about/business/go/docs/ru/vkid/latest/vk-id/connection/guidelines/design-rules-oauth)
- Custom web button:
  [id.vk.ru, custom button web](https://id.vk.ru/about/business/go/docs/ru/vkid/latest/vk-id/connection/elements/custom-button/custom-button-web)
- Asset URL/format: the custom-button page supplies inline SVG markup and the
  SDK renders OneTap; no separately published static login-asset download was
  verified.

### Stated visual constraints

- For the current custom-button example: background `#0077ff`, text/icon
  `#ffffff`, radius **8 px**, width **100%**, minimum height **44 px**, icon
  **28 × 28**, container padding **8 px 10 px**.
- Example states: hover opacity **0.8**; active opacity **0.7** and
  `scale(.97)`.
- Official single-provider wording includes **“Войти с VK ID”**; design rules
  say only proposed wording may be used and internal widget text must not be
  changed.
- General design rules also allow a white background with black `#000000`
  text, or transparent background with black text; a neutral fill or no border
  is allowed, custom rounding may follow the app design system, and shadows
  are prohibited.
- Recommended height is **32-56 px**:
  - small: 32-40 px, 14 pt text, 24 pt logo, 4-7 px padding;
  - medium: 40-48 px, 16 pt text, 28 pt logo, 6-9 px padding;
  - large: 48-56 px, 17 pt text, 28 pt logo, 10-14 px padding.
- Border radius should match the containing components; a fully pill-rounded
  button shifts the logo right by 2 px.

### Permission and uncertainty

> “VK ID SDK , это библиотека для безопасной и удобной авторизации
> пользователей в вашем сервисе через VK ID.”

> “Пользовательская кнопка создается сервисом вручную...”
> (“The custom button is created manually by the service...”)

The official page expressly supplies markup, inline SVG, styling, and an SDK
login call for a custom control. That supports implementing the documented
control. The SDK repository license covers repository code; the reviewed
sources did not separately state a trademark/asset redistribution license.
Documented implementation is **permitted**; extracting and bundling a static
logo remains **unclear**.

### Package-user caveats

- The provider renderer uses the documented blue, white foreground, 44 px
  minimum height, 28 px logo, padding, and opacity states. Its translated
  package wording is not the provider's documented Russian wording.
- Prefer the SDK OneTap control or reproduce the official custom-button
  example and current design rules, not an isolated circular icon.

<a id="weibo"></a>

## 23. Weibo

### Purpose and official control

- **Purpose:** Weibo Login covers identity authentication, user relationships,
  and content distribution. OAuth 2/SSO can identify the user for third-party
  login and authorize subsequent Weibo API access.
- Login overview:
  [open.weibo.com, login](https://open.weibo.com/wiki/Connect/login)
- Official web control configurator:
  [open.weibo.com, loginbutton.php](https://open.weibo.com/widget/loginbutton.php)
- Official iOS SDK mirror:
  [github.com, weibo ios sdk](https://github.com/sinaweibosdk/weibo_ios_sdk)
- Brand asset URL/format: no standalone current vector/logo download was found
  in the bounded review; the official widget configurator and SDK-supplied
  controls are the verified sources.

### Stated visual constraints

- Pre-login styles: **button**, **icon + text**, or **text**.
- Fixed sizes: **200 × 50 px**, **145 × 35 px**, **100 × 25 px**, and
  **85 × 20 px**.
- Post-login states can show profile/follow/fan/post counts, avatar + nickname,
  square Weibo logo + nickname, Weibo logo + nickname, or nickname.
- The source does not expose numeric colors, radius, borders, or hover/focus
  states.

### Permission and uncertainty

> “配置微博登录按钮样式和APPkey，获取代码并粘贴到需要放置微博登录按钮的
> 位置即可。”
> (“Configure the Weibo login-button style and AppKey, obtain the code, and
> paste it where the login button is needed.”)

> “微博登入按钮主要是简化用户进行 SSO 登陆，实际上，它内部是对 SSO 认证
> 流程进行了简单的封装。”
> (“The Weibo login button mainly simplifies SSO login; internally it wraps
> the SSO authentication flow.”)

This expressly permits use of generated widget code and the official SDK
control for the integration. It does not state a standalone-logo
redistribution grant. Generated/SDK-control use is **permitted**; package asset
redistribution remains **unclear**.

### Package-user caveats

- The web widget and parts of the official pages are visibly legacy, including
  HTTP resources; confirm current transport and platform support before
  production use.
- The package's red is sourced from a secondary Wikipedia-linked record, not a
  current official Weibo login color.
- The common package dimensions and wording are not one of the documented
  fixed widget variants.

<a id="qq"></a>

## 24. QQ

### Purpose and official control

- **Purpose:** QQ Login OAuth 2.0 explicitly asks the user to authorize access
  to QQ user data. It identifies the user through OpenID and then permits
  authorized OpenAPI calls.
- OAuth overview:
  [wiki.connect.qq.com, oauth2 0简介](https://wiki.connect.qq.com/oauth2-0%e7%ae%80%e4%bb%8b)
- Official button placement/download instructions:
  [wiki.connect.qq.com, 放置qq登录按钮 oauth2 0](https://wiki.connect.qq.com/%e6%94%be%e7%bd%aeqq%e7%99%bb%e5%bd%95%e6%8c%89%e9%92%ae_oauth2-0)
- Official JS SDK control:
  [wiki.connect.qq.com, js sdk使用说明](https://wiki.connect.qq.com/js_sdk%e4%bd%bf%e7%94%a8%e8%af%b4%e6%98%8e)
- Brand rules:
  [qq.design, Logo](https://qq.design/brand/BrandDesign/Logo)
- Official example control PNG:
  [qzonestyle.gtimg.cn, Connect logo 7.png](https://qzonestyle.gtimg.cn/qzone/vas/opensns/res/img/Connect_logo_7.png)

### Stated visual constraints

- `QC.Login` inserts a provider control and accepts sizes
  `A_XL`, `A_L`, `A_M`, `A_S`, `B_M`, `B_S`, and `C_S`; the reviewed page does
  not map those identifiers to exact pixels.
- Button-placement docs tell developers to download the “QQ登录” image, follow
  the UI specification, and place it appropriately.
- General QQ logo: symbol and logotype have fixed relative size/position; the
  logotype cannot be used alone; use master artwork rather than redrawing or
  recombining.
- General-logo minimum is **44 px screen** or **16 mm print**, with no preset
  maximum. Clear space should be 100%, or 50% when 100% is unavailable.
- Those general-logo dimensions are not documented login-button dimensions.

### Permission and uncertainty

> “下载‘QQ登录’按钮图片，并将按钮放置在页面合适的位置。”
> (“Download the ‘QQ Login’ button image and place it in the appropriate
> position on the page.”)

> “The primary brandmark should only be reproduced from the master artwork. It
> should not be redrawn or altered in any way.”

The official flow expressly supplies a downloadable login image and SDK
control for QQ Login use. The source does not state that the image may be
repackaged in an unrelated reusable package. Integration use is **permitted**;
redistribution remains **unclear**. This is neither proof of prohibition nor an
unlimited license.

### Package-user caveats

- The OAuth overview labels the JS SDK older and recommends self-integration;
  it also says iframe embedding is not recommended.
- Prefer the current OAuth flow plus official UI material. Do not infer that
  the general 44 px logo minimum or brand clear-space rule defines every QQ
  login button.
- The package's `#1EBAFC`, black text, English/Korean labels, and states come
  from historical/secondary or package choices, not verified current QQ login
  tokens.

<a id="epicGames"></a>

## 25. Epic Games

### Purpose

Epic Account Services is an Epic-account authentication/account-linking
facility within Epic Online Services. It is not evidence that any application
may present a generic Epic-branded social-login button. The public services page
describes player services, while implementation material is split between Epic
developer documentation and account-service flows.

### Official sources

- Authentication/service material:
  - [onlineservices.epicgames.com, services games](https://onlineservices.epicgames.com/en-US/services-games)
  - [onlineservices.epicgames.com, player authentication with epic account services eas](https://onlineservices.epicgames.com/en-US/news/player-authentication-with-epic-account-services-eas)
  - [dev.epicgames.com, auth interface](https://dev.epicgames.com/docs/epic-account-services/auth/auth-interface)
- Trademark/terms:
  - [epicgames.com, tos](https://www.epicgames.com/site/en-US/tos)
- Brand asset:
  - No current public Epic Games sign-in asset URL was verified. The previously
    referenced public brand portal was unavailable during the check.

### Stated control constraints

- Colors, dimensions, wording, interaction states, and shape: **unknown**.
  None was available from a public, current first-party login-control page in
  the bounded check.
- Public source excerpt: the relevant Epic pages did not return extractable
  body text through the available reader on 2026-09-29, so no exact visual rule
  is quoted here.

### Permission status and uncertainty

- Status: **public permission absent; partner-only asset status not directly
  confirmed**.
- No public source found an express grant to copy, modify, or redistribute an
  Epic sign-in mark in a Flutter package.
- The existence of Epic developer services is not itself a trademark or asset
  redistribution license. A developer or partner channel may provide approved
  artwork, but the checked public pages did not confirm its terms or contents.

### Package-user caveats

- **Current bundle:** `assets/social/epicGames.png`, a pinned Simple Icons-derived package PNG; it is not provider-supplied or an official login control.
- Do not trace the Epic shield, copy a launcher/runtime image, or treat a
  general Epic brand color as a sign-in color.
- Use artwork supplied for the application’s actual Epic agreement and flow.
  Until that exists, pass no default logo and label the preset as unverified.

<a id="playstation"></a>

## 26. PlayStation

### Purpose

The public PlayStation terms describe an account used to access PlayStation
Services and acknowledge that a third-party product can require account
association. They do not publish a general-purpose “Sign in with PlayStation”
identity-provider integration or reusable control for arbitrary apps.

### Official sources

- Account/legal context:
  - [playstation.com, psn terms of service](https://www.playstation.com/en-us/legal/psn-terms-of-service/)
- Trademark notice and displayed marks:
  - [playstation.com, copyright and trademark notice](https://www.playstation.com/en-us/legal/copyright-and-trademark-notice/)
- Developer/partner portal:
  - [partners.playstation.net, official source](https://partners.playstation.net/)
- Brand asset:
  - No public sign-in asset URL was verified. Images embedded in the trademark
    notice identify marks; they are not presented as downloadable login assets.

### Stated control constraints

- Colors, dimensions, wording, interaction states, and shape: **unknown**.
- Relevant account-linking excerpt:
  > “If a third party publishes a product you purchase, you may need to
  > associate or link your Account to an account with that third party.”
- That excerpt confirms possible account linking, not an approved button design.

### Permission status and uncertainty

- Status: **public use is restricted; exact partner asset terms are gated and
  were not verified**.
- Exact public restriction:
  > “You may not use or reproduce any Marks without the owner’s express written
  > consent.”
- The partner portal was not readable without the applicable access. Therefore
  this guide does not claim that a specific PlayStation login pack is
  partner-only; it confirms only that public mark reuse requires consent and
  that no public login pack was found.

### Package-user caveats

- **Current bundle:** `assets/social/playstation.png`, a pinned Simple Icons-derived package PNG; it is not provider-supplied or an official login control.
- Do not extract the family mark from the legal page.
- Do not present ordinary PlayStation account linking as a generally available
  OAuth identity provider. Use only the control and wording supplied for the
  title’s approved PlayStation integration.

<a id="nintendo"></a>

## 27. Nintendo

### Purpose

Nintendo’s public developer portal is for developing and publishing Nintendo
platform titles. The bounded public check did not find a generally available
Nintendo Account OAuth/login control for unrelated third-party applications.
The public game-content guideline concerns sharing gameplay video and images,
not account authentication.

### Official sources

- Developer portal:
  - [developer.nintendo.com, official source](https://developer.nintendo.com/)
  - [developer.nintendo.com, register](https://developer.nintendo.com/register)
- Public game-content guideline, included to delimit its scope:
  - [nintendo.co.jp, en](https://www.nintendo.co.jp/networkservice_guideline/en/index.html)
- Brand asset:
  - No public Nintendo Account sign-in asset URL was verified.

### Stated control constraints

- Colors, dimensions, wording, interaction states, and shape: **unknown**.
- Developer-access excerpt:
  > “You will need to enter information related to your organization and
  > personal information of the user who will act as administrator of the
  > account.”
- Scope-limiting excerpt:
  > “The Guidelines only cover the sharing of Nintendo Game Content on
  > appropriate video and image sharing sites.”
- Neither excerpt grants or specifies a Nintendo Account login button.

### Permission status and uncertainty

- Status: **public login permission absent; partner-only login artwork not
  directly confirmed**.
- Registration for Nintendo development is public, but the checked public pages
  do not state that a particular login asset exists, nor do they state its
  redistribution terms.
- The game-content guideline cannot be extended to a logo, account button, or
  package asset.

### Package-user caveats

- **Current bundle:** `assets/social/nintendo.png`, a pinned Simple Icons-derived package PNG; it is not provider-supplied or an official login control.
- Do not repurpose the Nintendo wordmark or a console/service logo as a Nintendo
  Account control.
- Obtain the exact identity flow and artwork from the applicable Nintendo
  program before showing this provider in production.

<a id="xbox"></a>

## 28. Xbox

### Purpose

Xbox identity is a game/title identity and service-access concern documented in
Microsoft’s game-development ecosystem. It is not interchangeable with the
general Microsoft identity platform. A personal Microsoft account can be used
by Xbox, but the official Microsoft “Sign in with Microsoft” artwork does not
become an Xbox login control.

### Official sources

- Xbox/GDK documentation entry points:
  - [learn.microsoft.com, xbox](https://learn.microsoft.com/en-us/xbox/)
  - [learn.microsoft.com, get started home](https://learn.microsoft.com/en-us/gaming/gdk/docs/gdk-dev/get-started/get-started-home)
  - [learn.microsoft.com, access resources](https://learn.microsoft.com/en-us/gaming/gdk/docs/gdk-dev/development-downloads/access-resources)
- Microsoft trademark guidance covering Xbox marks:
  - [microsoft.com, trademarks](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks)
- Brand asset:
  - No public reusable Xbox sign-in asset URL was verified.

### Stated control constraints

- Xbox-specific colors, dimensions, wording, interaction states, and shape:
  **unknown**.
- GDK search results describe the kit as supporting “GDK games for PC or Xbox”;
  no public result exposed a reusable web/mobile Xbox login button.
- General Microsoft-account button rules are intentionally excluded because
  they describe a different end-user brand.

### Permission status and uncertainty

- Status: **license required for many logo/icon uses; no public Xbox login grant
  verified**.
- Exact first-party excerpt:
  > “Many uses, including our logos, app and product icons, and other designs,
  > will require a license first.”
- This confirms a licensing condition. It does not confirm the contents or
  availability of a private Xbox login asset pack.

### Package-user caveats

- **Current bundle:** `assets/social/xbox.png`, a pinned Simple Icons-derived package PNG; it is not provider-supplied or an official login control.
- Do not substitute Microsoft-account sign-in artwork, and do not treat
  `#107C10` or another Xbox brand green as an official login-control color.
- Xbox title developers should use the GDK/partner UI and assets required for
  their title rather than this package’s generic social-button geometry.

<a id="zoom"></a>

## 29. Zoom

### Purpose

Zoom’s documented OAuth flow authorizes an app to call Zoom APIs for a user or
account. It can return the user associated with a token, but the public docs
frame the flow as API authorization and app installation, not as a generic
identity-provider button specification.

### Official sources

- OAuth flow:
  - [developers.zoom.us, oauth](https://developers.zoom.us/docs/integrations/oauth/)
  - [developers.zoom.us, create](https://developers.zoom.us/docs/integrations/create/)
- Brand Center:
  - [brand.zoom.us, official source](https://brand.zoom.us/)
- Brand asset:
  - No stable public login asset URL or file format was exposed. The Brand
    Center was portal-mediated/inaccessible to the available text reader.

### Stated control constraints

- Colors, dimensions, wording, interaction states, and shape: **unknown for an
  external OAuth button**.
- Purpose excerpt:
  > “Get an `access_token` to call APIs on behalf of a Zoom user or Zoom
  > account.”
- Flow excerpt:
  > “Zoom prompts them to sign in (if not already signed in) and to grant the
  > requested permissions.”
- The app creation guide uses Marketplace UI labels such as “Add App Now” and
  “Allow”; those labels describe Zoom-hosted UI, not a reusable caller button.

### Permission status and uncertainty

- Status: **Brand Center portal-mediated; public redistribution permission
  unknown**.
- No accessible public text granted permission to package a Zoom logo as an
  OAuth button. No evidence was found for an exact login color, even though
  Zoom product and Marketplace interfaces use brand colors.
- Portal gating is confirmed; “partner-only” is not asserted because the
  accessible pages did not state that all relevant assets require a partner
  agreement.

### Package-user caveats

- **Current bundle:** `assets/social/zoom.png`, a pinned Simple Icons-derived package PNG; it is not provider-supplied or an official login control.
- Describe the action according to the real product behavior, such as connecting
  or authorizing Zoom, unless the app separately establishes a login contract.
- Do not derive a login palette from Marketplace theme settings or reconstruct
  a button from the Zoom wordmark.

<a id="kakao"></a>

## 30. Kakao

### Purpose

Kakao Login is explicitly a social-login service based on OAuth 2.0. The flow
both authenticates the user through Kakao Talk/Kakao Account and obtains consent
for requested user information or features. OIDC can add an ID token.

### Official sources

- Login concepts and flow:
  - [developers.kakao.com, common](https://developers.kakao.com/docs/en/kakaologin/common)
- Button design:
  - [developers.kakao.com, design guide](https://developers.kakao.com/docs/en/kakaologin/design-guide)
- Official resource tool:
  - [developers.kakao.com, login](https://developers.kakao.com/tool/resource/login)
- Asset formats:
  - The design guide states PNG and PSD. The tool provides an all-resource ZIP;
    its download URL is UI-mediated rather than a stable documented file URL.

### Stated control constraints

- Container: `#FEE500`.
- Symbol: `#000000`.
- Label: `#000000` at 85% opacity.
- Label wording:
  - Korean complete/simple: `카카오 로그인` / `로그인`.
  - English complete/simple: `Login with Kakao` / `Login`.
- Label font: the OS default system font at `30` points (`Sp/Dp`) as written in
  the current English guide.
- Symbol: use the Kakao chat-bubble symbol; do not alter its shape, ratio, or
  color; do not substitute the KakaoTalk icon, Kakao CI, another icon, or omit
  the symbol.
- Container corner radius: `12px`.
- Width-only resizing: extend only the container’s horizontal area outside the
  symbol/label area; keep label kerning and size; align symbol and label left or
  center.
- Whole-button resizing: preserve the symbol/label aspect ratio; label height
  must not exceed one third of container height.
- Smaller than standard: use the simple `Login` version rather than forcing a
  new aspect ratio.
- Interaction states: no exact hover, focus, pressed, or disabled values were
  stated on the checked design page.

### Permission status and uncertainty

- Status: **officially supplied for Kakao Login, subject to the design guide**.
- Exact excerpts:
  > “You can download the buttons with the PNG and PSD file extensions.”
  >
  > “You must comply with the following design guidelines when you add the
  > Kakao Login button.”
- This supports use of the supplied login resources for a Kakao Login
  integration. It does not state a blanket right to redistribute modified
  derivatives in a package.

### Package-user caveats

- Current bundle: `assets/social/kakao.png`, preserved from
  `Kakao Login.zip` as `assets/original/kakao/kakao_login_light.png`.
- The default provider renderer uses the verified Kakao colors, 12 px radius,
  and 30-point label value. A caller can still select a shared circle or other
  package shape, which is not Kakao's complete official button.
- Preserve the provider original and do not recolor the bundled symbol.

<a id="naver"></a>

## 31. Naver

### Purpose

Naver Login is a social-login product. The first-party overview says it provides
user authentication information based on OAuth 2.0 and supports OIDC.

### Official sources

- Product/authentication overview:
  - [developers.naver.com, api](https://developers.naver.com/products/login/api/api.md)
- Button/BI guide:
  - [developers.naver.com, bi](https://developers.naver.com/docs/login/bi/bi.md)
- Official assets:
  - Korean Figma:
    [developers.naver.com, NAVER login KR.fig](https://developers.naver.com/inc/devcenter/downloads/bi/NAVER_login_KR.fig)
  - Korean AI:
    [developers.naver.com, NAVER login KR.ai](https://developers.naver.com/inc/devcenter/downloads/bi/NAVER_login_KR.ai)
  - Korean PNG ZIP:
    [developers.naver.com, NAVER login KR.zip](https://developers.naver.com/inc/devcenter/downloads/bi/NAVER_login_KR.zip)
  - English Figma:
    [developers.naver.com, NAVER login EN.fig](https://developers.naver.com/inc/devcenter/downloads/bi/NAVER_login_EN.fig)
  - English AI:
    [developers.naver.com, NAVER login EN.ai](https://developers.naver.com/inc/devcenter/downloads/bi/NAVER_login_EN.ai)
  - English PNG ZIP:
    [developers.naver.com, NAVER login EN.zip](https://developers.naver.com/inc/devcenter/downloads/bi/NAVER_login_EN.zip)

### Stated control constraints

- The guide recommends `#03A94D` (`RGB 3/169/77`), but the unchanged official
  bundled PNG uses `#05AC4F`. The package matches that PNG's green to avoid an
  inner color ring; this source discrepancy is not a change to the original.
- Green-button logo and label: `#FFFFFF`.
- Designated colors cannot be changed.
- Forms: icon and complete button; complete button is recommended.
- N mark minimum: `18px` for icon form, `16px` for complete form.
- The label text must be smaller than the logo height.
- Centered layout: keep `8px` between logo and label.
- Left-aligned layout example: `20px` left logo padding, with the label centered
  in the remaining area.
- Wording may change in Korean or English if it remains appropriate to the
  purpose of logging in with Naver. The guide illustrates `네이버로 3초만에
  시작하기`, `네이버로 간편가입`, `Start with Naver`, and `Log in with
  Naver`.
- Do not alter the N logo’s form, combine it with another form, use an
  unspecified background/label color, make it unidentifiably small, or apply a
  gradient.
- Interaction states and corner radius: no exact values stated in the checked
  guide.

### Permission status and uncertainty

- Status: **officially supplied for Naver Login, with limited customization
  under the BI guide**.
- Exact excerpts:
  > “네이버 로그인은 버튼 기본 이미지를 제공합니다.”
  >
  > “지정 컬러는 변경할 수 없으며”
- The guide permits some changes only when necessary and recommends preserving
  the provided design as much as possible. It does not state a blanket
  trademark redistribution license.

### Package-user caveats

- Current bundle: `assets/social/naver.png`, preserved from the official Korean
  archive as
  `assets/original/naver/NAVER_login_Dark_KR_green_icon_H56.png`.
- The provider renderer uses the verified white foreground, 56 px minimum
  height, 8 px logo-label spacing, and 20 px horizontal padding. It sizes the
  preserved icon template from its measured internal N bounds.
- Use the complete official asset when exact full-button composition is
  required; the package renderer is not a guarantee of provider compliance.
- Do not scale the bundled N below the guide’s minimum or put it in a
  provider-unapproved color/container combination.

<a id="google"></a>

## 32. Google

### Purpose

Sign in with Google authenticates or signs up a user and returns an ID-token
credential. Additional Google API scopes are a separate authorization concern
and should be requested incrementally.

### Official sources

- Branding guide:
  - [developers.google.com, branding guidelines](https://developers.google.com/identity/branding-guidelines)
- Google-rendered web control:
  - [developers.google.com, display button](https://developers.google.com/identity/gsi/web/guides/display-button)
- Official PNG/SVG archive:
  - [developers.google.com, signin assets.zip](https://developers.google.com/static/identity/images/signin-assets.zip)
- Standalone standard-color G linked by the custom-button guidance:
  - [developers.google.com, g-logo.png](https://developers.google.com/static/identity/images/g-logo.png)

### Stated control constraints

- Preferred implementation: use Google Identity Services because it renders the
  current compliant button.
- Pre-approved archive formats: PNG and SVG; standard and icon modes; Light,
  Neutral, and Dark themes. The current page exposes rectangular/pill standard
  variants and round/square icon examples.
- Custom button size: scalable if the aspect ratio is preserved.
- Recommended wording: `Sign in with Google`, `Sign up with Google`, or
  `Continue with Google`; localization is permitted and encouraged.
- Light default: fill `#FFFFFF`; inside stroke `#747775`, `1px`; font
  `#1F1F1F`, Google Sans Medium, `14/20`.
- Dark default: fill `#131314`; inside stroke `#8E918F`, `1px`; font
  `#E3E3E3`, Google Sans Medium, `14/20`.
- Neutral default: fill `#F2F2F2`; no stroke; font `#1F1F1F`, Google Sans
  Medium, `14/20`.
- Always use the standard-color Google `G`; do not change its size or color.
  The custom-button guidance says it appears on a white background within the
  logo area.
- Keep fixed logo padding and size; do not draw a replacement or use an outdated
  `G`.
- The Android/Web padding diagram specifies a `20×20` G, `12px` before the G,
  `10px` after it, and `12px` after the label.
- Icon-only may be used as an action button when needed, but not as an
  unexplained free-floating Google logo without a button boundary/action
  context.
- The Google option must be at least as prominent as other third-party sign-in
  options, approximately the same size and visual weight.
- Checked page states only the **default** color state. No exact hover, focus,
  pressed, or disabled tokens were stated in the extracted text.

### Permission status and uncertainty

- Status: **pre-approved sign-in assets and custom-button path are expressly
  provided, conditional on the branding guide**.
- Exact excerpts:
  > “download our pre-approved Sign in with Google buttons”
  >
  > “Use of Google brands in ways not expressly covered by this document is not
  > allowed without prior written consent from Google.”
- The branding page reports “Last updated 2026-07-07 UTC.”

### Package-user caveats

- Current bundle: `assets/social/google.png`, a byte-for-byte copy of the
  official direct `g-logo.png`, preserved at
  `assets/original/google/g-logo.png` with SHA-256
  `d1ce9c2af0b10a7333abc99bc706f9a6a199e5b65bf3e3009624f076b8638e6a`.
- The former Light no-text square Android/Web `@4x` member is a complete
  icon-mode button with its own white surface and border. Its ZIP/member hashes
  remain historical provenance; it is no longer nested inside the package
  button.
- A logo-only raster does not make the package’s common surrounding button a
  Google-rendered or pre-approved complete button. Prefer GIS or a supplied
  complete asset when verification/conformance is required.
- Never recolor the bundled `G`; keep the required action context and comparable
  prominence.

<a id="apple"></a>

## 33. Apple

### Purpose

Sign in with Apple is an authentication system that returns an authorization
code and, when requested, an ID token containing identity information. Apple
documents native/system controls and generated PNG controls for other
platforms.

### Official sources

- Other-platform flow and generated controls:
  - [developer.apple.com, incorporating sign in with apple into other platf...](https://developer.apple.com/documentation/signinwithapple/incorporating-sign-in-with-apple-into-other-platforms)
  - Official structured mirror used when the rendered page exposed no body:
    [developer.apple.com, incorporating sign in with apple into other platf...](https://developer.apple.com/tutorials/data/documentation/signinwithapple/incorporating-sign-in-with-apple-into-other-platforms.json)
- Appearance guidance:
  - [developer.apple.com, Sign in with Apple HIG](https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple)
- Live button preview:
  - [account.apple.com, button](https://account.apple.com/signinwithapple/button)
- Generated PNG endpoints:
  - Center: [appleid.cdn-apple.com, button](https://appleid.cdn-apple.com/appleid/button)
  - Left: [appleid.cdn-apple.com, left](https://appleid.cdn-apple.com/appleid/button/left)
  - Logo only: [appleid.cdn-apple.com, logo](https://appleid.cdn-apple.com/appleid/button/logo)

### Stated control constraints

- Generated modes: center-aligned, left-aligned, and logo-only PNG.
- Full button height: `30`-`64` points; default `30`.
- Full button width: `130`-`375` points; default `140`.
- Background `color`: `white` or `black`; default `black`.
- Apple documents black, white, and white-outline appearances. The white style
  is available on all platforms and the web and requires a dark enough
  surrounding background for sufficient contrast.
- `border`: Boolean; default `false`.
- Text `type`: `sign-in` or `continue`; default `sign-in`.
- `border_radius`: `0`-`50` points; default `15`.
- `scale`: `1`-`6`; default `1`.
- `locale`: use one of the documented locale values, including `en_US`,
  `ko_KR`, and the other listed locales.
- Left-aligned controls:
  - `label-position`: `0`-`182` points, no more than half the width; default
    `0`.
  - `logo-position`: `0`-`182` points, no more than half the width; default
    `0`.
  - `logo-size`: `small`, `medium`, or `large`.
- Logo-only control: `size` sets equal width and height; `color`, `border`,
  `border_radius`, and `scale` use the documented values above.
- Interaction states: no exact hover, focus, pressed, or disabled values were
  stated in the checked other-platform article.

### Permission status and uncertainty

- Status: **Apple explicitly provides generated button files for embedding,
  within the documented query ranges**.
- Exact excerpt:
  > “Use this file to customize and embed your button of choice in your
  > application or service.”
- Invalid query parameters return `404 Page Not Found`. This makes generated
  endpoint parameters part of the control contract rather than suggestions.

### Package-user caveats

- Default/dark bundle: `assets/social/apple.png`, generated as a black
  `44`-point logo-only PNG at `scale=2`, preserved as
  `assets/original/apple/apple-signin-logo-black-44@2x.png`, SHA-256
  `70b9af49f6f0dcea26ced9b12d736dcc498146d01f508a5c6e00f69347796356`.
- Light bundle: `assets/social/apple-light.png`, the unchanged `color=white`
  endpoint response preserved as
  `assets/original/apple/apple-signin-logo-white-44@2x.png`, SHA-256
  `7c17e56419a525c72076ef8b29e51346d31fe538cd4f2e08316b45bea387e354`.
  It contains the official black glyph on an opaque white control and is not
  derived by recoloring the black asset.
- Prefer Apple’s platform control on Apple platforms and the generated full
  button or official web control where applicable.
- Do not replace the generated artwork with a standalone Apple logo copied from
  another source. The package’s common button is not a substitute for Apple’s
  full system control.

<a id="tiktok"></a>

## 34. TikTok

### Purpose

TikTok Login Kit authenticates a TikTok user and issues an access token for
scoped TikTok API access. The web flow includes login/sign-up followed by user
consent, so it combines authentication with authorization.

### Official sources

- Login Kit for web:
  - [developers.tiktok.com, login kit web](https://developers.tiktok.com/doc/login-kit-web)
- Developer design guide:
  - [developers.tiktok.com, getting started design guidelines](https://developers.tiktok.com/doc/getting-started-design-guidelines)
- Brand/use terms:
  - [tiktokbrandbook.com, legal](https://tiktokbrandbook.com/d/HhXfjVK1Poj9/legal)
- Official Logo and Button pack:
  - [sf16-va.tiktokcdn.com, logo pack.zip](https://sf16-va.tiktokcdn.com/obj/eden-va2/uvzhqeh7nuhd/tt4d/logo-pack.zip)

### Stated control constraints

- Public implementation example wording: `Continue with TikTok`.
- The checked design page exposes an official “Logo and Button” ZIP, but its
  accessible text does not enumerate member formats.
- Exact button colors, dimensions, interaction states, and shape: **unknown
  from accessible first-party text**. They must not be inferred from the guide’s
  screenshots.
- The login flow requires HTTPS redirect URIs; each URI must be absolute,
  static, shorter than `512` characters, contain no fragment, and at most `10`
  may be registered. These are flow constraints, not visual button dimensions.

### Permission status and uncertainty

- Status: **official pack supplied, but public permission wording remains
  limited/conditional**.
- Exact excerpts:
  > “To download TikTok’s Logo and Button packs, click here.”
  >
  > “You may not use TikTok logos, icons, symbols, or designs, without our prior
  > written permission.”
- The public page does not explain whether downloading the developer pack alone
  constitutes permission to redistribute its members in a third-party package.
  Therefore the pack is valid implementation evidence but not a blanket
  redistribution grant.
- The design page reports “Last updated August 4, 2026.”

### Package-user caveats

- **Current bundle:** `assets/social/tiktok.png`, a pinned Simple Icons-derived package PNG; it is not provider-supplied or an official login control.
- Application developers using Login Kit should use the current official pack
  under their approved TikTok integration and terms.
- Package maintainers should not bundle the ZIP or extracted logo until its
  redistribution permission and member inventory are reviewed.

<a id="notion"></a>

## 35. Notion

### Purpose

Notion OAuth authorizes a **public connection** to access selected workspace
content. It is not a generic “Sign in with Notion” identity-provider contract.
Although the token is tied to the authorizing user and the token response
includes an owner object, the documented action installs/authorizes a connection
and grants it capabilities over selected Notion pages.

### Official sources

- Authorization:
  - [developers.notion.com, authorization](https://developers.notion.com/guides/get-started/authorization)
  - Legacy route checked and redirected in the existing catalog:
    [developers.notion.com, authorization](https://developers.notion.com/docs/authorization)
- Public connection semantics:
  - [developers.notion.com, public connections](https://developers.notion.com/guides/get-started/public-connections)
- Official docs index:
  - [developers.notion.com, llms.txt](https://developers.notion.com/llms.txt)
- Brand page:
  - [notion.com, brand](https://www.notion.com/brand)
- Brand asset:
  - No public reusable login/control asset URL was verified. The brand route
    returned no usable asset terms in the prior package check and returned an
    inaccessible/generic app response in the current bounded check.

### Stated control constraints

- Official example caller wording: `Add to Notion`.
- Hosted authorization UI wording includes `Select pages`, `Allow access`, and
  `Cancel`. These labels belong to Notion’s authorization prompt, not to a
  caller-owned generic login button.
- Exact caller-button colors, dimensions, interaction states, and shape:
  **absent from the checked public docs**.
- Core purpose excerpts:
  > “Authorization is the process of granting a connection or token access to
  > Notion data.”
  >
  > “A public connection is an OAuth connection that users install into their
  > Notion workspaces.”
- The user chooses pages and connection capabilities; the resulting access
  token is used for API requests on behalf of that user.

### Permission status and uncertainty

- Status: **public visual permission absent; no partner-only restriction
  confirmed**.
- No public text was found granting reuse or redistribution of a Notion logo for
  a login button. The official `/brand` route did not yield a current public
  asset kit or permission excerpt through the available reader.
- A runtime logo, favicon, documentation image, or app-shell asset is not a
  published brand pack.

### Package-user caveats

- **Current bundle:** `assets/social/notion.png`, a pinned Simple Icons-derived package PNG; it is not provider-supplied or an official login control.
- Prefer wording such as `Add to Notion` or `Connect Notion` when the action
  starts the documented connection-install flow. `Continue with Notion` can
  falsely imply generic application authentication.
- Do not treat the returned owner/workspace metadata as a general identity
  verification service, and do not use OAuth solely to imitate social login
  without a real Notion connection/API-access purpose.

## Release checks

1. Open the first-party links for the exact platform and product being released.
2. Confirm current asset terms, app-review rules, required wording, and localization.
3. Compare the rendered control with documented size, spacing, contrast, and state rules.
4. Replace `SocialButton` with the provider SDK, generator, QR surface, or complete control when required.
5. Keep OAuth, OIDC, account linking, and workspace authorization semantics in the consuming app. A rendered button does not prove authentication support.
