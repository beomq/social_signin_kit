import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:social_signin_kit/social_signin_kit.dart';

import 'gallery_design.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final fontLoader =
      FontLoader('NotoSansKR')
        ..addFont(rootBundle.load('assets/fonts/NotoSansKR-Regular.otf'))
        ..addFont(rootBundle.load('assets/fonts/NotoSansKR-Medium.otf'))
        ..addFont(rootBundle.load('assets/fonts/NotoSansKR-Bold.otf'));
  await fontLoader.load();
  runApp(const SocialLoginExampleApp());
}

class SocialLoginExampleApp extends StatefulWidget {
  const SocialLoginExampleApp({super.key});

  @override
  State<SocialLoginExampleApp> createState() => _SocialLoginExampleAppState();
}

class _SocialLoginExampleAppState extends State<SocialLoginExampleApp> {
  Locale _locale = const Locale('ko');
  SocialButtonShape _shape = SocialButtonShape.pill;
  SocialButtonAppearance _appearance =
      SocialButtonAppearance.providerDefault;
  Social _selectedProvider = Social.google;
  bool _disabled = false;
  int _activationCount = 0;
  Social? _lastActivatedProvider;

  bool get _isKorean => _locale.languageCode == 'ko';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Login Buttons Gallery',
      theme: buildGalleryTheme(),
      locale: _locale,
      supportedLocales: const [Locale('ko'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHero()),
              SliverToBoxAdapter(child: _buildPageContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            GalleryColors.canvasGlow,
            GalleryColors.canvas,
            GalleryColors.surface,
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: GalleryLayout.maxContentWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              GalleryLayout.desktopGutter,
              GallerySpace.x16,
              GalleryLayout.desktopGutter,
              GallerySpace.x12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GalleryTag(
                  label:
                      _isKorean
                          ? '35개 프로바이더 · UI 전용'
                          : '35 providers · UI only',
                  foreground: GalleryColors.accent,
                  background: GalleryColors.surface,
                ),
                const SizedBox(height: GallerySpace.x6),
                Text(
                  _isKorean
                      ? '로그인 버튼을\n한곳에서 비교하세요'
                      : 'Compare every sign-in\nbutton in one place',
                  style:
                      MediaQuery.sizeOf(context).width < GalleryLayout.compact
                          ? GalleryTextStyles.displayCompact
                          : GalleryTextStyles.display,
                ),
                const SizedBox(height: GallerySpace.x5),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: GalleryLayout.stageSplit,
                  ),
                  child: Text(
                    _isKorean
                        ? '35개 로고를 패키지 기본값으로 표시하는 UI 프리셋입니다. 인증을 수행하거나 제공자 승인을 보장하지 않습니다.'
                        : 'These UI presets bundle defaults for all 35 logos. They do not authenticate users or guarantee provider approval.',
                    style: GalleryTextStyles.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: GalleryLayout.maxContentWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            GalleryLayout.desktopGutter,
            0,
            GalleryLayout.desktopGutter,
            GallerySpace.x20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildControls(),
              const SizedBox(height: GallerySpace.x8),
              _buildSelectedStage(),
              const SizedBox(height: GallerySpace.x16),
              _buildListSpecimens(),
              const SizedBox(height: GallerySpace.x16),
              GallerySectionHeader(
                eyebrow: _isKorean ? '전체 카탈로그' : 'Full catalog',
                title:
                    _isKorean ? '35개 프로바이더 미리보기' : 'All 35 provider previews',
                description:
                    _isKorean
                        ? '모든 항목은 logo를 생략한 SocialButton이며 35개 패키지 기본 PNG를 자동으로 사용합니다.'
                        : 'Every item omits logo and automatically uses one of the 35 bundled PNG defaults.',
              ),
              const SizedBox(height: GallerySpace.x6),
              _buildProviderGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return GallerySurface(
      padding: const EdgeInsets.all(GallerySpace.x5),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < GalleryLayout.stageSplit;
          final controls = [
            _ControlGroup(
              label: _isKorean ? '언어' : 'Language',
              child: SegmentedButton<Locale>(
                key: const ValueKey<String>('locale-control'),
                segments: const [
                  ButtonSegment(value: Locale('ko'), label: Text('한국어')),
                  ButtonSegment(value: Locale('en'), label: Text('English')),
                ],
                selected: {_locale},
                onSelectionChanged: (selection) {
                  setState(() => _locale = selection.first);
                },
              ),
            ),
            _ControlGroup(
              label: _isKorean ? '모양' : 'Shape',
              child: SegmentedButton<SocialButtonShape>(
                key: const ValueKey<String>('shape-control'),
                segments: [
                  ButtonSegment(
                    value: SocialButtonShape.rounded,
                    label: Text(_isKorean ? '둥근형' : 'Rounded'),
                  ),
                  ButtonSegment(
                    value: SocialButtonShape.pill,
                    label: Text(_isKorean ? '필' : 'Pill'),
                  ),
                  ButtonSegment(
                    value: SocialButtonShape.circle,
                    label: Text(_isKorean ? '원형' : 'Circle'),
                  ),
                ],
                selected: {_shape},
                onSelectionChanged: (selection) {
                  setState(() => _shape = selection.first);
                },
              ),
            ),
            _ControlGroup(
              label: _isKorean ? '표시 모드' : 'Appearance',
              child: SegmentedButton<SocialButtonAppearance>(
                key: const ValueKey<String>('appearance-control'),
                segments: [
                  ButtonSegment(
                    value: SocialButtonAppearance.providerDefault,
                    label: Text(_isKorean ? '기본' : 'Default'),
                  ),
                  const ButtonSegment(
                    value: SocialButtonAppearance.light,
                    label: Text('Light'),
                  ),
                  const ButtonSegment(
                    value: SocialButtonAppearance.dark,
                    label: Text('Dark'),
                  ),
                ],
                selected: {_appearance},
                onSelectionChanged: (selection) {
                  setState(() => _appearance = selection.first);
                },
              ),
            ),
            _ControlGroup(
              label: _isKorean ? '프로바이더' : 'Provider',
              child: DropdownMenu<Social>(
                key: const ValueKey<String>('provider-control'),
                width: GalleryLayout.controlWidth,
                initialSelection: _selectedProvider,
                dropdownMenuEntries: Social.values
                    .map((provider) {
                      final data = socialLoginProviderData(provider);
                      return DropdownMenuEntry(
                        value: provider,
                        label: data.displayName,
                      );
                    })
                    .toList(growable: false),
                onSelected: (provider) {
                  if (provider != null) {
                    setState(() => _selectedProvider = provider);
                  }
                },
              ),
            ),
            _ControlGroup(
              label: _isKorean ? '상태' : 'State',
              child: SizedBox(
                width: GalleryLayout.controlWidth,
                child: SwitchListTile(
                  key: const ValueKey<String>('disabled-control'),
                  contentPadding: EdgeInsets.zero,
                  title: Text(_isKorean ? '비활성화' : 'Disabled'),
                  value: _disabled,
                  onChanged: (value) => setState(() => _disabled = value),
                ),
              ),
            ),
          ];

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  controls
                      .expand(
                        (control) => [
                          control,
                          const SizedBox(height: GallerySpace.x4),
                        ],
                      )
                      .toList()
                    ..removeLast(),
            );
          }

          return Wrap(
            spacing: GallerySpace.x6,
            runSpacing: GallerySpace.x5,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: controls,
          );
        },
      ),
    );
  }

  Widget _buildSelectedStage() {
    final data = socialLoginProviderData(_selectedProvider);
    return GallerySurface(
      color: GalleryColors.stage,
      radius: GalleryRadii.large,
      shadow: GalleryShadows.stage,
      borderColor: null,
      padding: const EdgeInsets.all(GallerySpace.x8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final split = constraints.maxWidth >= GalleryLayout.stageSplit;
          final summary = _buildSelectedSummary(data);
          final preview = _buildSelectedPreview(data);

          if (split) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: summary),
                const SizedBox(width: GallerySpace.x10),
                Expanded(child: preview),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              summary,
              const SizedBox(height: GallerySpace.x8),
              preview,
            ],
          );
        },
      ),
    );
  }

  Widget _buildSelectedSummary(SocialLoginProviderData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isKorean ? '선택한 프로바이더' : 'Selected provider',
          style: GalleryTextStyles.label.copyWith(
            color: GalleryColors.onDarkMuted,
          ),
        ),
        const SizedBox(height: GallerySpace.x3),
        Text(
          data.displayName,
          style: GalleryTextStyles.h1.copyWith(color: GalleryColors.onDark),
        ),
        const SizedBox(height: GallerySpace.x5),
        Wrap(
          spacing: GallerySpace.x2,
          runSpacing: GallerySpace.x2,
          children: [
            GalleryTag(
              label: _guidanceLabel(data.guidance),
              foreground: GalleryColors.onDark,
              background: GalleryColors.stageElevated,
            ),
            GalleryTag(
              label: _paletteLabel(data.paletteBasis),
              foreground: GalleryColors.onDark,
              background: GalleryColors.stageElevated,
            ),
            GalleryTag(
              label: _purposeLabel(data.purpose),
              foreground: GalleryColors.onDark,
              background: GalleryColors.stageElevated,
            ),
          ],
        ),
        const SizedBox(height: GallerySpace.x5),
        Text(
          data.assetGuidance,
          style: GalleryTextStyles.body.copyWith(
            color: GalleryColors.onDarkMuted,
          ),
        ),
        const SizedBox(height: GallerySpace.x3),
        Text(
          data.limitations,
          style: GalleryTextStyles.small.copyWith(
            color: GalleryColors.onDarkMuted,
          ),
        ),
        if (_shape == SocialButtonShape.circle) ...[
          const SizedBox(height: GallerySpace.x4),
          Text(
            _isKorean
                ? '공통 원형 미리보기이며 제공자별 허용 형태가 아닙니다.'
                : 'This is a common circular preview, not a provider-approved shape.',
            style: GalleryTextStyles.small.copyWith(
              color: GalleryColors.onDark,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSelectedPreview(SocialLoginProviderData data) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: GalleryColors.stageElevated,
        borderRadius: BorderRadius.circular(GalleryRadii.medium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(GallerySpace.x6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isKorean ? '실제 위젯 미리보기' : 'Live widget preview',
              style: GalleryTextStyles.label.copyWith(
                color: GalleryColors.onDarkMuted,
              ),
            ),
            const SizedBox(height: GallerySpace.x5),
            SocialButton(
              key: const ValueKey<String>('selected-provider-button'),
              social: _selectedProvider,
              onPressed:
                  _disabled ? null : () => _recordActivation(_selectedProvider),
              shape: _shape,
              appearance: _appearance,
              locale: _locale,
            ),
            const SizedBox(height: GallerySpace.x4),
            Text(
              _isKorean
                  ? '패키지 기본 로고 · 앱 자산은 logo로 교체 가능'
                  : 'Package default · replaceable with an app asset via logo',
              textAlign: TextAlign.center,
              style: GalleryTextStyles.small.copyWith(
                color: GalleryColors.onDarkMuted,
              ),
            ),
            const SizedBox(height: GallerySpace.x6),
            Semantics(
              key: const ValueKey<String>('callback-status'),
              liveRegion: true,
              container: true,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: GalleryColors.stage,
                  borderRadius: BorderRadius.circular(GalleryRadii.small),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(GallerySpace.x4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bolt_outlined,
                        color: GalleryColors.onDark,
                      ),
                      const SizedBox(width: GallerySpace.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _activationCount == 0
                                  ? (_isKorean
                                      ? '아직 콜백이 호출되지 않았습니다'
                                      : 'No callback invoked yet')
                                  : (_isKorean ? '콜백 호출' : 'Callback invoked'),
                              style: GalleryTextStyles.small.copyWith(
                                color: GalleryColors.onDarkMuted,
                              ),
                            ),
                            const SizedBox(height: GallerySpace.x1),
                            Wrap(
                              spacing: GallerySpace.x4,
                              children: [
                                Text(
                                  '$_activationCount',
                                  key: const ValueKey<String>('callback-count'),
                                  style: GalleryTextStyles.h3.copyWith(
                                    color: GalleryColors.onDark,
                                  ),
                                ),
                                Text(
                                  _lastActivatedProvider?.name ?? 'none',
                                  key: const ValueKey<String>(
                                    'callback-provider',
                                  ),
                                  style: GalleryTextStyles.h3.copyWith(
                                    color: GalleryColors.onDark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSpecimens() {
    final samples = [Social.google, Social.github, Social.notion];
    final commonSettings =
        _isKorean
            ? '공통 모양 · 크기 48 · 언어 · 간격 8을 목록에서 상속합니다.'
            : 'Each list inherits common shape, size 48, locale, and spacing 8.';

    List<SocialButton> buttons(String direction) => samples
        .map(
          (social) => SocialButton(
            key: ValueKey<String>('$direction-list-${social.name}'),
            social: social,
            onPressed: _disabled ? null : () => _recordActivation(social),
          ),
        )
        .toList(growable: false);

    final vertical = _ListSpecimen(
      title: _isKorean ? '세로 목록' : 'Vertical list',
      description: commonSettings,
      child: SocialButtonList.vertical(
        key: const ValueKey<String>('vertical-button-list'),
        shape: _shape,
        appearance: _appearance,
        size: 48,
        locale: _locale,
        spacing: GallerySpace.x2,
        items: buttons('vertical'),
      ),
    );
    final horizontal = _ListSpecimen(
      title: _isKorean ? '가로 목록' : 'Horizontal list',
      description: commonSettings,
      child: SocialButtonList.horizontal(
        key: const ValueKey<String>('horizontal-button-list'),
        shape: _shape,
        appearance: _appearance,
        size: 48,
        locale: _locale,
        spacing: GallerySpace.x2,
        items: buttons('horizontal'),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GallerySectionHeader(
          eyebrow: _isKorean ? '편의 API' : 'Convenience API',
          title:
              _isKorean ? '실제 목록 위젯과 필 모양' : 'Real list widgets and pill shape',
          description:
              _isKorean
                  ? '모든 버튼은 logo를 생략하고 각 프로바이더의 패키지 기본 PNG를 자동으로 읽습니다.'
                  : 'Every button omits logo and automatically loads its provider package PNG.',
        ),
        const SizedBox(height: GallerySpace.x6),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < GalleryLayout.stageSplit) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  vertical,
                  const SizedBox(height: GallerySpace.x5),
                  horizontal,
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: vertical),
                const SizedBox(width: GallerySpace.x5),
                Expanded(child: horizontal),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildProviderGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            constraints.maxWidth >= GalleryLayout.threeColumns
                ? 3
                : constraints.maxWidth >= GalleryLayout.compact
                ? 2
                : 1;
        final width =
            (constraints.maxWidth - GallerySpace.x5 * (columns - 1)) / columns;

        return Wrap(
          spacing: GallerySpace.x5,
          runSpacing: GallerySpace.x5,
          children: Social.values
              .map(
                (provider) => SizedBox(
                  width: width,
                  child: _ProviderCard(
                    provider: provider,
                    locale: _locale,
                    shape: _shape,
                    appearance: _appearance,
                    disabled: _disabled,
                    selected: provider == _selectedProvider,
                    onPressed: () => _recordActivation(provider),
                    guidanceLabel: _guidanceLabel,
                    paletteLabel: _paletteLabel,
                    purposeLabel: _purposeLabel,
                    sourceLabel:
                        _isKorean ? '출처 및 참고자료' : 'Sources and references',
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }

  void _recordActivation(Social provider) {
    setState(() {
      _activationCount += 1;
      _lastActivatedProvider = provider;
    });
  }

  String _guidanceLabel(SocialLoginGuidance guidance) {
    return switch (guidance) {
      SocialLoginGuidance.signInButton =>
        _isKorean ? '로그인 표면 근거' : 'Sign-in surface source',
      SocialLoginGuidance.generalBrand =>
        _isKorean ? '일반 브랜드 근거' : 'General brand source',
      SocialLoginGuidance.unverified => _isKorean ? '미확인' : 'Unverified',
    };
  }

  String _paletteLabel(SocialLoginPaletteBasis basis) {
    return switch (basis) {
      SocialLoginPaletteBasis.signInColors =>
        _isKorean ? '로그인 색상 기반' : 'Sign-in colors',
      SocialLoginPaletteBasis.sourceAdapted =>
        _isKorean ? '출처 색상 조정' : 'Source-adapted',
      SocialLoginPaletteBasis.neutralFallback =>
        _isKorean ? '중립 팔레트' : 'Neutral fallback',
    };
  }

  String _purposeLabel(SocialLoginPurpose purpose) {
    return switch (purpose) {
      SocialLoginPurpose.authentication =>
        _isKorean ? '인증/로그인' : 'Authentication',
      SocialLoginPurpose.authorization =>
        _isKorean ? '권한 부여/연결' : 'Authorization',
      SocialLoginPurpose.authenticationAndAuthorization =>
        _isKorean ? '인증 + 권한 부여' : 'Authentication + authorization',
      SocialLoginPurpose.unverified =>
        _isKorean ? '공개 목적 미확인' : 'Public purpose unverified',
    };
  }
}

class _ControlGroup extends StatelessWidget {
  const _ControlGroup({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GalleryTextStyles.label.copyWith(
            color: GalleryColors.inkMuted,
          ),
        ),
        const SizedBox(height: GallerySpace.x2),
        child,
      ],
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({
    required this.provider,
    required this.locale,
    required this.shape,
    required this.appearance,
    required this.disabled,
    required this.selected,
    required this.onPressed,
    required this.guidanceLabel,
    required this.paletteLabel,
    required this.purposeLabel,
    required this.sourceLabel,
  });

  final Social provider;
  final Locale locale;
  final SocialButtonShape shape;
  final SocialButtonAppearance appearance;
  final bool disabled;
  final bool selected;
  final VoidCallback onPressed;
  final String Function(SocialLoginGuidance) guidanceLabel;
  final String Function(SocialLoginPaletteBasis) paletteLabel;
  final String Function(SocialLoginPurpose) purposeLabel;
  final String sourceLabel;

  @override
  Widget build(BuildContext context) {
    final data = socialLoginProviderData(provider);
    return GallerySurface(
      color: selected ? GalleryColors.accentWash : GalleryColors.surface,
      shadow: selected ? GalleryShadows.stage : GalleryShadows.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.displayName, style: GalleryTextStyles.h3),
                    const SizedBox(height: GallerySpace.x1),
                    Text(
                      provider.name,
                      style: GalleryTextStyles.small.copyWith(
                        color: GalleryColors.inkFaint,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(
                  Icons.check_circle,
                  color: GalleryColors.accent,
                  size: GallerySpace.x5,
                ),
            ],
          ),
          const SizedBox(height: GallerySpace.x5),
          SocialButton(
            key: ValueKey<String>('provider-button-${provider.name}'),
            social: provider,
            onPressed: disabled ? null : onPressed,
            shape: shape,
            appearance: appearance,
            locale: locale,
          ),
          const SizedBox(height: GallerySpace.x3),
          Text(
            locale.languageCode == 'ko'
                ? '패키지 기본 로고'
                : 'Package default logo',
            textAlign: TextAlign.center,
            style: GalleryTextStyles.small.copyWith(
              color: GalleryColors.inkFaint,
            ),
          ),
          const SizedBox(height: GallerySpace.x5),
          Wrap(
            spacing: GallerySpace.x2,
            runSpacing: GallerySpace.x2,
            children: [
              GalleryTag(label: guidanceLabel(data.guidance)),
              GalleryTag(label: paletteLabel(data.paletteBasis)),
              GalleryTag(label: purposeLabel(data.purpose)),
            ],
          ),
          const SizedBox(height: GallerySpace.x4),
          Text(
            data.assetGuidance,
            style: GalleryTextStyles.body.copyWith(color: GalleryColors.ink),
          ),
          const SizedBox(height: GallerySpace.x3),
          Text(
            data.limitations,
            style: GalleryTextStyles.small.copyWith(
              color: GalleryColors.inkMuted,
            ),
          ),
          const SizedBox(height: GallerySpace.x4),
          Text(
            sourceLabel.toUpperCase(),
            style: GalleryTextStyles.label.copyWith(
              color: GalleryColors.inkMuted,
            ),
          ),
          const SizedBox(height: GallerySpace.x2),
          ...data.sourceUrls.map(
            (url) => Padding(
              padding: const EdgeInsets.only(bottom: GallerySpace.x2),
              child: SelectableText(
                url,
                style: GalleryTextStyles.small.copyWith(
                  color: GalleryColors.accent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _ListSpecimen extends StatelessWidget {
  const _ListSpecimen({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GallerySurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: GalleryTextStyles.h3),
          const SizedBox(height: GallerySpace.x2),
          Text(
            description,
            style: GalleryTextStyles.small.copyWith(
              color: GalleryColors.inkMuted,
            ),
          ),
          const SizedBox(height: GallerySpace.x5),
          child,
        ],
      ),
    );
  }
}
