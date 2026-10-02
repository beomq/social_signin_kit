# Bundled provider assets

Checked and downloaded: 2026-09-30

All 35 providers have a local runtime PNG. Twelve use
provider-supplied originals preserved under `original/`: eleven use unchanged
PNGs, plus Spotify's unchanged standalone source PNG and its resized runtime PNG.
GitHub maps directly to the white Invertocat under `original/github/` for
default/dark and the black original for light; the other default mappings are
under `social/`. The other 23 providers use transparent 128×128 PNGs rendered from pinned
Simple Icons SVG sources preserved under `original/simple-icons/`. Slack also
has a black `slack-light.png` variant rendered from the same pinned SVG for its
white light appearance. Those
community-maintained SVGs are practical provider identifiers, not
provider-supplied sign-in controls. Complete provider controls that cannot fit
the package's logo slot remain preserved separately.

| Provider | Runtime path | Preserved original | Official source | SHA-256 |
| --- | --- | --- | --- | --- |
| Google | `assets/social/google.png` | `assets/original/google/g-logo.png` | [Google custom-button standard-color G](https://developers.google.com/static/identity/images/g-logo.png), linked from the [branding guidelines](https://developers.google.com/identity/branding-guidelines) | `d1ce9c2af0b10a7333abc99bc706f9a6a199e5b65bf3e3009624f076b8638e6a` |
| GitHub default/dark | `assets/original/github/GitHub_Invertocat_White.png` | `assets/original/github/GitHub_Invertocat_White.png` | [GitHub logo archive](https://brand.github.com/GitHub_Logos.zip), member `GitHub Logos/PNG/GitHub_Invertocat_White.png` | `0d4c235fef9efec54174a7c005fc0fe0ce2d63d35c21898ab5148587111397a9` |
| GitHub light | `assets/original/github/GitHub_Invertocat_Black.png` | `assets/original/github/GitHub_Invertocat_Black.png` | [GitHub logo archive](https://brand.github.com/GitHub_Logos.zip), member `GitHub Logos/PNG/GitHub_Invertocat_Black.png` | `2a2f5cbcc74c7fa83c40127dd8b0e42c23f1157131aebe28492aa1ac27bbdc6d` |
| Apple default/dark | `assets/social/apple.png` | `assets/original/apple/apple-signin-logo-black-44@2x.png` | [Apple generated black logo](https://appleid.cdn-apple.com/appleid/button/logo?size=44&color=black&border=false&border_radius=8&scale=2) | `70b9af49f6f0dcea26ced9b12d736dcc498146d01f508a5c6e00f69347796356` |
| Apple light | `assets/social/apple-light.png` | `assets/original/apple/apple-signin-logo-white-44@2x.png` | [Apple generated white logo control](https://appleid.cdn-apple.com/appleid/button/logo?size=44&color=white&border=false&border_radius=8&scale=2) | `7c17e56419a525c72076ef8b29e51346d31fe538cd4f2e08316b45bea387e354` |
| Kakao | `assets/social/kakao.png` | `assets/original/kakao/kakao_login_light.png` | [Kakao resource tool](https://developers.kakao.com/tool/resource/login), archive `Kakao Login.zip`, member `Kakao Login/PNG @4x/kakao_login_light.png` | `52530053de4bd84aabb2ea0716c793a71076d43d5229488e873bc56db028d180` |
| Naver | `assets/social/naver.png` | `assets/original/naver/NAVER_login_Dark_KR_green_icon_H56.png` | [Naver Login archive](https://developers.naver.com/inc/devcenter/downloads/bi/NAVER_login_KR.zip), member `NAVER_login_KR/NAVER_login_Dark_KR_green_icon_H56.png`; dominant opaque source pixel `#05AC4F` | `24c798d869bfd72312ff936bc8329ab73a1beba173873feb6faef5d7f06c76f9` |
| LINE | `assets/social/line.png` | `assets/original/line/line_88.png` | [LINE Login archive](https://vos.line-scdn.net/line-developers/docs/media/line-login/login-button/LINE_Login_Button_Image.zip), member `Line_Login_Button_Image/images/DeskTop/2x/44dp/line_88.png` | `b3d3c91217e979882e2e947c219d299bd471b5305c3714276636111ac70f0688` |
| Microsoft | `assets/social/microsoft.png` | `assets/original/microsoft/ms-symbollockup_mssymbol_19.png` | [Microsoft identity-platform branding guide](https://learn.microsoft.com/en-us/entra/identity-platform/howto-add-branding-in-apps), direct [PNG](https://learn.microsoft.com/en-us/entra/identity-platform/media/howto-add-branding-in-apps/ms-symbollockup_mssymbol_19.png) | `ecc6ec51a0ff2a2c3314e3f98f47c75beb6ca294e70569cdc457a05fe7028d8d` |
| X | `assets/social/x.png` | `assets/original/x/logo-white.png` | [X logo archive](https://about.x.com/content/dam/about-twitter/x/brand-toolkit/x-logo.zip), member `logo-white.png` | `432bdd47255b48366843ec21d209e774f93b807e1fd0894fc983aad0dc7bd03b` |
| LinkedIn | `assets/social/linkedin.png` | `assets/original/linkedin/InBug-White.png` | [LinkedIn In logo archive](https://content.linkedin.com/content/dam/me/business/en-us/amp/xbu/linkedin-revised-brand-guidelines/logos/in-logo.zip), member `in-logo/InBug-White.png` | `ed22a5ab46c171e3449708ff34923de7298da00ac204c7f85444db05bf888791` |
| Twitch | `assets/social/twitch.png` | `assets/original/twitch/glitch_flat_white.png` | [Twitch Brand archive](https://brand.twitch.com/uploads/Twitch-Brand.zip), member `Twitch Brand/Twitch Logos/02. Glitch/04. White/glitch_flat_white.png` | `b803640d64ab9c67737af2e0da8832b4d2f3840fea9c030747a446a2b43dcc4d` |
| Spotify | `assets/social/spotify.png` | `assets/original/spotify/Spotify_Primary_Logo_RGB_Black.png` | [Spotify Logo and Brand Assets](https://newsroom.spotify.com/media-kit/logo-and-brand-assets/), direct [standalone black icon PNG](https://storage.googleapis.com/pr-newsroom-wp/1/2023/05/Spotify_Primary_Logo_RGB_Black.png), resized without recoloring to 128×128 | source `14113bb619ec259ae51a713e4098038c2a51bc2e65ed5dd97da25aa72702d7a5`; runtime `baa60beb991e4b87d8b0e0e695d8e9cd60d79dddf67c2c0b0848b8b8be8b8cb6` |
| Bitbucket | `assets/social/bitbucket.png` | `assets/original/bitbucket/Bitbucket_icon.png` | [Bitbucket app-logo archive](https://atlassian.design/assets/599d0f58b052/logos/bitbucket_app.zip), member `Bitbucket/PNG@2x/Bitbucket_icon.png` | `61e96e6984d1c54df8d9707f5f8288b324d033bf82b15a2dc967e6db796c3a85` |

## Remaining 23 Simple Icons-derived runtime assets

The source SVG markup is preserved from the pinned URL; the table records each
canonical download hash, excluding the single trailing LF added to each
preserved local SVG. Each runtime PNG was rendered to a transparent
128×128 canvas, preserving the 24×24 view box and applying the package
catalog's foreground color. The rasterization is a package adaptation, not a
provider-approved color or button. The retained
`assets/original/simple-icons/github.svg` and `assets/social/github.png`
are legacy files, not current GitHub runtime mappings.

Simple Icons' repository is distributed under CC0-1.0, but its disclaimer says
that does not establish CC0 for every individual icon. None of these 23 data
entries states an individual icon license. Trademark and provider brand terms
remain separate. Attribution is retained here for provenance even where CC0
does not require it.

Current snapshot:
`d4e6ba93e48f178898707f0145ec285f28b64b38` (2026-09-27).
Historical snapshot: `11.15.0`. Historical use is explicit because the four
remaining listed brands are absent from the current snapshot; removal reason and current
shape approval are not inferred.

| Provider | Preserved SVG | Canonical SVG | Canonical SVG SHA-256 | PNG color | Snapshot |
| --- | --- | --- | --- | --- | --- |
| Facebook | `assets/original/simple-icons/facebook.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/facebook.svg | `b06d18d844ed621b89faffb1a33440cc0ec4f1ffea9f36191f50db19a47c59a6` | `#FFFFFF` | current |
| Discord | `assets/original/simple-icons/discord.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/discord.svg | `1d364b72c9eaf1fe37d17ca88cd8fb541308dc0f3b09e2ab3b824f380b3493d5` | `#FFFFFF` | current |
| Slack | `assets/original/simple-icons/slack.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/11.15.0/icons/slack.svg | `f23c317b279f53dcd2260a6cd2e279f7a696f87dcb3da259d6201f05bbc45b0d` | `#FFFFFF` default/dark; `#000000` light | historical 11.15.0 |
| Steam | `assets/original/simple-icons/steam.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/steam.svg | `5eef8f31106b81956ed908490bcf8c73abe476aa58bb9041acdf70b0d42ebcae` | `#FFFFFF` | current |
| Reddit | `assets/original/simple-icons/reddit.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/reddit.svg | `00e5008d56567543cf956561e61d5bf9bf629f520c7488a4d9a00164c29dd8ba` | `#111111` | current |
| Dropbox | `assets/original/simple-icons/dropbox.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/dropbox.svg | `1c9ea4ac8e318f3f6a598568df1a38ece03b7bc52a3a72d48c9e760340d7aeec` | `#FFFFFF` | current |
| GitLab | `assets/original/simple-icons/gitlab.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/gitlab.svg | `c7c39058bd1b6f9f40334383bd5136bb8c5ba5e6a24200f2d1f18365e2526e28` | `#111111` | current |
| PayPal | `assets/original/simple-icons/paypal.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/paypal.svg | `e8ea6928d3386f81dc6d4c1f58b48e7a29d29bb578b2e3dd808638bd97c63d33` | `#FFFFFF` | current |
| Telegram | `assets/original/simple-icons/telegram.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/telegram.svg | `147fd8f8923e7e5f463fe98c0eb9913bead6b2ae59935728cda141002ec8a7c9` | `#111111` | current |
| Instagram | `assets/original/simple-icons/instagram.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/instagram.svg | `f53af2d1fc5292ba1433b5c1faf50005ce6a997fa302d1816989929f379a59dc` | `#111111` | current |
| WeChat | `assets/original/simple-icons/wechat.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/wechat.svg | `74b48b3d315337ce79cb644933b5f975e19996f564fcc4138ed67d45674c43ca` | `#111111` | current |
| Pinterest | `assets/original/simple-icons/pinterest.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/pinterest.svg | `d0736c4b1390f895ed9bc156cc887d3bd65c5b66258c00ad07888e9ec7d729ad` | `#FFFFFF` | current |
| Snapchat | `assets/original/simple-icons/snapchat.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/snapchat.svg | `fbbc31c5544954fbf7525dddbc0d3e79990bb89461f54a94917b6dffc2c5130e` | `#111111` | current |
| VK | `assets/original/simple-icons/vk.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/vk.svg | `2d8fae863c9fdf5937f49326708dcf6cff0f5617ee67b502776b426bbe2cace8` | `#FFFFFF` | current |
| Weibo | `assets/original/simple-icons/weibo.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/sinaweibo.svg | `44facf47c6bfa06c312c28acda6aa2ed404ef7f68c2897c8f33ad51b6ba94059` | `#FFFFFF` | current |
| QQ | `assets/original/simple-icons/qq.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/11.15.0/icons/tencentqq.svg | `5b9ffc52750f3a45d86e3a910baaa14c89201089fc1a74764948cbbe29f2a611` | `#111111` | historical 11.15.0 |
| Epic Games | `assets/original/simple-icons/epicGames.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/epicgames.svg | `a19b1eb5a46edc11a7dc7f1ce6fa1701ea4e4cf451feec88441c523f4b50cde3` | `#FFFFFF` | current |
| PlayStation | `assets/original/simple-icons/playstation.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/playstation.svg | `b68b4d7b63443759b9c4d77a5501c5758eeae06a6d594d278d5eb6cb4d3dbbe4` | `#FFFFFF` | current |
| Nintendo | `assets/original/simple-icons/nintendo.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/11.15.0/icons/nintendo.svg | `4879be6f85a85297ef472d0835fb24e02a7142f7e0a5e764662f2fb0dadd0056` | `#FFFFFF` | historical 11.15.0 |
| Xbox | `assets/original/simple-icons/xbox.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/11.15.0/icons/xbox.svg | `c5ec61839e921542b3581d9aab7d72b822200975c4b508ea4f9bc02ce4c6f025` | `#FFFFFF` | historical 11.15.0 |
| Zoom | `assets/original/simple-icons/zoom.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/zoom.svg | `da5b2f13d38ca61c88a227f58e3bebcbcbb55412d97678ecff49ae7c603f9a7b` | `#FFFFFF` | current |
| TikTok | `assets/original/simple-icons/tiktok.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/tiktok.svg | `6f54ac8d325faacea8935bdc44cbed60206a6b408641799e5fea1cba7c1a0af7` | `#FFFFFF` | current |
| Notion | `assets/original/simple-icons/notion.svg` | https://raw.githubusercontent.com/simple-icons/simple-icons/d4e6ba93e48f178898707f0145ec285f28b64b38/icons/notion.svg | `b17d2a2b592a06252efef522d5205f0c7a958f748d40df1011ed081417e42f85` | `#FFFFFF` | current |

Preserved complete controls that are not runtime-logo mappings:

| Provider | Preserved original | Official source | SHA-256 | Conditions |
| --- | --- | --- | --- | --- |
| Steam | `assets/original/steam/sits_large_border.png` | [Steam OpenID authentication guide](https://partner.steamgames.com/doc/features/auth#website), direct [PNG](https://shared.fastly.steamstatic.com/community_assets/images/steamworks_docs/english/sits_large_border.png) | `a8ce76bb630ac20d6a7b7b26db0e8464709188a5f234d54eaf8be8c96d605dcc` | Complete 118x51 control; use unchanged when linking to the Steam sign-in page. |
| Steam | `assets/original/steam/sits_large_noborder.png` | [Steam OpenID authentication guide](https://partner.steamgames.com/doc/features/auth#website), direct [PNG](https://shared.fastly.steamstatic.com/community_assets/images/steamworks_docs/english/sits_large_noborder.png) | `9d48fa40df41cb978092e138fac63c303ed991ed8af87e6426b1308c8ffb4a0d` | Complete 114x43 control; use unchanged when linking to the Steam sign-in page. |
| Steam | `assets/original/steam/sits_small.png` | [Steam OpenID authentication guide](https://partner.steamgames.com/doc/features/auth#website), direct [PNG](https://shared.fastly.steamstatic.com/community_assets/images/steamworks_docs/english/sits_small.png) | `b7ebcdfa3017de021ad7fb7198717178c8a79e69b0f38aa2bb455a020e60b41c` | Complete 154x23 control; use unchanged when linking to the Steam sign-in page. |

Archive intake records:

| Archive | Bytes | SHA-256 |
| --- | ---: | --- |
| GitHub `assets/original/github/GitHub_Logos.zip` | 499228 | `e2a67d6cc51d990a52c46c1cf6bcab688db4830982174bca50e0be7a5c2f3194` |
| Google `signin-assets.zip` | 855303 | `ba884069e12093b06bcfd776915081254a7c95094b80d50be2c5dc6bac1c1da1` |
| Kakao `Kakao Login.zip` | 85515 | `7664a07cdd88ac5219282a4580571a169683468e2efc06c8a962dd87068b5600` |
| Naver `NAVER_login_KR.zip` | 196133 | `e589e3c1daf62cfcb6c38906856b953ae955c97d1411b3c3ce85d29e61c4471c` |
| LINE `LINE_Login_Button_Image.zip` | 956497 | `2357d4643557b3eca7c7d83bdd66c5fee7712fedd4f3c1abb75a2ffb30eb9111` |

These records establish provenance, not blanket trademark permission or
provider approval of the package's common button geometry. The 23 remaining
Simple Icons files are never described as official provider artwork.
Historical entries must be rechecked when a current provider asset becomes
available.

GitHub's black and white originals are selected without inversion or
recoloring. Their official origin does not establish permission for package
redistribution or approval of a custom authentication button.

Apple's `color=white` endpoint response is an opaque white 88×88 control with
a black Apple glyph; it is not a recolored copy of the black endpoint response.
Use the light style only where the surrounding surface provides sufficient
contrast, as required by Apple's Sign in with Apple guidance.

The Google ZIP remains recorded because it is the exact source of the
previous no-text square complete-button asset. The current runtime mapping is
the byte-identical direct `g-logo.png` above; it is not extracted, cropped, or
redrawn from the ZIP control.
