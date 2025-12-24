# MG-0007 Platformer - AI 에셋 생성 프롬프트

이 문서는 MG-0007 플랫포머 게임에 필요한 그래픽/사운드 에셋을 AI 도구로 생성할 때 사용할 프롬프트 모음입니다.

---

## 🎨 그래픽 에셋

### 1. 플레이어 캐릭터 (Player Sprite)

**현재 구현**: 파란색 사각형 (40x60) + 흰색 눈

**AI 이미지 생성 프롬프트**:
```
A cute 2D pixel art character sprite for a platformer game,
40x60 pixels, blue body with big white expressive eyes,
simple geometric design, suitable for side-view platformer,
transparent background, PNG format, game-ready asset

Style: pixel art, 8-bit retro, minimalist
Color palette: blue (#0000FF), white (#FFFFFF)
Variations needed: idle, walking (2 frames), jumping
```

**Midjourney/DALL-E 스타일**:
```
pixel art character sprite sheet, blue rectangular hero with eyes,
platformer game character, side-view, idle and jump poses,
retro 8-bit style, transparent background --ar 4:1 --v 5
```

---

### 2. 플랫폼 (Platform Tiles)

**현재 구현**: 갈색 사각형 (#8b4513) + 테두리 (#654321)

**AI 이미지 생성 프롬프트**:
```
2D platformer ground tile, wooden or stone platform texture,
brown color (#8b4513), dark brown border (#654321),
tileable seamless pattern, 20 pixels height,
suitable for pixel art platformer game, top-down view,
simple geometric design, game-ready asset

Style: pixel art, retro platformer
Surface: wood planks, stone blocks, or dirt platform
Variations: corner pieces, middle sections, edge caps
```

**Aseprite/Pixel Art 프롬프트**:
```
Create a tileable platform sprite:
- Base color: #8b4513 (saddle brown)
- Border: #654321 (dark brown)
- Size: 150x20 pixels (scalable)
- Style: simple pixel art with subtle texture
- Top surface slightly lighter for depth
```

---

### 3. 배경 (Background)

**현재 구현**: 단색 하늘색 (#87CEEB)

**AI 이미지 생성 프롬프트**:
```
2D platformer game background, sky blue (#87CEEB) base color,
parallax scrolling layers, pixel art style,
distant mountains, clouds, atmospheric depth,
suitable for side-scrolling platformer,
resolution: 1920x1080, seamless horizontal tiling

Layers (back to front):
1. Sky gradient (light blue to pale cyan)
2. Distant mountains (silhouette, dark blue)
3. Mid-ground clouds (fluffy, white)
4. Close clouds (parallax scrolling)

Style: pixel art, retro, atmospheric
```

**Background Variations**:
```
Day theme: bright blue sky (#87CEEB), white clouds
Sunset theme: orange/purple gradient, dramatic clouds
Night theme: dark blue (#1a1a2e), stars, moon
Cave theme: dark gray, stalactites, glowing crystals
```

---

### 4. UI 요소

**추가 가능 UI 에셋**:

**점수/타이머 패널**:
```
Pixel art UI panel for platformer game,
wooden frame border, semi-transparent background,
retro game HUD style, suitable for score display,
size: 200x60 pixels, PNG with alpha channel

Style: retro pixel art, wood texture frame
Color: brown (#8b4513), dark brown (#654321)
```

**하트 (HP 표시)**:
```
Pixel art heart icon for health display,
8x8 pixels, red color, simple pixelated design,
states: full heart, half heart, empty heart outline,
retro platformer style, game-ready sprite sheet

Style: 8-bit pixel art
Colors: red (#FF0000), dark red (#8B0000), gray (#808080)
```

---

## 🔊 사운드 에셋

### 1. 플레이어 사운드

**점프 사운드**:
```
Audio prompt for AI sound generation (e.g., ElevenLabs, Mubert):

"8-bit retro game jump sound effect, short 0.2 second duration,
bouncy and energetic, rising pitch, classic platformer style,
similar to Super Mario Bros jump sound,
chiptune/8-bit synthesizer, WAV format"

Parameters:
- Duration: 0.2s
- Pitch: rising (C4 to C5)
- Style: chiptune, 8-bit
- Tone: bouncy, light
```

**착지 사운드**:
```
"8-bit retro landing sound effect, short 0.15 second thud,
soft impact sound, descending pitch, platformer game style,
chiptune synthesizer, slightly muffled, WAV format"

Parameters:
- Duration: 0.15s
- Pitch: descending (E4 to C4)
- Style: chiptune, muffled impact
```

**이동 사운드 (발걸음)**:
```
"8-bit footstep sound effect, very short 0.08 second,
soft tick sound, loopable for walking animation,
retro platformer style, minimal chiptune, WAV format"

Parameters:
- Duration: 0.08s
- Loop: yes
- Style: chiptune, soft tick
```

---

### 2. 환경 사운드

**배경 음악 (BGM)**:
```
"Retro platformer game background music, upbeat and energetic,
8-bit chiptune style, loopable 60-90 second track,
cheerful melody in C major, moderate tempo (120-140 BPM),
similar to classic NES/SNES platformer music,
multiple instrument layers (lead, bass, percussion)"

Style: chiptune, 8-bit, retro
Mood: upbeat, adventurous, energetic
Tempo: 120-140 BPM
Key: C major
Length: 60-90 seconds (loopable)
```

**충돌 사운드**:
```
"8-bit collision sound effect, short 0.1 second impact,
sharp percussive hit, platformer game style,
chiptune synthesizer, WAV format"

Parameters:
- Duration: 0.1s
- Style: sharp impact, chiptune
```

---

### 3. UI 사운드

**게임 오버**:
```
"8-bit game over sound effect, 1-2 second descending melody,
sad/disappointing tone, classic retro platformer style,
chiptune synthesizer, descending arpeggio, WAV format"

Parameters:
- Duration: 1-2s
- Melody: descending arpeggio (C4-A3-F3-C3)
- Mood: disappointing, game over
```

**레벨 클리어 (추가 기능용)**:
```
"8-bit level complete fanfare, 2-3 second upbeat jingle,
celebratory and triumphant, classic platformer victory theme,
chiptune synthesizer, ascending melody, WAV format"

Parameters:
- Duration: 2-3s
- Melody: ascending triumphant fanfare
- Mood: victorious, celebratory
```

---

## 🎨 추가 에셋 (확장 기능용)

### 적/장애물 스프라이트

**적 캐릭터**:
```
Pixel art enemy sprite for platformer game,
simple geometric design, contrasting color (red/purple),
idle and walking animation frames, 40x40 pixels,
hostile appearance but cute style, side-view,
transparent background, game-ready sprite sheet

Style: pixel art, retro, slightly menacing but cute
Colors: red (#FF0000), purple (#9b59b6)
Animation: idle, walk (2 frames), hit
```

**가시 트랩**:
```
Pixel art spike trap sprite, sharp triangular spikes,
gray/dark color, 20x20 pixels per spike,
tileable for platform edges, dangerous appearance,
pixel art retro style, transparent background

Style: pixel art, sharp geometric
Colors: gray (#808080), dark gray (#404040)
```

---

### 수집 아이템

**코인/별**:
```
Pixel art collectible coin sprite, golden/yellow color,
spinning animation (4 frames), 16x16 pixels,
shiny and appealing, classic platformer collectible style,
transparent background, sprite sheet format

Style: pixel art, shiny, rotating animation
Colors: gold (#FFD700), yellow (#FFFF00)
Animation: 4-frame rotation
```

---

## 🛠️ 에셋 생성 도구 추천

### 그래픽
- **Aseprite**: 픽셀 아트 전문 도구 (유료)
- **Piskel**: 무료 온라인 픽셀 아트 에디터
- **GIMP**: 무료 이미지 편집기
- **Midjourney/DALL-E**: AI 이미지 생성 (프롬프트 활용)

### 사운드
- **BeepBox**: 무료 온라인 칩튠 작곡 도구
- **SFXR/BFXR**: 무료 8-bit 효과음 생성기
- **Audacity**: 무료 오디오 편집기
- **ElevenLabs**: AI 사운드 생성 (프롬프트 활용)

### 음악
- **FamiTracker**: NES 스타일 칩튠 작곡
- **LMMS**: 무료 음악 제작 소프트웨어
- **Bosca Ceoil**: 간단한 칩튠 작곡 도구

---

## 📋 에셋 체크리스트

### 필수 에셋 (현재 게임용)
- [ ] 플레이어 스프라이트 (idle, jump)
- [ ] 플랫폼 타일 (tileable)
- [ ] 배경 이미지
- [ ] 점프 사운드
- [ ] 착지 사운드
- [ ] 배경 음악 (BGM)

### 확장 에셋 (추가 기능용)
- [ ] 플레이어 걷기 애니메이션
- [ ] 적 스프라이트
- [ ] 가시 트랩 스프라이트
- [ ] 코인/수집 아이템
- [ ] UI 패널/하트
- [ ] 충돌/데미지 사운드
- [ ] 승리/패배 사운드

---

## 💡 에셋 최적화 팁

1. **파일 크기**: PNG 최적화 도구 사용 (TinyPNG, pngquant)
2. **스프라이트 시트**: 개별 이미지보다 시트로 통합
3. **오디오 포맷**: WAV (개발), OGG/MP3 (배포)
4. **해상도**: 픽셀 아트는 정수 배율로 스케일링 (2x, 3x, 4x)
5. **색상 팔레트**: 일관된 색상 팔레트 유지 (16-32 colors)

---

**이 프롬프트들을 AI 에셋 생성 도구에 복사하여 사용하세요!**
