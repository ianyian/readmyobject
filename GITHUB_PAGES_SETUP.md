# 🌐 GitHub Pages Setup Guide

Your GitHub Pages website is ready to go live! This guide will walk you through the 3-minute setup process.

## 📦 What's Included

A complete, professional website in the `/docs` folder:

- **index.html** - Beautiful homepage showcasing your app
- **privacy-policy.html** - Complete privacy policy (App Store requirement)
- **support.html** - Comprehensive help documentation
- **CNAME** - Custom domain support (optional)
- **README.md** - Setup instructions

## 🚀 Quick Setup (3 Minutes)

### Step 1: Push to GitHub (1 minute)

```bash
# Make sure you're in the project directory
cd /Users/xj/git/readmyobject

# Add the new files
git add docs/

# Commit with a descriptive message
git commit -m "Add GitHub Pages website for App Store submission"

# Push to GitHub
git push origin main
```

### Step 2: Enable GitHub Pages (1 minute)

1. Open your browser and go to: https://github.com/ianyian/readmyobject
2. Click **Settings** (the gear icon at the top)
3. Scroll down the left sidebar and click **Pages**
4. Under "Build and deployment" → **Source**:
   - Select **Deploy from a branch**
   - Branch: Choose **main**
   - Folder: Choose **/docs**
5. Click **Save**

### Step 3: Wait & Verify (1 minute)

1. Wait 1-2 minutes for GitHub to build and deploy
2. Refresh the Pages settings page
3. You'll see a green box saying: "Your site is live at https://ianyian.github.io/readmyobject/"
4. Click the link to visit your new website!

## ✅ Verification Checklist

After enabling, verify everything works:

- [ ] Visit https://ianyian.github.io/readmyobject/
- [ ] Homepage loads correctly
- [ ] Click "Privacy Policy" link - should load privacy-policy.html
- [ ] Click "Support" link - should load support.html
- [ ] Test on mobile device (optional but recommended)

## 📱 Use in App Store Connect

Once your GitHub Pages site is live, use these URLs in App Store Connect:

### During App Store Submission

1. **Privacy Policy URL:**

   ```
   https://ianyian.github.io/readmyobject/privacy-policy.html
   ```

2. **Support URL:**

   ```
   https://ianyian.github.io/readmyobject/support.html
   ```

3. **Marketing URL (optional):**
   ```
   https://ianyian.github.io/readmyobject/
   ```

### Where to Enter These URLs

In **App Store Connect**:

1. Go to your app → App Information
2. **Privacy Policy URL** → Enter privacy policy link
3. **Support URL** → Enter support link
4. **Marketing URL** → Enter homepage link (optional)

## 🎨 Customization Required

Before going live, replace placeholder text with your actual information:

### In privacy-policy.html:

- Line ~170: `[Your Email]` → Your actual email
- Line ~171: `[Your Email]` → Your actual email

### In support.html:

- Line ~421: `[Your Email]` → Your actual email
- Line ~422: `[Your Email]` → Your actual email

### In index.html:

- Line ~68: Update App Store link once approved
  ```html
  <a href="YOUR_APP_STORE_URL" class="btn btn-primary"
    >📱 Download on App Store</a
  >
  ```

### Quick Replace Command:

```bash
# Replace all instances of [Your Email] with your actual email
cd docs
# macOS/Linux:
sed -i '' 's/\[Your Email\]/your.email@example.com/g' *.html
# Or manually edit the 3 HTML files
```

## 🌍 Custom Domain (Optional)

Want to use your own domain like `pokercounter.com` instead of `ianyian.github.io`?

### Purchase a Domain

1. Buy from: Namecheap, GoDaddy, Google Domains, etc.
2. Cost: ~$10-15/year

### Configure DNS

Add these A records to your domain's DNS settings:

```
Type: A    Name: @    Value: 185.199.108.153
Type: A    Name: @    Value: 185.199.109.153
Type: A    Name: @    Value: 185.199.110.153
Type: A    Name: @    Value: 185.199.111.153
```

Or add CNAME:

```
Type: CNAME    Name: www    Value: ianyian.github.io
```

### Update CNAME File

Edit `/docs/CNAME`:

```
pokercounter.com
```

### Enable in GitHub

1. Go to GitHub Settings → Pages
2. Custom domain: Enter `pokercounter.com`
3. Check "Enforce HTTPS"
4. Save and wait 10-15 minutes

## 📊 Analytics (Optional)

Want to track visitors? Add Google Analytics:

### Get Tracking ID

