import 'dart:ui';

import 'social_button_models.dart';

/// Supported services. Asset identifiers are the enum [name] values.
enum Social {
  facebook,
  github,
  microsoft,
  x,
  line,
  discord,
  linkedin,
  slack,
  twitch,
  spotify,
  steam,
  reddit,
  dropbox,
  gitlab,
  bitbucket,
  paypal,
  telegram,
  instagram,
  wechat,
  pinterest,
  snapchat,
  vk,
  weibo,
  qq,
  epicGames,
  playstation,
  nintendo,
  xbox,
  zoom,
  kakao,
  naver,
  google,
  apple,
  tiktok,
  notion,
}

/// Compatibility name for the original provider API.
typedef SocialLoginProvider = Social;

enum SocialLoginGuidance {
  signInButton,
  generalBrand,
  unverified,
}

enum SocialLoginPaletteBasis {
  signInColors,
  sourceAdapted,
  neutralFallback,
}

/// The provider flow described by the linked first-party documentation.
///
/// This describes product purpose, not what this UI-only package performs.
enum SocialLoginPurpose {
  authentication,
  authorization,
  authenticationAndAuthorization,
  unverified,
}

final class SocialLoginProviderData {
  SocialLoginProviderData._({
    required this.provider,
    required this.displayName,
    required this.labelKo,
    required this.labelEn,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.guidance,
    required this.paletteBasis,
    required this.paletteNotes,
    required List<String> sourceUrls,
    required this.assetGuidance,
    required this.limitations,
    required this.bundledLogoAsset,
    required this.assetOfficial,
    required this.assetSourceUrl,
    required this.assetIdentificationUse,
    required this.assetTransformation,
    required this.assetRedistribution,
    required List<String> assetConditionsSources,
    required this.assetConditionsCheckedOn,
    required this.capabilities,
    required Map<SocialButtonAppearance, SocialButtonAppearanceStyle>
    appearanceStyles,
  }) : sourceUrls = List<String>.unmodifiable(sourceUrls),
       assetConditionsSources = List<String>.unmodifiable(
         assetConditionsSources,
       ),
       appearanceStyles = Map.unmodifiable(appearanceStyles);

  final SocialLoginProvider provider;
  final String displayName;
  final String labelKo;
  final String labelEn;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final SocialLoginGuidance guidance;
  final SocialLoginPaletteBasis paletteBasis;
  /// Why this package chose the palette; never a claim of brand approval.
  final String paletteNotes;
  final List<String> sourceUrls;
  final String assetGuidance;
  final String limitations;
  /// Package asset path for this provider's bundled logo raster.
  ///
  /// Every catalog entry resolves to `assets/social/{provider}.png`.
  /// Applications can still pass an explicit `SocialButton.logo` asset path.
  final String bundledLogoAsset;
  /// Whether the selected file came from the provider.
  ///
  /// This records origin only. It is not provider approval of this package.
  final bool assetOfficial;
  final String assetSourceUrl;
  final String assetIdentificationUse;
  final String assetTransformation;
  final String assetRedistribution;
  final List<String> assetConditionsSources;
  final String assetConditionsCheckedOn;
  final SocialButtonCapabilities capabilities;
  final Map<SocialButtonAppearance, SocialButtonAppearanceStyle>
  appearanceStyles;

  bool get hasBundledLogo => true;

  SocialLoginPurpose get purpose => switch (provider) {
    Social.line ||
    Social.linkedin ||
    Social.slack ||
    Social.steam ||
    Social.telegram ||
    Social.snapchat ||
    Social.vk ||
    Social.epicGames ||
    Social.playstation ||
    Social.xbox ||
    Social.naver ||
    Social.apple => SocialLoginPurpose.authentication,
    Social.x ||
    Social.spotify ||
    Social.dropbox ||
    Social.bitbucket ||
    Social.instagram ||
    Social.pinterest ||
    Social.zoom ||
    Social.notion => SocialLoginPurpose.authorization,
    Social.facebook ||
    Social.github ||
    Social.microsoft ||
    Social.discord ||
    Social.twitch ||
    Social.reddit ||
    Social.gitlab ||
    Social.paypal ||
    Social.wechat ||
    Social.weibo ||
    Social.qq ||
    Social.kakao ||
    Social.google ||
    Social.tiktok => SocialLoginPurpose.authenticationAndAuthorization,
    Social.nintendo => SocialLoginPurpose.unverified,
  };

  String labelFor(Locale locale) =>
      locale.languageCode.toLowerCase() == 'ko' ? labelKo : labelEn;

  SocialButtonAppearanceStyle appearanceStyle(
    SocialButtonAppearance requestedAppearance,
  ) {
    final effective = capabilities.effectiveAppearance(requestedAppearance);
    return appearanceStyles[effective] ??
        SocialButtonAppearanceStyle(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          borderColor: borderColor,
          asset: bundledLogoAsset,
        );
  }
}

// These are color-reference records only. No icons from these datasets ship in
// this package. A recorded general brand color is not an official sign-in spec.
const _brandColorReference =
    'https://raw.githubusercontent.com/simple-icons/simple-icons/'
    'd4e6ba93e48f178898707f0145ec285f28b64b38/data/simple-icons.json';
const _historicalBrandColorReference =
    'https://raw.githubusercontent.com/simple-icons/simple-icons/'
    '11.15.0/_data/simple-icons.json';
const _currentSimpleIconsRevision =
    'd4e6ba93e48f178898707f0145ec285f28b64b38';
const _historicalSimpleIconsRevision = '11.15.0';

String _simpleIconsAssetRevision(Social provider) => switch (provider) {
  Social.linkedin ||
  Social.slack ||
  Social.qq ||
  Social.nintendo ||
  Social.xbox => _historicalSimpleIconsRevision,
  _ => _currentSimpleIconsRevision,
};

String _simpleIconsAssetSlug(Social provider) => switch (provider) {
  Social.weibo => 'sinaweibo',
  Social.qq => 'tencentqq',
  Social.epicGames => 'epicgames',
  _ => provider.name,
};

String _simpleIconsAssetSource(Social provider) =>
    'https://github.com/simple-icons/simple-icons/blob/'
    '${_simpleIconsAssetRevision(provider)}/icons/'
    '${_simpleIconsAssetSlug(provider)}.svg';

String _simpleIconsAssetGuidance(Social provider) =>
    'The bundled PNG is rasterized from the Simple Icons '
    '${_simpleIconsAssetRevision(provider)} '
    '${_simpleIconsAssetSlug(provider)} SVG. The repository is CC0-1.0; '
    'the snapshot states no individual icon license, trademark terms remain '
    'separate, and this is not a provider-supplied asset.';

