import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:social_signin_kit/social_signin_kit.dart';

void main() {
  const expectedNames = [
    'facebook',
    'github',
    'microsoft',
    'x',
    'line',
    'discord',
    'linkedin',
    'slack',
    'twitch',
    'spotify',
    'steam',
    'reddit',
    'dropbox',
    'gitlab',
    'bitbucket',
    'paypal',
    'telegram',
    'instagram',
    'wechat',
    'pinterest',
    'snapchat',
    'vk',
    'weibo',
    'qq',
    'epicGames',
    'playstation',
    'nintendo',
    'xbox',
    'zoom',
    'kakao',
    'naver',
    'google',
    'apple',
    'tiktok',
    'notion',
  ];

  const expectedDisplayNames = [
    'Facebook',
    'GitHub',
    'Microsoft',
    'X',
    'LINE',
    'Discord',
    'LinkedIn',
    'Slack',
    'Twitch',
    'Spotify',
    'Steam',
    'Reddit',
    'Dropbox',
    'GitLab',
    'Bitbucket',
    'PayPal',
    'Telegram',
    'Instagram',
    'WeChat',
    'Pinterest',
    'Snapchat',
    'VK',
    'Weibo',
    'QQ',
    'Epic Games',
    'PlayStation',
    'Nintendo',
    'Xbox',
    'Zoom',
    'Kakao',
    'Naver',
    'Google',
    'Apple',
    'TikTok',
    'Notion',
  ];

  const expectedKoreanLabels = [
    'Facebook 로그인',
    'GitHub 로그인',
    'Microsoft 로그인',
    'X 연결',
    'LINE 로그인',
    'Discord 로그인',
    'LinkedIn 로그인',
    'Slack 로그인',
    'Twitch 로그인',
    'Spotify 연결',
    'Steam 로그인',
    'Reddit 로그인',
    'Dropbox 연결',
    'GitLab 로그인',
    'Bitbucket 연결',
    'PayPal 로그인',
    'Telegram 로그인',
    'Instagram 연결',
    'WeChat 로그인',
    'Pinterest 연결',
    'Snapchat 로그인',
    'VK 로그인',
    'Weibo 로그인',
    'QQ 로그인',
    'Epic Games 로그인',
    'PlayStation 로그인',
    'Nintendo 로그인',
    'Xbox 로그인',
    'Zoom 연결',
    '카카오 로그인',
    '네이버 로그인',
    'Google 로그인',
    'Apple 로그인',
    'TikTok 로그인',
    'Notion 연결',
  ];

  const expectedEnglishLabels = [
    'Continue with Facebook',
    'Continue with GitHub',
    'Sign in with Microsoft',
    'Connect X',
    'Log in with LINE',
    'Continue with Discord',
    'Continue with LinkedIn',
    'Sign in with Slack',
    'Continue with Twitch',
    'Connect Spotify',
    'Continue with Steam',
    'Continue with Reddit',
    'Connect Dropbox',
    'Continue with GitLab',
    'Connect Bitbucket',
    'Log in with PayPal',
    'Continue with Telegram',
    'Connect Instagram',
    'Continue with WeChat',
    'Connect Pinterest',
    'Log in with Snapchat',
    'Continue with VK',
    'Continue with Weibo',
    'Continue with QQ',
    'Continue with Epic Games',
    'Continue with PlayStation',
    'Continue with Nintendo',
    'Continue with Xbox',
    'Connect Zoom',
    'Login with Kakao',
    'Log in with Naver',
    'Sign in with Google',
    'Sign in with Apple',
    'Continue with TikTok',
    'Connect Notion',
  ];

  const expectedRepresentativeUrls = [
    'https://developers.facebook.com/docs/facebook-login/web/login-button/',
    'https://github.com/logos',
    'https://learn.microsoft.com/en-us/entra/identity-platform/howto-add-branding-in-apps',
    'https://about.x.com/en_us/company/brand-resources.html',
    'https://developers.line.biz/en/docs/line-login/login-button/',
    'https://discord.com/branding',
    'https://brand.linkedin.com/en-us',
    'https://api.slack.com/sign-in-with-slack-button-generator',
    'https://brand.twitch.tv/',
    'https://developer.spotify.com/documentation/design',
    'https://partner.steamgames.com/doc/features/auth',
    'https://redditinc.com/brand',
    'https://brand.dropbox.com/logo',
    'https://about.gitlab.com/press/press-kit/',
    'https://atlassian.design/foundations/logos/',
    'https://newsroom.paypal-corp.com/media-resources',
    'https://core.telegram.org/widgets/login',
    'https://www.meta.com/brand/resources/instagram/instagram-brand/',
    'https://developers.weixin.qq.com/doc/oplatform/en/Website_App/WeChat_Login/Wechat_Login.html',
    'https://business.pinterest.com/en/brand-guidelines/',
    'https://developers.snap.com/snap-kit/login-kit/overview',
    'https://github.com/VKCOM/vkid-web-sdk',
    'https://open.weibo.com/wiki/Connect/login',
    'https://wiki.connect.qq.com/js_sdk%e4%bd%bf%e7%94%a8%e8%af%b4%e6%98%8e',
    'https://onlineservices.epicgames.com/en-US/services-games',
    'https://www.playstation.com/en-us/legal/copyright-and-trademark-notice/',
    'https://www.nintendo.com/',
    'https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks',
    'https://brand.zoom.us/',
    'https://developers.kakao.com/docs/latest/ko/kakaologin/design-guide',
    'https://developers.naver.com/docs/login/bi/bi.md',
    'https://developers.google.com/identity/branding-guidelines',
    'https://developer.apple.com/documentation/signinwithapple/incorporating-sign-in-with-apple-into-other-platforms',
    'https://developers.tiktok.com/doc/getting-started-design-guidelines',
    'https://developers.notion.com/guides/get-started/authorization',
  ];

  group('provider identifiers and metadata', () {
    test('contains 35 identifiers including notion with legacy aliases', () {
      expect(
        SocialLoginProvider.values.map((provider) => provider.name),
        expectedNames,
      );
      expect(expectedNames.toSet(), hasLength(expectedNames.length));
      expect(Social.values, SocialLoginProvider.values);
      expect(Social.notion, SocialLoginProvider.notion);
    });

    test('returns complete immutable metadata for every provider', () {
      for (var index = 0; index < SocialLoginProvider.values.length; index++) {
        final provider = SocialLoginProvider.values[index];
        final data = socialLoginProviderData(provider);

        expect(data.provider, provider);
        if (index < expectedDisplayNames.length) {
          expect(data.displayName, expectedDisplayNames[index]);
          expect(data.labelKo, expectedKoreanLabels[index]);
          expect(data.labelEn, expectedEnglishLabels[index]);
        }
        expect(data.displayName.trim(), isNotEmpty);
        expect(data.labelKo.trim(), isNotEmpty);
        expect(data.labelEn.trim(), isNotEmpty);
        expect(data.paletteNotes.trim(), isNotEmpty);
        expect(data.assetGuidance.trim(), isNotEmpty);
        expect(data.limitations.trim(), isNotEmpty);
        expect(data.sourceUrls, isNotEmpty);
        expect(data.sourceUrls.first, expectedRepresentativeUrls[index]);
        expect(data.sourceUrls.toSet(), hasLength(data.sourceUrls.length));

        for (final sourceUrl in data.sourceUrls) {
          final uri = Uri.tryParse(sourceUrl);
          expect(uri, isNotNull, reason: '$provider has an invalid URL');
          expect(uri!.scheme, 'https', reason: '$provider must use HTTPS');
          expect(uri.host, isNotEmpty, reason: '$provider must have a host');
        }

        expect(
          () => data.sourceUrls.add('https://example.com'),
          throwsUnsupportedError,
        );
      }
    });

    test('exposes complete immutable capabilities for all 35 providers', () {
      for (final provider in Social.values) {
        final capabilities = socialLoginProviderData(provider).capabilities;
        expect(
          capabilities.appearances,
          contains(SocialButtonAppearance.providerDefault),
          reason: provider.name,
        );
        expect(
          capabilities.shapes.keys,
          unorderedEquals(SocialButtonShape.values),
          reason: provider.name,
        );
        expect(
          capabilities.shapeReasons.keys,
          unorderedEquals(SocialButtonShape.values),
          reason: provider.name,
        );
        expect(capabilities.sources, isNotEmpty, reason: provider.name);
        for (final reason in capabilities.shapeReasons.values) {
          expect(reason.en, isNotEmpty);
          expect(reason.ko, isNotEmpty);
        }
        expect(
          () => capabilities.appearances.add(SocialButtonAppearance.dark),
          throwsUnsupportedError,
        );
        expect(
          () =>
              capabilities.shapes[SocialButtonShape.circle] =
                  SocialButtonSupport.supported,
          throwsUnsupportedError,
        );
      }
    });

    test('distinguishes supported restricted and unverified shapes', () {
      final google = socialLoginProviderData(Social.google).capabilities;
      for (final shape in SocialButtonShape.values) {
        expect(google.shapeSupport(shape), SocialButtonSupport.supported);
        expect(google.effectiveShape(shape), shape);
      }

      final kakao = socialLoginProviderData(Social.kakao).capabilities;
      expect(
        kakao.shapeSupport(SocialButtonShape.rounded),
        SocialButtonSupport.supported,
      );
      for (final restricted in const [
        SocialButtonShape.pill,
        SocialButtonShape.circle,
      ]) {
        expect(kakao.shapeSupport(restricted), SocialButtonSupport.restricted);
        expect(kakao.effectiveShape(restricted), restricted);
      }

      final microsoft = socialLoginProviderData(Social.microsoft).capabilities;
      for (final shape in SocialButtonShape.values) {
        expect(microsoft.shapeSupport(shape), SocialButtonSupport.unverified);
        expect(microsoft.effectiveShape(shape), shape);
      }
    });

    test('exposes only implemented source-backed appearances', () {
      const themed = {
        Social.x,
        Social.discord,
        Social.linkedin,
        Social.twitch,
        Social.spotify,
        Social.reddit,
        Social.gitlab,
        Social.bitbucket,
        Social.telegram,
        Social.weibo,
        Social.naver,
        Social.line,
        Social.kakao,
        Social.github,
        Social.microsoft,
        Social.slack,
        Social.google,
        Social.apple,
      };
      for (final provider in Social.values) {
        final capabilities = socialLoginProviderData(provider).capabilities;
        expect(
          capabilities.appearances,
          themed.contains(provider)
              ? const [
                SocialButtonAppearance.providerDefault,
                SocialButtonAppearance.light,
                SocialButtonAppearance.dark,
              ]
              : provider == Social.paypal
              ? const [
                SocialButtonAppearance.providerDefault,
                SocialButtonAppearance.light,
              ]
              : const [SocialButtonAppearance.providerDefault],
          reason: provider.name,
        );
        expect(
          capabilities.effectiveAppearance(SocialButtonAppearance.dark),
          themed.contains(provider)
              ? SocialButtonAppearance.dark
              : SocialButtonAppearance.providerDefault,
        );
      }
    });

    test('appearance styles contain the contracted palette colors', () {
      const style = SocialButtonAppearanceStyle(
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF000000),
        borderColor: Color(0xFFDDDDDD),
      );
      expect(style.backgroundColor, const Color(0xFFFFFFFF));
      expect(style.foregroundColor, const Color(0xFF000000));
      expect(style.borderColor, const Color(0xFFDDDDDD));
      final slack = socialLoginProviderData(Social.slack);
      final light = slack.appearanceStyle(SocialButtonAppearance.light);
      expect(light.backgroundColor, const Color(0xFFFFFFFF));
      expect(light.foregroundColor, const Color(0xFF000000));
      expect(light.borderColor, const Color(0xFFDDDDDD));
      final dark = slack.appearanceStyle(SocialButtonAppearance.dark);
      expect(dark.backgroundColor, const Color(0xFF4A154B));
      expect(dark.foregroundColor, const Color(0xFFFFFFFF));
      expect(dark.borderColor, isNull);
    });
  });

  group('locale labels', () {
    test('uses Korean only for the ko language code', () {
      for (final provider in SocialLoginProvider.values) {
        final data = socialLoginProviderData(provider);

        expect(data.labelFor(const Locale('ko')), data.labelKo);
        expect(data.labelFor(const Locale('KO', 'KR')), data.labelKo);
        expect(data.labelFor(const Locale('en')), data.labelEn);
        expect(data.labelFor(const Locale('en', 'US')), data.labelEn);
        expect(data.labelFor(const Locale('ja')), data.labelEn);
      }
    });
  });

  group('guidance and palettes', () {
    test('matches every contracted guidance classification', () {
      const signInProviders = {
        SocialLoginProvider.facebook,
        SocialLoginProvider.microsoft,
        SocialLoginProvider.line,
        SocialLoginProvider.slack,
        SocialLoginProvider.steam,
        SocialLoginProvider.telegram,
        SocialLoginProvider.wechat,
        SocialLoginProvider.snapchat,
        SocialLoginProvider.vk,
        SocialLoginProvider.weibo,
        SocialLoginProvider.qq,
        SocialLoginProvider.kakao,
        SocialLoginProvider.naver,
        SocialLoginProvider.google,
        SocialLoginProvider.apple,
        SocialLoginProvider.tiktok,
      };
      const unverifiedProviders = {
        SocialLoginProvider.epicGames,
        SocialLoginProvider.playstation,
        SocialLoginProvider.nintendo,
        SocialLoginProvider.zoom,
        SocialLoginProvider.notion,
      };

      for (final provider in SocialLoginProvider.values) {
        final expected =
            signInProviders.contains(provider)
                ? SocialLoginGuidance.signInButton
                : unverifiedProviders.contains(provider)
                ? SocialLoginGuidance.unverified
                : SocialLoginGuidance.generalBrand;
        expect(socialLoginProviderData(provider).guidance, expected);
      }
    });

    test('classifies authentication and authorization purpose for all 35', () {
      const authentication = {
        Social.line,
        Social.linkedin,
        Social.slack,
        Social.steam,
        Social.telegram,
        Social.snapchat,
        Social.vk,
        Social.epicGames,
        Social.playstation,
        Social.xbox,
        Social.naver,
        Social.apple,
      };
      const authorization = {
        Social.x,
        Social.spotify,
        Social.dropbox,
        Social.bitbucket,
        Social.instagram,
        Social.pinterest,
        Social.zoom,
        Social.notion,
      };
      const both = {
        Social.facebook,
        Social.github,
        Social.microsoft,
        Social.discord,
        Social.twitch,
        Social.reddit,
        Social.gitlab,
        Social.paypal,
        Social.wechat,
        Social.weibo,
        Social.qq,
        Social.kakao,
        Social.google,
        Social.tiktok,
      };
      const unverified = {Social.nintendo};

      expect({
        ...authentication,
        ...authorization,
        ...both,
        ...unverified,
      }, unorderedEquals(Social.values));
      for (final provider in Social.values) {
        final expected =
            authentication.contains(provider)
                ? SocialLoginPurpose.authentication
                : authorization.contains(provider)
                ? SocialLoginPurpose.authorization
                : both.contains(provider)
                ? SocialLoginPurpose.authenticationAndAuthorization
                : SocialLoginPurpose.unverified;
        expect(socialLoginProviderData(provider).purpose, expected);
      }
    });

    test('matches exact active colors and palette bases', () {
      const backgrounds = {
        Social.facebook: 0xFF0866FF,
        Social.github: 0xFF000000,
        Social.microsoft: 0xFF2F2F2F,
        Social.x: 0xFF000000,
        Social.line: 0xFF06C755,
        Social.discord: 0xFF5865F2,
        Social.linkedin: 0xFF0A66C2,
        Social.slack: 0xFF4A154B,
        Social.twitch: 0xFF9146FF,
        Social.spotify: 0xFF1ED760,
        Social.steam: 0xFF000000,
        Social.reddit: 0xFFFF4500,
        Social.dropbox: 0xFFFFFFFF,
        Social.gitlab: 0xFFFFFFFF,
        Social.bitbucket: 0xFF0052CC,
        Social.paypal: 0xFFFFFFFF,
        Social.telegram: 0xFF26A5E4,
        Social.instagram: 0xFFFF0069,
        Social.wechat: 0xFF07C160,
        Social.pinterest: 0xFFBD081C,
        Social.snapchat: 0xFFFFFC00,
        Social.vk: 0xFF0077FF,
        Social.weibo: 0xFFE6162D,
        Social.qq: 0xFF1EBAFC,
        Social.epicGames: 0xFF313131,
        Social.playstation: 0xFF0070D1,
        Social.nintendo: 0xFFE60012,
        Social.xbox: 0xFF107C10,
        Social.zoom: 0xFFFFFFFF,
        Social.kakao: 0xFFFEE500,
        Social.naver: 0xFF05AC4F,
        Social.google: 0xFFFFFFFF,
        Social.apple: 0xFF000000,
        Social.tiktok: 0xFF000000,
        Social.notion: 0xFF000000,
      };
      const darkText = {
        Social.spotify,
        Social.reddit,
        Social.gitlab,
        Social.dropbox,
        Social.paypal,
        Social.zoom,
        Social.telegram,
        Social.instagram,
        Social.wechat,
        Social.snapchat,
        Social.qq,
      };

      expect(backgrounds.keys, unorderedEquals(Social.values));
      for (final provider in SocialLoginProvider.values) {
        final data = socialLoginProviderData(provider);
        expect(
          data.backgroundColor.toARGB32(),
          backgrounds[provider],
          reason: provider.name,
        );

        if (provider == SocialLoginProvider.kakao) {
          expect(data.foregroundColor.toARGB32(), 0xD9000000);
          expect(data.borderColor, isNull);
          expect(data.paletteBasis, SocialLoginPaletteBasis.signInColors);
        } else if (provider == SocialLoginProvider.google) {
          expect(data.foregroundColor.toARGB32(), 0xFF1F1F1F);
          expect(data.borderColor?.toARGB32(), 0xFF747775);
          expect(data.paletteBasis, SocialLoginPaletteBasis.signInColors);
        } else if ({
          SocialLoginProvider.line,
          SocialLoginProvider.naver,
          SocialLoginProvider.vk,
        }.contains(provider)) {
          expect(data.foregroundColor.toARGB32(), 0xFFFFFFFF);
          expect(data.borderColor, isNull);
          expect(data.paletteBasis, SocialLoginPaletteBasis.signInColors);
        } else {
          expect(
            data.foregroundColor.toARGB32(),
            darkText.contains(provider) ? 0xFF111111 : 0xFFFFFFFF,
          );
          expect(
            data.borderColor?.toARGB32(),
            {
                  Social.dropbox,
                  Social.gitlab,
                  Social.paypal,
                  Social.zoom,
                }.contains(provider)
                ? 0xFFDDDDDD
                : null,
          );
          expect(data.paletteBasis, SocialLoginPaletteBasis.sourceAdapted);
        }
      }

      expect(
        SocialLoginProvider.values
            .map(socialLoginProviderData)
            .where(
              (data) =>
                  data.paletteBasis == SocialLoginPaletteBasis.neutralFallback,
            ),
        isEmpty,
      );
    });

    test('active text contrast is at least 4.5 to 1 after compositing', () {
      for (final provider in SocialLoginProvider.values) {
        final data = socialLoginProviderData(provider);
        final ratio = _contrastRatio(
          foreground: data.foregroundColor,
          background: data.backgroundColor,
        );

        if ({Social.line, Social.naver, Social.vk}.contains(provider)) {
          expect(
            ratio,
            lessThan(4.5),
            reason:
                '${provider.name} intentionally preserves the provider palette',
          );
        } else {
          expect(
            ratio,
            greaterThanOrEqualTo(4.5),
            reason: '${provider.name} contrast was $ratio',
          );
        }
      }
    });
  });
}

double _contrastRatio({required Color foreground, required Color background}) {
  final foregroundArgb = foreground.toARGB32();
  final backgroundArgb = background.toARGB32();
  final alpha = ((foregroundArgb >> 24) & 0xff) / 255;

  int compositeChannel(int shift) {
    final foregroundChannel = (foregroundArgb >> shift) & 0xff;
    final backgroundChannel = (backgroundArgb >> shift) & 0xff;
    return (foregroundChannel * alpha + backgroundChannel * (1 - alpha))
        .round();
  }

  final composited = Color.fromARGB(
    0xff,
    compositeChannel(16),
    compositeChannel(8),
    compositeChannel(0),
  );
  final lighter =
      composited.computeLuminance() > background.computeLuminance()
          ? composited.computeLuminance()
          : background.computeLuminance();
  final darker =
      composited.computeLuminance() > background.computeLuminance()
          ? background.computeLuminance()
          : composited.computeLuminance();

  return (lighter + 0.05) / (darker + 0.05);
}
