# GitHub Pages Setup

This folder contains the GitHub Pages website for Poker Chip Counter.

## 🌐 Live Website

Once you enable GitHub Pages, your site will be available at:
```
https://ianyian.github.io/readmyobject/
```

## 📋 Files in This Folder

- **index.html** - Home page with app overview
- **privacy-policy.html** - Privacy policy (required for App Store)
- **support.html** - Support and help documentation
- **CNAME** - Custom domain configuration (optional)
- **README.md** - This file

## 🚀 How to Enable GitHub Pages

### Step 1: Push to GitHub
```bash
cd /Users/xj/git/readmyobject
git add docs/
git commit -m "Add GitHub Pages website"
git push origin main
```

### Step 2: Enable in Repository Settings
1. Go to https://github.com/ianyian/readmyobject
2. Click **Settings** (gear icon)
3. Scroll down to **Pages** in the left sidebar
4. Under **Source**:
   - Branch: `main`
   - Folder: `/docs`
5. Click **Save**
6. Wait 1-2 minutes for deployment

### Step 3: Verify
Visit: https://ianyian.github.io/readmyobject/

You should see your app's homepage!

## 📱 Use in App Store Connect

Once GitHub Pages is live, use these URLs in App Store Connect:

### Privacy Policy URL
```
https://ianyian.github.io/readmyobject/privacy-policy.html
```

### Support URL
```
https://ianyian.github.io/readmyobject/support.html
```

### Marketing URL (Optional)
```
https://ianyian.github.io/readmyobject/
```

## 🎨 Customization

### Update Contact Information
Replace `[Your Email]` in:
- support.html (multiple places)
- privacy-policy.html

### Update App Store Link
Once your app is approved, update the App Store link in:
- index.html (line ~68): Replace `https://apps.apple.com` with your actual App Store URL

### Add Custom Domain (Optional)
If you own a domain like `pokercounter.com`:

1. **Update CNAME file:**
   ```
   pokercounter.com
   ```

2. **Configure DNS with your domain registrar:**
   - Add A records pointing to GitHub Pages IPs:
     - 185.199.108.153
     - 185.199.109.153
     - 185.199.110.153
     - 185.199.111.153
   - Or add a CNAME record: `ianyian.github.io`

3. **Enable in GitHub Settings:**
   - Go to Settings → Pages
   - Enter your custom domain
   - Check "Enforce HTTPS"

## 🔧 Testing Locally

To test the website locally before pushing:

```bash
cd docs
python3 -m http.server 8000
```

Then open: http://localhost:8000

## 📊 Analytics (Optional)

To add Google Analytics:

1. Get tracking ID from https://analytics.google.com
2. Add this before `</head>` in all HTML files:

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

## ✅ Checklist

Before enabling GitHub Pages:

- [ ] Repository is public (required for free GitHub Pages)
- [ ] All placeholder text is updated with your information
- [ ] Email addresses are replaced with real ones
- [ ] Tested locally (optional but recommended)
- [ ] Ready to push to GitHub

After enabling GitHub Pages:

- [ ] Wait 1-2 minutes for deployment
- [ ] Visit the live URL to verify
- [ ] Test all navigation links
- [ ] Test on mobile devices
- [ ] Update App Store Connect with URLs

## 🐛 Troubleshooting

### Site Not Loading
- Make sure repository is public
- Check Settings → Pages is configured correctly
- Wait 5-10 minutes after enabling
- Try clearing browser cache

### 404 Errors
- Verify files are in `/docs` folder
- Check file names are correct (case-sensitive)
- Ensure `index.html` exists

### Updates Not Showing
- Clear browser cache
- Wait 1-2 minutes after pushing changes
- Try incognito/private browsing mode
- Check GitHub Actions for build status

## 🎉 Success!

Once GitHub Pages is live:
1. Your privacy policy and support pages are publicly accessible
2. You can use these URLs in App Store Connect
3. Users can visit your app's website
4. Everything is free and hosted by GitHub

---

**Questions?** See the [main README](../README.md) or open an issue on GitHub.