1. Go to https://analytics.google.com
2. Create property
3. Get tracking ID (starts with G-)

### Add to Website

Add before `</head>` in index.html, privacy-policy.html, support.html:

```html
<!-- Google Analytics -->
<script
  async
  src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"
></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag() {
    dataLayer.push(arguments);
  }
  gtag("js", new Date());
  gtag("config", "G-XXXXXXXXXX");
</script>
```

## 🧪 Test Locally First

Want to preview before pushing to GitHub?

```bash
# Navigate to docs folder
cd /Users/xj/git/readmyobject/docs

# Start local server
python3 -m http.server 8000

# Open browser
open http://localhost:8000
```

Test all pages and links before pushing!

## 🐛 Troubleshooting

### Site Not Loading (404)

- **Cause:** GitHub Pages not enabled or misconfigured
- **Fix:**
  1. Verify Settings → Pages shows "Your site is live"
  2. Check branch is `main` and folder is `/docs`
  3. Wait 5 minutes and try again
  4. Clear browser cache (Cmd+Shift+R)

### Repository Must Be Public

- **Issue:** "Upgrade to GitHub Pro" message
- **Fix:**
  1. Go to Settings → General
  2. Scroll to "Danger Zone"
  3. Click "Change repository visibility"
  4. Select "Make public"

### Changes Not Appearing

- **Cause:** Browser cache or GitHub build delay
- **Fix:**
  1. Wait 1-2 minutes after pushing
  2. Hard refresh: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)
  3. Try incognito/private browsing
  4. Check Actions tab for build status

### Links Return 404

- **Cause:** Incorrect file names or paths
- **Fix:**
  1. Verify files exist: privacy-policy.html, support.html
  2. Check spelling (case-sensitive!)
  3. Ensure files are in `/docs` folder

### Mobile Display Issues

- **Cause:** Usually screen size differences
- **Fix:** All pages are mobile-responsive, but test on real device

## 📝 Maintenance

### Updating Content

1. Edit HTML files in `/docs` folder
2. Commit and push to GitHub
3. Wait 1-2 minutes for changes to appear

### Adding New Pages

1. Create new `.html` file in `/docs`
2. Update navigation in all existing pages
3. Push to GitHub

### Checking Status

- GitHub Actions tab shows build status
- Settings → Pages shows deployment URL

## 🎉 Success Checklist

You're ready for App Store submission when:

- [x] GitHub Pages created in `/docs` folder
- [ ] Pushed to GitHub (`git push origin main`)
- [ ] Enabled in Settings → Pages
- [ ] Site loads at https://ianyian.github.io/readmyobject/
- [ ] Privacy policy loads correctly
- [ ] Support page loads correctly
- [ ] All placeholder emails replaced with real ones
- [ ] Tested on mobile device
- [ ] URLs copied to App Store Connect

## 🔗 Important URLs Summary

Save these for App Store Connect:

| Purpose        | URL                                                        |
| -------------- | ---------------------------------------------------------- |
| Homepage       | https://ianyian.github.io/readmyobject/                    |
| Privacy Policy | https://ianyian.github.io/readmyobject/privacy-policy.html |
| Support        | https://ianyian.github.io/readmyobject/support.html        |

## 📚 Next Steps

1. ✅ Enable GitHub Pages (follow steps above)
2. ✅ Verify all links work
3. ✅ Replace placeholder emails
4. ✅ Update App Store Connect with URLs
5. 📸 Capture screenshots (see SCREENSHOT_GUIDE.md)
6. 📦 Build and upload to App Store Connect
7. 🚀 Submit for review!

## 💡 Pro Tips

1. **Bookmark your GitHub Pages URL** - You'll reference it often
2. **Test on multiple devices** - Desktop, mobile, tablet
3. **Take screenshots of live pages** - Good for App Store Connect
4. **Enable HTTPS** - GitHub does this automatically
5. **Keep URLs short** - Don't add unnecessary subdirectories

## ❓ Need Help?

- **GitHub Pages Docs:** https://docs.github.com/en/pages
- **This project:** Open issue at https://github.com/ianyian/readmyobject/issues
- **General questions:** See SUPPORT.md

---

## 🎊 Congratulations!

You now have a professional website for your app that's:

- ✅ Free forever
- ✅ Automatically backed up
- ✅ Version controlled with Git
- ✅ Ready for App Store submission
- ✅ Mobile responsive
- ✅ Professional looking

**Your app is one step closer to the App Store! 🚀**

---

_Last updated: December 24, 2025_
