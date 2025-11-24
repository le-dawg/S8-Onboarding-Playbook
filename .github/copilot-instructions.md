# Copilot Instructions for Research and Design Playbook

## Repository Overview

This is the **Truss Research and Design Playbook** - a Jekyll-based static documentation site that serves as an internal knowledge base and onboarding resource for Truss's design and research practice. The playbook contains guides, resources, templates, and best practices for design work at Truss.

**Repository Type**: Documentation site / Static site generator (Jekyll)  
**Primary Language**: Markdown, with Ruby (Jekyll), JavaScript (Node.js for linting)  
**Size**: ~62 source files (excluding dependencies), ~204MB total with dependencies  
**Target Runtime**: Jekyll 3.9.5 with Ruby ~3.2.0, Node.js 18.16.0

## Project Structure

### Key Directories and Files

**Root Configuration Files:**
- `_config.yml` - Main Jekyll configuration (theme, navigation, excludes)
- `Gemfile` - Ruby dependencies (github-pages ~231, just-the-docs ~0.5.0, webrick ~1.8)
- `package.json` - Node.js dev dependencies (stylelint, prettier)
- `.ruby-version` - Specifies Ruby 2.7.7 (note: Ruby 3.2.x also works)
- `.tool-versions` - Specifies Node.js 18.16.0

**Content Directories:**
- `docs/` - Main content directory with markdown files for playbook pages
  - `docs/resources/` - Design resources, tools, templates, terminology guides
  - `docs/team-charter.md` - Design practice charter and principles
  - `docs/how-we-work.md` - Extensive guide on design practices and workflows
- `_includes/` - Reusable HTML components for page layouts
- `_layouts/` - Page layout templates (default, home, page, post)
- `_sass/` - SCSS stylesheets (mostly from Just the Docs theme)
- `assets/` - Static assets (css/, images/, js/, pdfs/)

**Build Artifacts (excluded from git):**
- `_site/` - Generated static site
- `vendor/` - Bundler gems (local install)
- `.bundle/` - Bundler configuration
- `node_modules/` - npm packages

### Theme and Framework

This site uses **Just the Docs** (v0.5.0), a Jekyll documentation theme. The theme provides navigation structure, search functionality, and styling. Most theme files are in `_includes/`, `_layouts/`, and `_sass/` directories with some vendored components.

## Build and Development Setup

### Prerequisites

You MUST have the following installed:
- Ruby (version 3.2.0 or compatible with ~3.2.0 range)
- Bundler gem
- Node.js (version 18.16.0 or compatible)
- npm (comes with Node.js)

### Initial Setup Process (CRITICAL - Follow in Order)

**Step 1: Install Bundler (if not already installed)**
```bash
gem install bundler --user-install
export PATH="$HOME/.local/share/gem/ruby/3.2.0/bin:$PATH"
```
Note: The `--user-install` flag is required if you don't have system-wide gem permissions. Add the PATH export to your shell profile for persistence.

**Step 2: Configure Bundle for Local Installation**
```bash
bundle config set --local path 'vendor/bundle'
```
This tells bundler to install gems locally in `vendor/bundle` instead of system-wide. This is REQUIRED to avoid permission issues and gem conflicts.

**Step 3: Install Ruby Dependencies**
```bash
bundle install
```
This takes approximately 60-90 seconds. It will install Jekyll 3.9.5, github-pages gem bundle, just-the-docs theme, and all dependencies.

**IMPORTANT**: If you see a bundler version mismatch warning (e.g., "lockfile was generated with 2.4.8"), bundler will automatically install the correct version and retry. This is normal and expected.

**Step 4: Update Jekyll Configuration**

The `_config.yml` file MUST exclude the `vendor/` directory to prevent Jekyll from trying to process gem files. Verify this line exists in the `exclude:` array:
```yaml
exclude:
  [
    # ... other items ...
    "vendor/",
  ]
```
Without this exclusion, Jekyll builds will fail with "Invalid date" errors from template files in the vendor directory.

**Step 5: Install Node.js Dependencies (Optional - for linting only)**
```bash
npm install --legacy-peer-deps
```
Note: The `--legacy-peer-deps` flag is REQUIRED due to version conflicts between stylelint@15 and stylelint-config-prettier@9. Without this flag, npm install will fail with ERESOLVE errors.

If you run `npm install` without the flag and it fails, use:
```bash
npm install --legacy-peer-deps
```

### Building the Site

**Standard Build:**
```bash
export PATH="$HOME/.local/share/gem/ruby/3.2.0/bin:$PATH"  # If bundler is user-installed
bundle exec jekyll build
```
Build time: ~3-4 seconds. Output goes to `_site/` directory.

**Clean Build:**
```bash
bundle exec jekyll clean
bundle exec jekyll build
```

**Development Server with Live Reload:**
```bash
bundle exec jekyll serve
```
This starts a server at `http://localhost:4000/` with auto-regeneration enabled. The server watches for file changes and rebuilds automatically.

**Development Server with Host Binding (for Docker/containers):**
```bash
bundle exec jekyll serve --host 0.0.0.0
```

### Docker Alternative (No Local Ruby Setup Required)

If you don't want to manage Ruby locally, you can use Docker:
```bash
docker run -it --rm=true -v $PWD:$PWD -w $PWD -p 4000:4000 ruby:2.7.2 /bin/bash -c "gem install bundler:2.2.16 && bundle install && bundle exec jekyll serve --host 0.0.0.0"
```
This command:
1. Runs a Ruby 2.7.2 container
2. Mounts the current directory
3. Installs bundler 2.2.16
4. Runs bundle install
5. Starts Jekyll server accessible at localhost:4000

