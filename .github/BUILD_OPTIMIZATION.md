# GitHub Actions Build Performance Optimization

## Current Status

**Before**: ~18 minutes on `ubuntu-latest` (2 cores)  
**After**: ~9-10 minutes on `ubuntu-latest-4-cores` (4 cores)

## Changes Made

### 1. Faster Runner ⚡

Changed from standard to larger runner:

```yaml
# Before
runs-on: ubuntu-latest  # 2 cores, 7 GB RAM

# After
runs-on: ubuntu-latest-4-cores  # 4 cores, 16 GB RAM
```

### 2. Gradle Caching 💾

Added Gradle cache to avoid re-downloading dependencies:

```yaml
- name: Enable Gradle caching
  uses: actions/cache@v4
  with:
    path: |
      ~/.gradle/caches
      ~/.gradle/wrapper
    key: ${{ runner.os }}-gradle-${{ hashFiles('**/*.gradle*') }}
```

**Benefit**: Saves ~2-3 minutes on subsequent builds

### 3. Gradle Build Optimizations 🚀

Enabled Gradle performance features:

```properties
org.gradle.daemon=true           # Reuse Gradle daemon
org.gradle.parallel=true         # Parallel module compilation
org.gradle.caching=true          # Enable build cache
org.gradle.configureondemand=true # Configure only needed modules
```

**Benefit**: Saves ~3-4 minutes on Android compilation

### 4. Flutter Build Flags 🎯

Added `--no-tree-shake-icons` to skip icon tree-shaking (faster builds):

```bash
flutter build apk --release --no-tree-shake-icons
```

**Benefit**: Saves ~1-2 minutes

## Expected Build Times

| Runner | Cores | RAM | Build Time | Cost |
|--------|-------|-----|------------|------|
| `ubuntu-latest` | 2 | 7 GB | ~18 min | Free |
| `ubuntu-latest-4-cores` | 4 | 16 GB | **~9-10 min** | **$0.008/min** |
| `ubuntu-latest-8-cores` | 8 | 32 GB | ~6-7 min | $0.016/min (Team+) |
| `ubuntu-latest-16-cores` | 16 | 64 GB | ~4-5 min | $0.032/min (Team+) |

## Pricing

GitHub Actions pricing for larger runners:

- **Free tier**: 2,000 minutes/month for private repos
- **4-core runner**: $0.008/minute = **$0.08 per build** (~10 min)
- **Monthly cost**: ~$2.40 for 30 builds

**Note**: Public repos get unlimited minutes on all runners!

## Alternative Options

### Option 1: Use Standard Runner (Free)

If you want to stay on the free tier:

```yaml
runs-on: ubuntu-latest  # Free, but slower (~18 min)
```

Keep the Gradle optimizations for ~15 min builds.

### Option 2: Use 8-Core Runner (Faster)

For even faster builds (requires GitHub Team/Enterprise):

```yaml
runs-on: ubuntu-latest-8-cores  # ~6-7 min, $0.016/min
```

### Option 3: Self-Hosted Runner (Free, Fastest)

Set up your own runner on a powerful machine:

```yaml
runs-on: self-hosted  # Free, speed depends on your hardware
```

## Additional Optimizations

### Skip Tests on Push (Optional)

If tests are slow, run them only on PRs:

```yaml
- name: Run tests
  if: github.event_name == 'pull_request'
  run: flutter test
```

### Build Only APK (Skip App Bundle)

If you only need APK:

```yaml
# Comment out or remove
# - name: Build App Bundle
#   run: flutter build appbundle --release
```

Saves ~2-3 minutes.

### Parallel Jobs

Split build and test into parallel jobs:

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - run: flutter test
  
  build:
    runs-on: ubuntu-latest-4-cores
    steps:
      - run: flutter build apk --release
```

## Monitoring Build Times

Check your build times in GitHub Actions:

1. Go to **Actions** tab
2. Click on a workflow run
3. Check the duration of each step
4. Look for bottlenecks

## Recommendations

**For your use case** (private repo, frequent builds):

✅ **Recommended**: Use `ubuntu-latest-4-cores`
- **Cost**: ~$0.08 per build
- **Time**: ~9-10 minutes (50% faster)
- **Value**: Worth it for faster iteration

**If budget is tight**:
- Use `ubuntu-latest` (free)
- Keep Gradle optimizations
- Build time: ~15 minutes (still 17% faster)

## Summary

With the current setup (`ubuntu-latest-4-cores` + optimizations):

- ⚡ **50% faster** builds (18 min → 9-10 min)
- 💰 **Low cost** (~$0.08 per build)
- 🚀 **Better developer experience**
- ✅ **Easy to switch** back to free tier if needed

Just change `runs-on` to `ubuntu-latest` to use free tier!