SocialLoginProviderData _data({
  required SocialLoginProvider provider,
  required String displayName,
  required String labelKo,
  required String labelEn,
  required SocialLoginGuidance guidance,
  required List<String> sourceUrls,
  required String assetGuidance,
  required String limitations,
  required Color backgroundColor,
  Color foregroundColor = const Color(0xFFFFFFFF),
  Color? borderColor,
  SocialLoginPaletteBasis paletteBasis =
      SocialLoginPaletteBasis.sourceAdapted,
  String? bundledLogoAsset,
  String? paletteNotes,
  String? paletteSource,
  String? interactionStateNotes,
  String? officialAssetSource,
  String? assetIdentificationUse,
  String? assetTransformation,
  String? assetRedistribution,
  List<String>? assetConditionsSources,
  Map<SocialButtonAppearance, SocialButtonAppearanceStyle>
  appearanceStyles = const {},
  Map<SocialButtonShape, SocialButtonSupport> shapeSupport = const {},
  Map<SocialButtonShape, SocialButtonLocalizedReason> shapeReasons = const {},
  SocialButtonShape providerDefaultShape = SocialButtonShape.rounded,
  List<String>? capabilitySources,
}) {
  final resolvedSources = [
    ...sourceUrls,
    if (bundledLogoAsset == null) _simpleIconsAssetSource(provider),
    if (paletteSource != null) paletteSource,
  ];
  final resolvedShapes = {
    for (final shape in SocialButtonShape.values)
      shape: shapeSupport[shape] ?? SocialButtonSupport.unverified,
  };
  final resolvedReasons = {
    for (final shape in SocialButtonShape.values)
      shape:
          shapeReasons[shape] ??
          const SocialButtonLocalizedReason(
            en:
                'No first-party authentication-button rule was verified for this shape. The package custom style remains available.',
            ko:
                '이 형태를 다루는 공식 인증 버튼 규칙을 확인하지 못했습니다. 패키지 맞춤 스타일은 계속 사용할 수 있습니다.',
          ),
  };
  return SocialLoginProviderData._(
  provider: provider,
  displayName: displayName,
  labelKo: labelKo,
  labelEn: labelEn,
  backgroundColor: backgroundColor,
  foregroundColor: foregroundColor,
  borderColor: borderColor,
  guidance: guidance,
  paletteBasis: paletteBasis,
  paletteNotes: '${paletteNotes ??
      (paletteSource == _historicalBrandColorReference
          ? 'The general brand color is recorded in historical Simple Icons '
              '11.15.0 data, not independently verified as a current provider '
              'color or sign-in specification. The pairing is a package preset.'
          : paletteSource != null
              ? 'The general brand color is recorded by Simple Icons with a '
                  'source link. This secondary reference is not independent '
                  'verification of official sign-in colors; the pairing and '
                  'contrast-adjusted text are package choices.'
              : 'Base colors come from the linked provider guidance; any '
                  'contrast-adjusted text is a package choice.')} '
      '${interactionStateNotes ??
          'Hover, focus, pressed, and palette-derived disabled colors are '
              'package presets, never provider-approved interaction '
              'specifications.'}',
  sourceUrls: resolvedSources,
  assetGuidance:
      bundledLogoAsset == null
          ? '${_simpleIconsAssetGuidance(provider)} $assetGuidance'
          : assetGuidance,
  limitations: limitations,
  bundledLogoAsset:
      bundledLogoAsset ?? 'assets/social/${provider.name}.png',
  assetOfficial: officialAssetSource != null,
  assetSourceUrl: officialAssetSource ?? _simpleIconsAssetSource(provider),
  assetIdentificationUse: assetIdentificationUse ?? assetGuidance,
  assetTransformation:
      assetTransformation ??
      (officialAssetSource == null
          ? 'The pinned Simple Icons SVG is rasterized to a transparent '
              '128×128 package PNG using the package foreground color.'
          : 'The provider-supplied PNG is bundled byte-for-byte without '
              'recoloring, cropping, rescaling, or repadding.'),
  assetRedistribution: assetRedistribution ?? limitations,
  assetConditionsSources:
      assetConditionsSources ??
      [
        ...sourceUrls,
        officialAssetSource ?? _simpleIconsAssetSource(provider),
      ],
  assetConditionsCheckedOn: '2026-09-30',
  capabilities: SocialButtonCapabilities(
    appearances: [
      SocialButtonAppearance.providerDefault,
      ...appearanceStyles.keys.where(
        (appearance) =>
            appearance != SocialButtonAppearance.providerDefault,
      ),
    ],
    shapes: resolvedShapes,
    shapeReasons: resolvedReasons,
    sources: capabilitySources ?? sourceUrls,
    providerDefaultShape: providerDefaultShape,
  ),
  appearanceStyles: appearanceStyles,
  );
}