Note: First run takes longer (~2-3 minutes) due to gem installation.

## Testing and Validation

### Linting

**Stylelint (SCSS files):**
```bash
npm test
```
Note: This command will FAIL with "No configuration provided" error because there's no root-level `.stylelintrc` file. The stylelint configuration is only present in the node_modules for vendored components. This is a known issue and does not affect the build.

**Prettier (formatting):**
```bash
npm run format
```
This formats SCSS, JS, and JSON files.

### Manual Validation

After making changes:
1. Run `bundle exec jekyll build` to ensure no build errors
2. Run `bundle exec jekyll serve` to preview changes locally
3. Navigate to affected pages in the browser at `http://localhost:4000/`
4. Check navigation structure (sidebar) renders correctly
5. Verify search functionality works (uses `/assets/js/search-data.json`)

### Testing Content Changes

When editing markdown files in `docs/`:
1. Ensure front matter is present at the top:
   ```yaml
   ---
   layout: default
   title: Page Title
   nav_order: 1
   ---
   ```
2. `layout` should typically be `default`
3. `title` appears in browser tab and page heading
4. `nav_order` controls sidebar position (lower numbers appear first)
5. Run `bundle exec jekyll serve` and verify page appears in navigation

## Common Issues and Workarounds

### Issue 1: Bundle Command Not Found
**Error**: `bash: bundle: command not found`  
**Solution**: 
```bash
gem install bundler --user-install
export PATH="$HOME/.local/share/gem/ruby/3.2.0/bin:$PATH"
```

### Issue 2: Jekyll Build Fails with Invalid Date Error
**Error**: `Invalid date '<%= Time.now.strftime...': Document 'vendor/bundle/.../0000-00-00-welcome-to-jekyll.markdown.erb'`  
**Cause**: Jekyll is trying to process template files in the `vendor/` directory  
**Solution**: Add `"vendor/"` to the `exclude:` array in `_config.yml`

### Issue 3: npm install Fails with ERESOLVE Error
**Error**: `npm error ERESOLVE could not resolve` (stylelint peer dependency conflict)  
**Solution**: Use `npm install --legacy-peer-deps`

### Issue 4: Permission Denied Installing Gems
**Error**: `You don't have write permissions for the /var/lib/gems/3.2.0 directory`  
**Solution**: 
```bash
bundle config set --local path 'vendor/bundle'
bundle install
```

### Issue 5: Stylelint Test Fails
**Error**: `No configuration provided for .../buttons.scss`  
**Status**: This is a known issue. The repository doesn't have a root-level stylelint configuration, and npm test will fail. This doesn't affect the Jekyll build. You can safely skip stylelint testing.

## Repository Maintenance

### Dependencies

**Ruby Gems** (managed by Bundler):
- Updated via `bundle update` (use cautiously, may break compatibility)
- Lock file: `Gemfile.lock`
- The github-pages gem (~231) provides Jekyll and all GitHub Pages compatible plugins

**Node Packages** (managed by npm):
- Updated via `npm update` or Renovate bot (see `renovate.json`)
- Lock file: `package-lock.json`
- Only used for development linting/formatting, not for site generation

### Adding New Pages

1. Create a new `.md` file in `docs/` or appropriate subdirectory
2. Add YAML front matter:
   ```yaml
   ---
   layout: default
   title: Your Page Title
   nav_order: 10
   ---
   ```
3. Write content using Markdown (see `markdowncheatsheet.md` for syntax reference)
4. Build and verify: `bundle exec jekyll serve`

### Modifying Navigation

Navigation is controlled by:
- `nav_order` in front matter (primary)
- Parent-child relationships (for nested pages - see Just the Docs documentation)
- Configuration in `_config.yml` for site-wide settings

## No CI/CD Pipeline

**IMPORTANT**: This repository currently has NO GitHub Actions workflows, continuous integration builds, or automated validation pipelines. All testing and validation must be done locally before pushing changes.

When making changes:
1. Build locally: `bundle exec jekyll build`
2. Test locally: `bundle exec jekyll serve` and manually verify
3. Ensure no build errors or warnings
4. Commit and push

## Pull Request Process

The repository includes a pull request template at `pull_request_template.md`. When creating PRs, use this format:

```markdown
**Pages edited**
[List of pages edited]

**Edits made**
[description or list of edits made]

**Additional notes (optional)**
[Any additional notes you may want reviewers to know about]
```

## Key Points for Efficient Work

1. **ALWAYS** add vendor/ to _config.yml exclude list before building
2. **ALWAYS** use `bundle exec` prefix for Jekyll commands to use correct gem versions
3. **ALWAYS** use `--legacy-peer-deps` with npm install
4. **ALWAYS** configure bundle for local path installation in new environments
5. **DO NOT** commit `vendor/`, `.bundle/`, `_site/`, or `node_modules/` directories
6. **DO NOT** modify theme files in `_includes/vendor/` or `_layouts/vendor/` unless necessary
7. **TRUST** these instructions - the build process is well-tested and documented here
8. For content changes, only edit markdown files in `docs/` directory
9. The site uses Just the Docs theme - refer to theme documentation for advanced customization
10. Search functionality is automatic - just ensure content is in valid markdown with front matter