final Map<SocialLoginProvider, SocialLoginProviderData> _catalog =
    Map<SocialLoginProvider, SocialLoginProviderData>.unmodifiable({
      SocialLoginProvider.facebook: _data(
        provider: SocialLoginProvider.facebook,
        bundledLogoAsset: 'assets/social/facebook.png',
        officialAssetSource: 'https://www.meta.com/brand/resources/facebook/logo/',
        assetTransformation:
            'Complete provider PNG preserved byte-for-byte; no crop, tint, or repadding.',
        displayName: 'Facebook',
        labelKo: 'Facebook 로그인',
        labelEn: 'Continue with Facebook',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://developers.facebook.com/docs/facebook-login/web/login-button/',
          'https://about.meta.com/brand/resources/facebook/logo/',
        ],
        assetGuidance:
            'Prefer the official JavaScript SDK Login Button; keep it distinct from the general logo ZIP.',
        limitations:
            'Standalone login asset formats, colors, and radius are unverified; the general logo must remain the complete current mark.',
        backgroundColor: const Color(0xFF0866FF),
        paletteSource: _brandColorReference,
      ),
      SocialLoginProvider.github: _data(
        provider: SocialLoginProvider.github,
        displayName: 'GitHub',
        labelKo: 'GitHub 로그인',
        labelEn: 'Continue with GitHub',
        guidance: SocialLoginGuidance.generalBrand,
        sourceUrls: const ['https://github.com/logos'],
        assetGuidance:
            'Use the official Invertocat or wordmark lockup supplied by GitHub.',
        limitations:
            'OAuth integration use is documented, but reusable authentication-button artwork and package redistribution remain permission-sensitive.',
        backgroundColor: const Color(0xFF000000),
        foregroundColor: const Color(0xFFFFFFFF),
        borderColor: null,
        paletteBasis: SocialLoginPaletteBasis.sourceAdapted,
        paletteNotes:
            'GitHub documents black and white marks. This black surface with '
            'white text is a package adaptation, not an OAuth button standard.',
        bundledLogoAsset:
            'assets/original/github/GitHub_Invertocat_White.png',
        officialAssetSource: 'https://brand.github.com/GitHub_Logos.zip',
        assetTransformation:
            'Official white and black Invertocat PNGs are preserved byte-for-byte; appearance selects a supplied original, never an inverted raster.',
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF000000),
            borderColor: Color(0xFFDDDDDD),
            asset: 'assets/original/github/GitHub_Invertocat_Black.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF000000),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/github/GitHub_Invertocat_White.png',
          ),
          SocialButtonAppearance.providerDefault: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF000000),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/github/GitHub_Invertocat_White.png',
          ),
        },
      ),
      SocialLoginProvider.microsoft: _data(
        provider: SocialLoginProvider.microsoft,
        displayName: 'Microsoft',
        labelKo: 'Microsoft 로그인',
        labelEn: 'Sign in with Microsoft',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://learn.microsoft.com/en-us/entra/identity-platform/howto-add-branding-in-apps',
          'https://learn.microsoft.com/en-us/entra/identity-platform/media/howto-add-branding-in-apps/ms-symbollockup_signin_dark.svg',
        ],
        assetGuidance:
            'The package bundles Microsoft’s separately supplied official four-color symbol; prefer a complete official sign-in SVG or PNG when its full control is required.',
        limitations:
            'Do not alter the logo or present Azure or Active Directory as the end-user login brand; the 21×21 symbol is not the complete official sign-in control.',
        backgroundColor: const Color(0xFF2F2F2F),
        paletteNotes:
            'The official dark SVG uses #2F2F2F and white. Reusing its colors '
            'in this common widget is a package adaptation, not the supplied '
            'complete official button.',
        bundledLogoAsset: 'assets/social/microsoft.png',
        officialAssetSource:
            'https://learn.microsoft.com/en-us/entra/identity-platform/media/howto-add-branding-in-apps/ms-symbollockup_mssymbol_19.png',
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF5E5E5E),
            borderColor: Color(0xFF8C8C8C),
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF2F2F2F),
            foregroundColor: Color(0xFFFFFFFF),
          ),
        },
      ),
      SocialLoginProvider.x: _data(
        provider: SocialLoginProvider.x,
        displayName: 'X',
        labelKo: 'X 연결',
        labelEn: 'Connect X',
        guidance: SocialLoginGuidance.generalBrand,
        sourceUrls: const [
          'https://about.x.com/en_us/company/brand-resources.html',
          'https://about.x.com/content/dam/about-twitter/x/brand-toolkit/x-brand-guidelines.pdf',
          'https://developer.x.com/en/developer-terms/display-requirements',
        ],
        assetGuidance: 'Use the current official X toolkit asset.',
        limitations:
            'Post display requirements are not login rules; login dimensions and colors are unverified.',
        backgroundColor: const Color(0xFF000000),
        paletteSource: _brandColorReference,
        bundledLogoAsset: 'assets/social/x.png',
        officialAssetSource:
            'https://about.x.com/content/dam/about-twitter/x/brand-toolkit/x-logo.zip',
        assetTransformation:
            'The official white PNG archive member is bundled byte-for-byte.',
        assetRedistribution:
            'The toolkit is publicly downloadable under the X Brand Guidelines; package redistribution and authentication-button use are not separately stated.',
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF111111),
            borderColor: Color(0xFFDDDDDD),
            asset: 'assets/original/x/logo-black.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF111111),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/x/logo-white.png',
          ),
        },
      ),
      SocialLoginProvider.line: _data(
        provider: SocialLoginProvider.line,
        displayName: 'LINE',
        labelKo: 'LINE 로그인',
        labelEn: 'Log in with LINE',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://developers.line.biz/en/docs/line-login/login-button/',
        ],
        assetGuidance:
            'The package bundles the official logo-only LINE Login PNG. Prefer the complete official template where its full control is required.',
        limitations:
            'Official colors, no-wrap text, proportional spacing, separator, and state rules apply; the package renderer implements the verified values.',
        backgroundColor: const Color(0xFF06C755),
        foregroundColor: const Color(0xFFFFFFFF),
        borderColor: null,
        paletteBasis: SocialLoginPaletteBasis.signInColors,
        bundledLogoAsset: 'assets/social/line.png',
        paletteNotes:
            'LINE specifies the base, white foreground, hover, pressed, '
            'disabled, separator, and disabled-border colors used by this '
            'preset. The surrounding Flutter geometry remains package-rendered.',
        interactionStateNotes:
            'LINE documents the hover, pressed, and disabled colors used here; '
            'the focus treatment remains a package preset.',
        officialAssetSource:
            'https://vos.line-scdn.net/line-developers/docs/media/line-login/login-button/LINE_Login_Button_Image.zip',
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF06C755),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/line/line_88.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF06C755),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/line/line_88.png',
          ),
        },
      ),
      SocialLoginProvider.discord: _data(
        provider: SocialLoginProvider.discord,
        displayName: 'Discord',
        bundledLogoAsset: 'assets/social/discord.png',
        officialAssetSource: 'https://discord.com/branding',
        assetTransformation:
            'Complete provider PNG preserved byte-for-byte; no crop, tint, or repadding.',
        labelKo: 'Discord 로그인',
        labelEn: 'Continue with Discord',
        guidance: SocialLoginGuidance.generalBrand,
        sourceUrls: const [
          'https://discord.com/branding',
          'https://discord.com/developers/docs/topics/oauth2',
        ],
        assetGuidance:
            'Use the official SVG full logo, or the symbol only where Discord context is already clear.',
        limitations:
            'Blurple is a general brand color, not an OAuth button specification.',
        backgroundColor: const Color(0xFF5865F2),
        foregroundColor: const Color(0xFFFFFFFF),
        borderColor: null,
        paletteBasis: SocialLoginPaletteBasis.sourceAdapted,
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF111111),
            borderColor: Color(0xFFDDDDDD),
            asset: 'assets/original/discord/Discord-Symbol-Black.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF111111),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/discord/Discord-Symbol-White.png',
          ),
        },
      ),
      SocialLoginProvider.linkedin: _data(
        provider: SocialLoginProvider.linkedin,
        displayName: 'LinkedIn',
        labelKo: 'LinkedIn 로그인',
        labelEn: 'Continue with LinkedIn',
        guidance: SocialLoginGuidance.generalBrand,
        sourceUrls: const [
          'https://brand.linkedin.com/en-us',
          'https://learn.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin-v2',
          'https://brand.linkedin.com/downloads',
        ],
        assetGuidance:
            'Use an approved LinkedIn Logo or [in] Logo from the official downloads page.',
        limitations:
            'OIDC sign-in is not identity verification, and its visual button specification is unverified.',
        backgroundColor: const Color(0xFF0A66C2),
        paletteSource: _historicalBrandColorReference,
        bundledLogoAsset: 'assets/social/linkedin.png',
        officialAssetSource:
            'https://content.linkedin.com/content/dam/me/business/en-us/amp/xbu/linkedin-revised-brand-guidelines/logos/in-logo.zip',
        assetTransformation:
            'The official white InBug PNG archive member is bundled byte-for-byte.',
        assetRedistribution:
            'LinkedIn supplies the approved logo download under its Brand and User Agreements; package redistribution is not separately stated.',
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF111111),
            borderColor: Color(0xFFDDDDDD),
            asset: 'assets/original/linkedin/LI-In-Bug.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF111111),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/linkedin/InBug-White.png',
          ),
        },
      ),
      SocialLoginProvider.slack: _data(
        provider: SocialLoginProvider.slack,
        bundledLogoAsset: 'assets/social/slack.png',
        officialAssetSource: 'https://slack.com/media-kit',
        assetTransformation:
            'Complete provider PNG preserved byte-for-byte; no crop, tint, or repadding.',
        displayName: 'Slack',
        labelKo: 'Slack 로그인',
        labelEn: 'Sign in with Slack',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://api.slack.com/sign-in-with-slack-button-generator',
          'https://slack.com/brand-guidelines',
          'https://brand.slackhq.com/',
        ],
        assetGuidance:
            'Prefer output from the official Sign in with Slack button generator.',
        limitations:
            'Custom controls must use the exact wording and documented 224×44, 256×48, or 296×56 variants, logo sizes, spacing, and 4px-to-full-height radius range.',
        backgroundColor: const Color(0xFF4A154B),
        paletteSource: _historicalBrandColorReference,
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF000000),
            borderColor: Color(0xFFDDDDDD),
            asset: 'assets/original/slack/SLA-Slack-icon-black-RGB.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF4A154B),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/slack/SLA-Slack-icon-white-RGB.png',
          ),
        },
        shapeSupport: const {
          SocialButtonShape.rounded: SocialButtonSupport.supported,
          SocialButtonShape.pill: SocialButtonSupport.supported,
        },
        shapeReasons: const {
          SocialButtonShape.rounded: SocialButtonLocalizedReason(
            en:
                'Slack permits button corner radii from 4px through the full button height.',
            ko: 'Slack은 버튼 모서리 반경을 4px부터 버튼 전체 높이까지 허용합니다.',
          ),
          SocialButtonShape.pill: SocialButtonLocalizedReason(
            en:
                'Slack permits a full-height radius for its labelled sign-in button.',
            ko: 'Slack은 레이블 로그인 버튼에 전체 높이 반경을 허용합니다.',
          ),
        },
      ),
      SocialLoginProvider.twitch: _data(
        provider: SocialLoginProvider.twitch,
        displayName: 'Twitch',
        labelKo: 'Twitch 로그인',
        labelEn: 'Continue with Twitch',
        guidance: SocialLoginGuidance.generalBrand,
        sourceUrls: const [
          'https://brand.twitch.tv/',
          'https://www.twitch.tv/p/en/legal/trademark/',
        ],
        assetGuidance:
            'Use current official Twitch assets only when the applicable terms or permission allow the intended use.',
        limitations:
            'Separate permission may be required, and general assets do not grant login-button use.',
        backgroundColor: const Color(0xFF9146FF),
        paletteSource: _brandColorReference,
        bundledLogoAsset: 'assets/social/twitch.png',
        officialAssetSource:
            'https://brand.twitch.com/uploads/Twitch-Brand.zip',
        assetTransformation:
            'The official flat white Glitch PNG archive member is bundled byte-for-byte.',
        assetRedistribution:
            'Twitch publishes the brand archive; its trademark guidance keeps third-party marketing and authentication-package redistribution permission-sensitive.',
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF111111),
            borderColor: Color(0xFFDDDDDD),
            asset: 'assets/original/twitch/glitch_flat_black-ops.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF111111),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/twitch/glitch_flat_white.png',
          ),
        },
      ),
      SocialLoginProvider.spotify: _data(
        provider: SocialLoginProvider.spotify,
        displayName: 'Spotify',
        labelKo: 'Spotify 연결',
        labelEn: 'Connect Spotify',
        guidance: SocialLoginGuidance.generalBrand,
         sourceUrls: const [
           'https://developer.spotify.com/documentation/design',
           'https://newsroom.spotify.com/media-kit/logo-and-brand-assets/',
         ],
         assetGuidance:
             'The package bundles Spotify’s official standalone black icon because the full logo cannot fit the common slot; use the full logo where space and context allow.',
        limitations:
            'The full logo minimum is 70px and the icon minimum is 21px with exclusion space; a common 24px slot is not suitable for the full logo.',
        backgroundColor: const Color(0xFF1ED760),
        foregroundColor: const Color(0xFF111111),
        borderColor: null,
        paletteBasis: SocialLoginPaletteBasis.sourceAdapted,
        paletteSource: _brandColorReference,
         bundledLogoAsset: 'assets/social/spotify.png',
         officialAssetSource:
             'https://storage.googleapis.com/pr-newsroom-wp/1/2023/05/Spotify_Primary_Logo_RGB_Black.png',
         assetTransformation:
             'The provider-supplied standalone black icon PNG is preserved under assets/original; the runtime copy is resized to a transparent 128×128 PNG without recoloring or extracting artwork.',
        assetRedistribution:
            'Spotify supplies this asset for integrations under its Developer Terms; package-level redistribution is not separately stated.',
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF111111),
            borderColor: Color(0xFFDDDDDD),
            asset: 'assets/original/spotify/Spotify_Primary_Logo_RGB_Black.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF111111),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/spotify/Spotify_Primary_Logo_RGB_White.png',
          ),
        },
      ),
      SocialLoginProvider.steam: _data(
        provider: SocialLoginProvider.steam,
        bundledLogoAsset: 'assets/social/steam.png',
        officialAssetSource: 'https://partner.steamgames.com/doc/marketing/branding',
        assetTransformation:
            'Complete official website SVG rendered as transparent PNG at 2x; no crop or recolor.',
        displayName: 'Steam',
        labelKo: 'Steam 로그인',
        labelEn: 'Continue with Steam',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://partner.steamgames.com/doc/features/auth',
          'https://partner.steamgames.com/doc/marketing/branding',
        ],
        assetGuidance:
            'Use one of the three complete official Steam OpenID PNG buttons unchanged.',
        limitations:
            'The assets are for Steam OpenID; modification, translation, and use with other authentication flows are unverified.',
        backgroundColor: const Color(0xFF000000),
        paletteSource: _brandColorReference,
      ),
      SocialLoginProvider.reddit: _data(
        provider: SocialLoginProvider.reddit,
        displayName: 'Reddit',
        labelKo: 'Reddit 로그인',
        labelEn: 'Continue with Reddit',
        guidance: SocialLoginGuidance.generalBrand,
        sourceUrls: const ['https://redditinc.com/brand'],
        assetGuidance:
            'Use the official Snoo enclosed icon or logo from the Reddit brand page.',
        limitations:
            'OrangeRed is a general brand color; login specifications, asset format, and permission are unverified.',
        backgroundColor: const Color(0xFFFF4500),
        foregroundColor: const Color(0xFF111111),
        borderColor: null,
        paletteBasis: SocialLoginPaletteBasis.sourceAdapted,
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF111111),
            borderColor: Color(0xFFDDDDDD),
            asset: 'assets/original/reddit/Reddit_Logo.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF111111),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/reddit/Reddit_Logo.png',
          ),
        },
      ),
      SocialLoginProvider.dropbox: _data(
        provider: SocialLoginProvider.dropbox,
        bundledLogoAsset: 'assets/social/dropbox.png',
        officialAssetSource: 'https://brand.dropbox.com/logo',
        assetTransformation:
            'Complete provider PNG preserved byte-for-byte; no crop, tint, or repadding.',
        displayName: 'Dropbox',
        labelKo: 'Dropbox 연결',
        labelEn: 'Connect Dropbox',
        guidance: SocialLoginGuidance.generalBrand,
        sourceUrls: const [
          'https://brand.dropbox.com/logo',
          'https://brand.dropbox.com/color',
        ],
        assetGuidance:
            'Use the official full Dropbox logo for a general brand context.',
        limitations:
            'The Tab or glyph is not documented as a login icon, and numeric login colors are unverified.',
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF111111),
        borderColor: const Color(0xFFDDDDDD),
        paletteSource: _brandColorReference,
      ),
      SocialLoginProvider.gitlab: _data(
        provider: SocialLoginProvider.gitlab,
        displayName: 'GitLab',
        bundledLogoAsset: 'assets/social/gitlab.png',
        officialAssetSource: 'https://about.gitlab.com/press/press-kit/',
        assetTransformation:
            'Complete provider PNG preserved byte-for-byte; no crop, tint, or repadding.',
        labelKo: 'GitLab 로그인',
        labelEn: 'Continue with GitLab',
        guidance: SocialLoginGuidance.generalBrand,
        sourceUrls: const [
          'https://about.gitlab.com/press/press-kit/',
          'https://handbook.gitlab.com/handbook/marketing/brand-and-product-marketing/brand/brand-activation/trademark-guidelines/',
        ],
        assetGuidance:
            'Use an official RGB SVG, with an official PNG as the raster alternative.',
        limitations:
            'Public trademark terms restrict generic third-party logo use; a press-kit download is not permission to redistribute login artwork.',
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF111111),
        borderColor: const Color(0xFFDDDDDD),
        paletteBasis: SocialLoginPaletteBasis.sourceAdapted,
        paletteSource: _brandColorReference,
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF111111),
            borderColor: Color(0xFFDDDDDD),
            asset: 'assets/original/gitlab/gitlab-logo-500-rgb.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF111111),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/gitlab/gitlab-logo-500-rgb.png',
          ),
        },
      ),
      SocialLoginProvider.bitbucket: _data(
        provider: SocialLoginProvider.bitbucket,
        displayName: 'Bitbucket',
        labelKo: 'Bitbucket 연결',
        labelEn: 'Connect Bitbucket',
        guidance: SocialLoginGuidance.generalBrand,
        sourceUrls: const [
          'https://atlassian.design/foundations/logos/',
        ],
        assetGuidance:
            'Choose the official Bitbucket app logo or attribution logo according to its documented context.',
        limitations:
            'General guidance restricts extra containers around the logomark; the common circle shape is not an approved treatment.',
        backgroundColor: const Color(0xFF0052CC),
        paletteSource: _brandColorReference,
        bundledLogoAsset: 'assets/social/bitbucket.png',
        officialAssetSource:
            'https://atlassian.design/assets/599d0f58b052/logos/bitbucket_app.zip',
        assetTransformation:
            'The official Bitbucket app-icon PNG archive member is bundled byte-for-byte.',
        assetRedistribution:
            'Atlassian supplies the app-logo archive for documented app contexts; redistribution inside a generic login package is not separately stated.',
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF111111),
            borderColor: Color(0xFFDDDDDD),
            asset: 'assets/original/bitbucket/Bitbucket_icon.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF111111),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/bitbucket/Bitbucket_icon.png',
          ),
        },
      ),
      SocialLoginProvider.paypal: _data(
        provider: SocialLoginProvider.paypal,
        displayName: 'PayPal',
        bundledLogoAsset: 'assets/social/paypal.png',
        officialAssetSource: 'https://newsroom.paypal-corp.com/media-resources',
        assetTransformation:
            'Complete provider PNG preserved byte-for-byte; no crop, tint, or repadding.',
        labelKo: 'PayPal 로그인',
        labelEn: 'Log in with PayPal',
        guidance: SocialLoginGuidance.generalBrand,
        sourceUrls: const [
          'https://newsroom.paypal-corp.com/media-resources',
          'https://developer.paypal.com/docs/log-in-with-paypal/',
        ],
        assetGuidance:
            'Use an official black or white PayPal PNG appropriate to the surrounding surface.',
        limitations:
            'The login documentation body was access-limited, and newsroom assets are not confirmed for authentication UI.',
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF111111),
        borderColor: const Color(0xFFDDDDDD),
        paletteBasis: SocialLoginPaletteBasis.sourceAdapted,
        paletteSource: _brandColorReference,
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF111111),
            borderColor: Color(0xFFDDDDDD),
            asset: 'assets/original/paypal/PayPal-Monogram-FullColor-RGB.png',
          ),
        },
      ),
      SocialLoginProvider.telegram: _data(
        provider: SocialLoginProvider.telegram,
        displayName: 'Telegram',
        bundledLogoAsset: 'assets/social/telegram.png',
        officialAssetSource: 'https://telegram.org/tour/screenshots',
        assetTransformation:
            'Complete provider PNG preserved byte-for-byte; no crop, tint, or repadding.',
        labelKo: 'Telegram 로그인',
        labelEn: 'Continue with Telegram',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://core.telegram.org/widgets/login',
          'https://telegram.org/tour/screenshots',
        ],
        assetGuidance:
            'Use the generated Telegram Login control or the official native SDK.',
        limitations:
            'Prefer the official control over reconstructing a standalone logo; custom-button permission is unverified.',
        backgroundColor: const Color(0xFF26A5E4),
        foregroundColor: const Color(0xFF111111),
        paletteSource: _brandColorReference,
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF111111),
            borderColor: Color(0xFFDDDDDD),
            asset: 'assets/original/telegram/Logo.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF111111),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/telegram/Logo.png',
          ),
        },
      ),
      SocialLoginProvider.instagram: _data(
        provider: SocialLoginProvider.instagram,
        bundledLogoAsset: 'assets/social/instagram.png',
        officialAssetSource: 'https://www.meta.com/brand/resources/instagram/instagram-brand/',
        assetTransformation:
            'Complete provider PNG preserved byte-for-byte; no crop, tint, or repadding.',
        displayName: 'Instagram',
        labelKo: 'Instagram 연결',
        labelEn: 'Connect Instagram',
        guidance: SocialLoginGuidance.generalBrand,
        sourceUrls: const [
          'https://www.meta.com/brand/resources/instagram/instagram-brand/',
          'https://developers.facebook.com/docs/instagram-platform/instagram-api-with-instagram-login/',
        ],
        assetGuidance: 'Use an approved asset from the official Logo Pack.',
        limitations:
            'Do not modify or translate the Instagram name; the professional-account API does not guarantee general consumer login.',
        backgroundColor: const Color(0xFFFF0069),
        foregroundColor: const Color(0xFF111111),
        paletteSource: _brandColorReference,
      ),
      SocialLoginProvider.wechat: _data(
        provider: SocialLoginProvider.wechat,
        displayName: 'WeChat',
        labelKo: 'WeChat 로그인',
        labelEn: 'Continue with WeChat',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://developers.weixin.qq.com/doc/oplatform/en/Website_App/WeChat_Login/Wechat_Login.html',
          'https://wechat.design/brand/main-brand',
        ],
        assetGuidance: 'Use the official JavaScript QR login surface.',
        limitations:
            'QR widget style options are not evidence for this package’s circular button.',
        backgroundColor: const Color(0xFF07C160),
        foregroundColor: const Color(0xFF111111),
        paletteSource: _brandColorReference,
      ),
      SocialLoginProvider.pinterest: _data(
        provider: SocialLoginProvider.pinterest,
        displayName: 'Pinterest',
        labelKo: 'Pinterest 연결',
        labelEn: 'Connect Pinterest',
        guidance: SocialLoginGuidance.generalBrand,
        sourceUrls: const [
          'https://business.pinterest.com/en/brand-guidelines/',
        ],
        assetGuidance:
            'Use the official enclosed Pinterest badge in EPS or high-resolution PNG.',
        limitations:
            'Marketing calls to action are not authentication copy specifications.',
        backgroundColor: const Color(0xFFBD081C),
        paletteSource: _brandColorReference,
      ),
      SocialLoginProvider.snapchat: _data(
        provider: SocialLoginProvider.snapchat,
        bundledLogoAsset: 'assets/social/snapchat.png',
        officialAssetSource: 'https://www.snap.com/brand-guidelines',
        assetTransformation:
            'Complete provider PNG preserved byte-for-byte; no crop, tint, or repadding.',
        displayName: 'Snapchat',
        labelKo: 'Snapchat 로그인',
        labelEn: 'Log in with Snapchat',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://developers.snap.com/snap-kit/login-kit/overview',
          'https://developers.snap.com/snap-kit/app-review/brand-guidelines',
          'https://www.snap.com/en-US/brand-guidelines',
        ],
        assetGuidance:
            'Use the Login Kit wording and an official Ghost asset when the applicable guidance permits it.',
        limitations:
            'Exact button dimensions and colors are unverified, and the app must not be presented as Snapchat.',
        backgroundColor: const Color(0xFFFFFC00),
        foregroundColor: const Color(0xFF111111),
        paletteSource: _brandColorReference,
      ),
      SocialLoginProvider.vk: _data(
        provider: SocialLoginProvider.vk,
        displayName: 'VK',
        labelKo: 'VK 로그인',
        labelEn: 'Continue with VK',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://github.com/VKCOM/vkid-web-sdk',
          'https://id.vk.ru/about/business/go/docs/ru/vkid/latest/vk-id/connection/guidelines/design-rules-oauth',
          'https://vk.com/brand',
        ],
        assetGuidance: 'Use the official VK ID OneTap control or SDK.',
        limitations:
            'The custom example specifies white content, 8px radius, 44px minimum height, 28px icon, 8×10px padding, and opacity states; SDK OneTap remains preferred.',
        backgroundColor: const Color(0xFF0077FF),
        foregroundColor: const Color(0xFFFFFFFF),
        paletteBasis: SocialLoginPaletteBasis.signInColors,
        paletteNotes:
            'The official VK ID custom-button example supplies the blue '
            'background and white foreground. CSS opacity and active scaling '
            'cannot be reproduced independently of the host surface.',
        interactionStateNotes:
            'The VK ID custom-button example documents hover and active '
            'opacity; focus and disabled treatments remain package presets.',
        shapeSupport: const {
          SocialButtonShape.rounded: SocialButtonSupport.supported,
          SocialButtonShape.pill: SocialButtonSupport.supported,
        },
        shapeReasons: const {
          SocialButtonShape.rounded: SocialButtonLocalizedReason(
            en:
                'VK ID documents an 8px example and permits rounding that follows the app design system.',
            ko: 'VK ID는 8px 예시와 앱 디자인 시스템을 따르는 둥근 모서리를 허용합니다.',
          ),
          SocialButtonShape.pill: SocialButtonLocalizedReason(
            en:
                'VK ID explicitly documents fully pill-rounded custom buttons.',
            ko: 'VK ID는 완전한 필 형태의 맞춤 버튼을 명시적으로 문서화합니다.',
          ),
        },
      ),
      SocialLoginProvider.weibo: _data(
        provider: SocialLoginProvider.weibo,
        displayName: 'Weibo',
        bundledLogoAsset: 'assets/social/weibo.png',
        officialAssetSource: 'https://open.weibo.com/wiki/%E5%BE%AE%E5%8D%9A%E6%A0%87%E8%AF%86',
        assetTransformation:
            'Complete provider PNG preserved byte-for-byte; no crop, tint, or repadding.',
        labelKo: 'Weibo 로그인',
        labelEn: 'Continue with Weibo',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://open.weibo.com/wiki/Connect/login',
          'https://open.weibo.com/widget/loginbutton.php',
        ],
        assetGuidance: 'Use the official Weibo configurator output.',
        limitations:
            'Confirm that its fixed legacy sizes remain appropriate after the 2020 JavaScript SDK changes.',
        backgroundColor: const Color(0xFFE6162D),
        paletteSource: _brandColorReference,
        paletteNotes:
            'Simple Icons records #E6162D with Wikipedia as its source. This '
            'red package preset is not independently verified against current '
            'Weibo brand or sign-in color specifications.',
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF111111),
            borderColor: Color(0xFFDDDDDD),
            asset: 'assets/original/weibo/LOGO_64x64.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF111111),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/weibo/LOGO_64x64.png',
          ),
        },
      ),
      SocialLoginProvider.qq: _data(
        provider: SocialLoginProvider.qq,
        bundledLogoAsset: 'assets/social/qq.png',
        officialAssetSource: 'https://wiki.connect.qq.com/%E8%A7%86%E8%A7%89%E7%B4%A0%E6%9D%90%E4%B8%8B%E8%BD%BD',
        assetTransformation:
            'Complete provider PSD composite converted to PNG with identical decoded pixels; no crop or recolor.',
        displayName: 'QQ',
        labelKo: 'QQ 로그인',
        labelEn: 'Continue with QQ',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://wiki.connect.qq.com/js_sdk%e4%bd%bf%e7%94%a8%e8%af%b4%e6%98%8e',
          'https://wiki.connect.qq.com/?s=QQ%E7%99%BB%E5%BD%95%E6%8C%89%E9%92%AE',
          'https://qq.design/brand/BrandDesign/Logo',
        ],
        assetGuidance:
            'Use QQ Connect QC.Login so the official control is generated.',
        limitations:
            'Official size and icon restrictions apply; English and Korean translations in this package are unverified.',
        backgroundColor: const Color(0xFF1EBAFC),
        foregroundColor: const Color(0xFF111111),
        paletteSource: _historicalBrandColorReference,
        paletteNotes:
            'Historical Simple Icons 11.15.0 records #1EBAFC via a Wikipedia '
            'asset and links QQ brand guidance. This blue package preset is '
            'not independently verified as a current QQ or sign-in color.',
      ),
      SocialLoginProvider.epicGames: _data(
        provider: SocialLoginProvider.epicGames,
        displayName: 'Epic Games',
        bundledLogoAsset: 'assets/social/epicGames.png',
        officialAssetSource: 'https://dev.epicgames.com/docs/epic-online-services/accounts-and-social/eos-epic-account-services/epic-account-services-design-guidelines?lang=en-US',
        assetTransformation:
            'Complete provider PNG preserved byte-for-byte; no crop, tint, or repadding.',
        labelKo: 'Epic Games 로그인',
        labelEn: 'Continue with Epic Games',
        guidance: SocialLoginGuidance.unverified,
        sourceUrls: const [
          'https://onlineservices.epicgames.com/en-US/services-games',
          'https://www.epicgames.com/site/en-US/tos',
        ],
        assetGuidance:
            'Confirm current approved assets through the Epic partner or developer channel.',
        limitations:
            'The former brand URL returns 404; public login assets, colors, and permission are unverified.',
        backgroundColor: const Color(0xFF313131),
        paletteSource: _brandColorReference,
      ),
      SocialLoginProvider.playstation: _data(
        provider: SocialLoginProvider.playstation,
        displayName: 'PlayStation',
        labelKo: 'PlayStation 로그인',
        labelEn: 'Continue with PlayStation',
        guidance: SocialLoginGuidance.unverified,
        sourceUrls: const [
          'https://www.playstation.com/en-us/legal/copyright-and-trademark-notice/',
          'https://www.playstation.com/en-us/legal/psn-terms-of-service/',
        ],
        assetGuidance:
            'Use only assets supplied for the applicable PlayStation partner integration.',
        limitations:
            'Public mark reuse requires express written consent; gated partner asset terms were not available for verification.',
        backgroundColor: const Color(0xFF0070D1),
        paletteSource: _brandColorReference,
      ),
      SocialLoginProvider.nintendo: _data(
        provider: SocialLoginProvider.nintendo,
        displayName: 'Nintendo',
        labelKo: 'Nintendo 로그인',
        labelEn: 'Continue with Nintendo',
        guidance: SocialLoginGuidance.unverified,
        sourceUrls: const [
          'https://www.nintendo.com/',
          'https://www.nintendo.co.jp/networkservice_guideline/en/index.html',
        ],
        assetGuidance:
            'Use only assets supplied through the applicable Nintendo partner channel.',
        limitations:
            'Game-content sharing guidance is not permission for a Nintendo Account login control.',
        backgroundColor: const Color(0xFFE60012),
        paletteSource: _historicalBrandColorReference,
      ),
      SocialLoginProvider.xbox: _data(
        provider: SocialLoginProvider.xbox,
        displayName: 'Xbox',
        labelKo: 'Xbox 로그인',
        labelEn: 'Continue with Xbox',
        guidance: SocialLoginGuidance.generalBrand,
        sourceUrls: const [
          'https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks',
        ],
        assetGuidance:
            'Use approved Xbox developer or partner assets for the intended integration.',
        limitations:
            'A Microsoft account button is not interchangeable; many Xbox logo and icon uses require a license, and no public reusable Xbox login control was verified.',
        backgroundColor: const Color(0xFF107C10),
        paletteSource: _historicalBrandColorReference,
      ),
      SocialLoginProvider.zoom: _data(
        provider: SocialLoginProvider.zoom,
        bundledLogoAsset: 'assets/social/zoom.png',
        officialAssetSource: 'https://www.zoom.com/en/about/media-kit/',
        assetTransformation:
            'Complete provider PNG preserved byte-for-byte; no crop, tint, or repadding.',
        displayName: 'Zoom',
        labelKo: 'Zoom 연결',
        labelEn: 'Connect Zoom',
        guidance: SocialLoginGuidance.unverified,
        sourceUrls: const [
          'https://brand.zoom.us/',
          'https://developers.zoom.us/docs/integrations/oauth/',
        ],
        assetGuidance:
            'Confirm assets and permitted use through the Zoom Brand Center or partner channel.',
        limitations:
            'OAuth documentation is not button design guidance, and the portal theme color is not a login color.',
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF111111),
        borderColor: const Color(0xFFDDDDDD),
        paletteSource: _brandColorReference,
      ),
      SocialLoginProvider.kakao: _data(
        provider: SocialLoginProvider.kakao,
        displayName: 'Kakao',
        labelKo: '카카오 로그인',
        labelEn: 'Login with Kakao',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://developers.kakao.com/docs/latest/ko/kakaologin/design-guide',
        ],
        assetGuidance:
            'The package bundles the official compact Kakao Login PNG. Prefer the complete official PNG, or use the PSD for permitted modifications.',
        limitations:
            'Official symbol, colors, labels, and 12px radius apply. The guide’s 30-point standard-control typography is not copied as 30 logical pixels into this compact shared renderer.',
        backgroundColor: const Color(0xFFFEE500),
        foregroundColor: const Color(0xD9000000),
        borderColor: null,
        paletteBasis: SocialLoginPaletteBasis.signInColors,
        bundledLogoAsset: 'assets/social/kakao.png',
        officialAssetSource:
            'https://developers.kakao.com/tool/resource/login',
        shapeSupport: const {
          SocialButtonShape.rounded: SocialButtonSupport.supported,
          SocialButtonShape.pill: SocialButtonSupport.restricted,
          SocialButtonShape.circle: SocialButtonSupport.restricted,
        },
        shapeReasons: const {
          SocialButtonShape.rounded: SocialButtonLocalizedReason(
            en:
                'Kakao Login specifies a 12px container corner radius for its supplied control.',
            ko: '카카오 로그인은 제공 컨트롤의 컨테이너 모서리 반경을 12px로 지정합니다.',
          ),
          SocialButtonShape.pill: SocialButtonLocalizedReason(
            en:
                'Kakao Login fixes the container radius at 12px; a full-height pill conflicts with that control rule.',
            ko: '카카오 로그인은 컨테이너 반경을 12px로 고정하므로 전체 높이 필 형태는 해당 규칙과 충돌합니다.',
          ),
          SocialButtonShape.circle: SocialButtonLocalizedReason(
            en:
                'Kakao Login fixes the container radius at 12px and requires the supplied symbol-and-container treatment.',
            ko: '카카오 로그인은 컨테이너 반경을 12px로 고정하고 제공된 심볼·컨테이너 구성을 요구합니다.',
          ),
        },
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFEE500),
            foregroundColor: Color(0xD9000000),
            asset: 'assets/original/kakao/kakao_login_light.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFEE500),
            foregroundColor: Color(0xD9000000),
            asset: 'assets/original/kakao/kakao_login_light.png',
          ),
        },
      ),
      SocialLoginProvider.naver: _data(
        provider: SocialLoginProvider.naver,
        displayName: 'Naver',
        labelKo: '네이버 로그인',
        labelEn: 'Log in with Naver',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://developers.naver.com/docs/login/bi/bi.md',
        ],
        assetGuidance:
            'The package bundles the official dark-green Naver icon PNG. Prefer the complete Korean or English asset where its full control is required.',
        limitations:
            'Official colors, 16px complete-button N minimum, and 8px centered spacing apply; the bundled 224px template includes substantial internal padding.',
        backgroundColor: const Color(0xFF05AC4F),
        foregroundColor: const Color(0xFFFFFFFF),
        borderColor: null,
        paletteBasis: SocialLoginPaletteBasis.signInColors,
        bundledLogoAsset: 'assets/social/naver.png',
        paletteNotes:
            'The active background matches the dominant opaque #05AC4F pixels '
            'in the preserved provider-supplied green icon PNG; Naver specifies '
            'a green background with a white logo and label. '
            'The package sizes the complete icon template from its measured '
            'internal N bounds rather than treating its canvas as a raw glyph.',
        officialAssetSource:
            'https://developers.naver.com/inc/devcenter/downloads/bi/NAVER_login_KR.zip',
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF03A94D),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/naver/NAVER_login_Light_KR_green_icon_H56.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF05AC4F),
            foregroundColor: Color(0xFFFFFFFF),
            asset: 'assets/original/naver/NAVER_login_Dark_KR_green_icon_H56.png',
          ),
        },
      ),
      SocialLoginProvider.google: _data(
        provider: SocialLoginProvider.google,
        displayName: 'Google',
        labelKo: 'Google 로그인',
        labelEn: 'Sign in with Google',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://developers.google.com/identity/branding-guidelines',
          'https://developers.google.com/static/identity/images/g-logo.png',
          'https://developers.google.com/static/identity/images/signin-assets.zip',
        ],
        assetGuidance:
            'The package bundles the official standard-color gradient G linked '
            'by the custom-button guidance. Prefer the Google Identity '
            'Services control or complete pre-approved button where required.',
        limitations:
            'Keep the G at the documented 20px Android/Web footprint with 12px '
            'leading and 10px trailing space; this common widget is not the '
            'Google-rendered control.',
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF1F1F1F),
        borderColor: const Color(0xFF747775),
        paletteBasis: SocialLoginPaletteBasis.signInColors,
        bundledLogoAsset: 'assets/social/google.png',
        officialAssetSource:
            'https://developers.google.com/static/identity/images/g-logo.png',
        assetTransformation:
            'The provider-supplied PNG is bundled byte-for-byte. Flutter '
            'scales it proportionally into the documented 20 logical-pixel '
            'logo footprint without cropping, recoloring, or repadding.',
        assetRedistribution:
            'Google permits the standard-color G in a guideline-conforming '
            'custom Sign in with Google button; uses outside that guide '
            'require consent.',
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF1F1F1F),
            borderColor: Color(0xFF747775),
            logoBackgroundColor: Color(0xFFFFFFFF),
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF131314),
            foregroundColor: Color(0xFFE3E3E3),
            borderColor: Color(0xFF8E918F),
            logoBackgroundColor: Color(0xFFFFFFFF),
          ),
        },
        shapeSupport: const {
          SocialButtonShape.rounded: SocialButtonSupport.supported,
          SocialButtonShape.pill: SocialButtonSupport.supported,
          SocialButtonShape.circle: SocialButtonSupport.supported,
        },
        shapeReasons: const {
          SocialButtonShape.rounded: SocialButtonLocalizedReason(
            en:
                'Google supplies rectangular controls and permits a guideline-conforming custom button boundary.',
            ko: 'Google은 직사각형 컨트롤을 제공하고 가이드에 맞는 맞춤 버튼 경계를 허용합니다.',
          ),
          SocialButtonShape.pill: SocialButtonLocalizedReason(
            en:
                'Google supplies pre-approved pill-shaped light, neutral, and dark controls.',
            ko: 'Google은 사전 승인된 라이트·뉴트럴·다크 필 형태 컨트롤을 제공합니다.',
          ),
          SocialButtonShape.circle: SocialButtonLocalizedReason(
            en:
                'Google supplies round icon controls and permits the G alone when used as an action button.',
            ko: 'Google은 원형 아이콘 컨트롤을 제공하며 액션 버튼에서는 G 단독 사용을 허용합니다.',
          ),
        },
      ),
      SocialLoginProvider.apple: _data(
        provider: SocialLoginProvider.apple,
        displayName: 'Apple',
        labelKo: 'Apple 로그인',
        labelEn: 'Sign in with Apple',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://developer.apple.com/documentation/signinwithapple/incorporating-sign-in-with-apple-into-other-platforms',
          'https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple',
          'https://account.apple.com/signinwithapple/button',
        ],
        assetGuidance:
            'The package bundles Apple’s generated black and white sign-in logo PNGs. Prefer the official system button on Apple platforms or JavaScript control on the web.',
        limitations:
            'Generated PNG query ranges describe that endpoint, not a universal maximum for an expanding Flutter parent. Apple requires sufficient contrast around the white style; prefer platform controls where available.',
        backgroundColor: const Color(0xFF000000),
        foregroundColor: const Color(0xFFFFFFFF),
        borderColor: null,
        paletteBasis: SocialLoginPaletteBasis.sourceAdapted,
        paletteNotes:
            'Apple supplies black, white, and white-outline system-button '
            'styles. These package presets preserve generated black and white '
            'artwork but do not reproduce or replace the system button.',
        bundledLogoAsset: 'assets/social/apple.png',
        officialAssetSource:
            'https://appleid.cdn-apple.com/appleid/button/logo?size=44&color=black&border=false&border_radius=8&scale=2',
        appearanceStyles: const {
          SocialButtonAppearance.light: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFFFFFFFF),
            foregroundColor: Color(0xFF000000),
            asset: 'assets/social/apple-light.png',
          ),
          SocialButtonAppearance.dark: SocialButtonAppearanceStyle(
            backgroundColor: Color(0xFF000000),
            foregroundColor: Color(0xFFFFFFFF),
          ),
        },
        shapeSupport: const {
          SocialButtonShape.rounded: SocialButtonSupport.supported,
          SocialButtonShape.pill: SocialButtonSupport.supported,
          SocialButtonShape.circle: SocialButtonSupport.supported,
        },
        shapeReasons: const {
          SocialButtonShape.rounded: SocialButtonLocalizedReason(
            en:
                'Apple generated buttons accept a documented corner radius from 0 through 50 points.',
            ko: 'Apple 생성 버튼은 0~50포인트의 문서화된 모서리 반경을 허용합니다.',
          ),
          SocialButtonShape.pill: SocialButtonLocalizedReason(
            en:
                'Apple permits radii up to 50 points, covering a full-height pill within the documented button sizes.',
            ko: 'Apple은 최대 50포인트 반경을 허용해 문서화된 버튼 크기에서 필 형태를 지원합니다.',
          ),
          SocialButtonShape.circle: SocialButtonLocalizedReason(
            en:
                'Apple provides square logo-only controls with configurable radius up to 50 points.',
            ko: 'Apple은 최대 50포인트 반경을 설정할 수 있는 정사각 로고 전용 컨트롤을 제공합니다.',
          ),
        },
      ),
      SocialLoginProvider.tiktok: _data(
        provider: SocialLoginProvider.tiktok,
        displayName: 'TikTok',
        bundledLogoAsset: 'assets/social/tiktok.png',
        officialAssetSource: 'https://developers.tiktok.com/doc/getting-started-design-guidelines',
        assetTransformation:
            'Complete provider PNG preserved byte-for-byte; no crop, tint, or repadding.',
        labelKo: 'TikTok 로그인',
        labelEn: 'Continue with TikTok',
        guidance: SocialLoginGuidance.signInButton,
        sourceUrls: const [
          'https://developers.tiktok.com/doc/getting-started-design-guidelines',
          'https://developers.tiktok.com/doc/login-kit-web',
          'https://tiktokbrandbook.com/d/HhXfjVK1Poj9/legal',
        ],
        assetGuidance: 'Use the official TikTok Logo and Button pack.',
        limitations:
            'An official Logo and Button ZIP is public, but accessible terms do not establish blanket package-redistribution permission or expose exact visual tokens.',
        backgroundColor: const Color(0xFF000000),
        paletteSource: _brandColorReference,
      ),
      SocialLoginProvider.notion: _data(
        provider: SocialLoginProvider.notion,
        bundledLogoAsset: 'assets/social/notion.png',
        officialAssetSource: 'https://notion.notion.site/Media-Kit-205535b1d9c4440497a3d7a2ac096286',
        assetTransformation:
            'Complete provider PNG preserved byte-for-byte; no crop, tint, or repadding.',
        displayName: 'Notion',
        labelKo: 'Notion 연결',
        labelEn: 'Connect Notion',
        guidance: SocialLoginGuidance.unverified,
        sourceUrls: const [
          'https://developers.notion.com/guides/get-started/authorization',
          'https://developers.notion.com/guides/get-started/public-connections',
          'https://www.notion.com/brand',
        ],
        assetGuidance:
            'Prefer a permitted official Notion asset when production use '
            'requires provider-supplied artwork.',
        limitations:
            'OAuth installs and authorizes a workspace connection; it is not a '
            'generic identity-provider login. Caller-button colors, geometry, '
            'and logo redistribution remain unverified.',
        backgroundColor: const Color(0xFF000000),
        paletteSource: _brandColorReference,
        paletteNotes:
            'A monochrome package preset consistent with the Simple Icons '
            'Notion record. It is a package choice for a connection action, '
            'not a provider-approved authorization button.',
      ),
    });

SocialLoginProviderData socialLoginProviderData(
  SocialLoginProvider provider,
) => _catalog[provider]!;
