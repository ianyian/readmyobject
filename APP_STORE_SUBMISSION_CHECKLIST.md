# App Store Submission Checklist

Use this checklist to ensure everything is ready before submitting to the App Store.

## 📋 Pre-Submission Tasks

### 1. Xcode Project Configuration

#### App Identity

- [ ] Bundle Identifier set (e.g., com.yourname.pokerchoipcounter)
- [ ] Display Name: "Poker Chip Counter" (or your chosen name)
- [ ] Version: 1.0.0
- [ ] Build Number: 1
- [ ] Minimum Deployment Target: iOS 15.0

**How to check:**

1. Open project in Xcode
2. Select target "readmyobject"
3. Go to "General" tab
4. Verify all fields under "Identity"

#### Permissions & Descriptions

- [ ] Camera usage description added
- [ ] Photo library usage description added

**Required strings in Info.plist:**

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for real-time object detection and counting.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Photo library access allows you to detect objects in your existing photos.</string>
```

**How to add:**

1. In Xcode, select target
2. Go to "Info" tab
3. Add these keys with descriptions
4. Or edit Info.plist directly

#### App Icon

- [ ] 1024x1024px icon created
- [ ] PNG format, no transparency
- [ ] No rounded corners (iOS adds them)
- [ ] Icon added to Assets.xcassets/AppIcon

**Design tips:**

- Simple, recognizable design
- Clear at small sizes
- Avoid text (hard to read when small)
- Consider poker chip imagery
- Test on actual device

#### Signing & Capabilities

- [ ] Team selected
- [ ] Automatic signing enabled (or manual certificates configured)
- [ ] Provisioning profile valid
- [ ] No signing errors

**How to verify:**

1. Select target → "Signing & Capabilities"
2. Ensure "Automatically manage signing" is checked
3. Select your Team
4. Verify no errors shown

### 2. Build & Testing

#### Code Quality

- [ ] No build errors
- [ ] No warnings (or all justified)
- [ ] All TODO comments resolved or documented
- [ ] Dead code removed
- [ ] Console logs cleaned up (or marked DEBUG-only)

**Command to check:**

```bash
xcodebuild -project readmyobject.xcodeproj \
  -scheme readmyobject \
  -sdk iphonesimulator \
  build 2>&1 | grep -E "error:|warning:"
```

#### Testing on Device

- [ ] Tested on physical iPhone (iOS 15.0+)
- [ ] Camera detection works
- [ ] Photo library access works
- [ ] Live detection works
- [ ] Tap-to-pause works
- [ ] Charts update correctly
- [ ] Settings save and load
- [ ] Dark mode works
- [ ] App doesn't crash
- [ ] Memory usage reasonable
- [ ] Battery drain acceptable

#### Testing Scenarios

- [ ] Fresh install (delete and reinstall)
- [ ] Permission denial handling (deny, then allow)
- [ ] Interrupted camera (phone call during live detection)
- [ ] Background/foreground transitions
- [ ] Low memory conditions
- [ ] Different iPhone models tested
- [ ] Different iOS versions tested (15.0, 16.0, 17.0, 18.0)

### 3. App Store Connect Setup

#### Account Preparation

- [ ] Apple Developer account active ($99/year)
- [ ] Paid Developer Program member
- [ ] Agreements accepted in App Store Connect
- [ ] Tax forms completed
- [ ] Banking information added (if paid app)

**URL:** https://appstoreconnect.apple.com

#### App Creation

- [ ] App created in App Store Connect
- [ ] Bundle ID matches Xcode project
- [ ] SKU assigned (unique identifier, e.g., POKERCOUNTER001)
- [ ] Primary language selected (English)

**Steps:**

1. Go to App Store Connect
2. Click "My Apps" → "+" → "New App"
3. Select iOS
4. Enter app name
5. Select primary language
6. Choose bundle ID
7. Enter SKU
8. Click "Create"

### 4. App Store Metadata

#### Required Information

- [ ] App name (max 30 characters)
- [ ] Subtitle (max 30 characters)
- [ ] Description (4000 characters)
- [ ] Keywords (100 characters, comma-separated)
- [ ] Privacy Policy URL published
- [ ] Support URL provided
- [ ] Marketing URL (optional)

**URLs to provide:**

```
Privacy Policy: https://github.com/ianyian/readmyobject/blob/main/PRIVACY_POLICY.md
Support URL: https://github.com/ianyian/readmyobject/blob/main/SUPPORT.md
Marketing URL: https://github.com/ianyian/readmyobject
```

#### Categories

- [ ] Primary category selected: Utilities
- [ ] Secondary category selected: Productivity
- [ ] Age rating completed: 4+

#### Screenshots (Required)

Create screenshots for these sizes:

**iPhone 6.7" (iPhone 15 Pro Max, 14 Pro Max, 13 Pro Max, 12 Pro Max)**

- [ ] 1290 x 2796 pixels (portrait)
- [ ] 5 screenshots minimum

**iPhone 6.5" (iPhone 11 Pro Max, XS Max)**

- [ ] 1242 x 2688 pixels (portrait)
- [ ] 5 screenshots minimum

**Recommended Screenshots:**

1. Main screen with 3 buttons
2. Photo detection showing poker chips with boxes
3. Live detection in action
4. Detection charts and CPU monitoring
5. Settings page

**Optional but Recommended:**

- [ ] iPhone 5.5" (1242 x 2208)
- [ ] iPad Pro 12.9" (2048 x 2732)
- [ ] iPad Pro 11" (1668 x 2388)

#### App Preview Video (Optional)

- [ ] 15-30 second video created
- [ ] Portrait orientation (1080x1920)
- [ ] Shows actual app functionality
- [ ] No audio narration (use text captions)
- [ ] Uploaded for each device size

### 5. Pricing & Availability

#### Pricing

- [ ] Price tier selected ($0.00 - $999.99)
- [ ] Start date set
- [ ] Pre-order option configured (if applicable)

**Recommendations:**

- Free: Best for building user base
- $0.99-$1.99: Impulse buy price
- $2.99-$4.99: Premium utility pricing
- $9.99+: Professional tool pricing

#### Availability

- [ ] Countries/regions selected (can select all)
- [ ] Release option chosen:
  - [ ] Manually release after approval
  - [ ] Automatically release after approval

### 6. App Review Information

#### Contact Information

- [ ] First name entered
- [ ] Last name entered
- [ ] Phone number (with country code)
- [ ] Email address

#### Demo Account

- [ ] Not required (app doesn't need login) ✓

#### Notes for Reviewer

- [ ] Testing instructions provided
- [ ] Features to test listed
- [ ] Any special notes added

**Template provided in APP_STORE_METADATA.md**

#### Attachments

- [ ] Test photos uploaded (optional, but helpful)
- [ ] Demo video link provided (if applicable)

### 7. Legal & Compliance

#### Content Rights

- [ ] "I have the necessary rights" declared
- [ ] No third-party content used without permission
- [ ] ML models are original or properly licensed

#### Export Compliance

- [ ] Export laws reviewed
- [ ] Encryption declaration completed

**For this app:**

- Uses standard iOS encryption only
- Answer "NO" to "Does your app use encryption?"
- Or answer "YES" and select "App uses Apple's encryption"

#### Government Endorsement

- [ ] Declare if applicable (likely NO for this app)

#### Age Rating Questionnaire

Complete the age rating questionnaire:

- [ ] No objectionable content
- [ ] No violence
- [ ] No realistic violence
- [ ] No sexual content
- [ ] No nudity
- [ ] No profanity
- [ ] No mature themes
- [ ] No gambling
- [ ] No unrestricted web access
- [ ] No user-generated content

**Result should be: 4+**

### 8. Build Upload

#### Archive Creation

- [ ] Scheme set to "Release"
- [ ] Device selected as "Any iOS Device (arm64)"
- [ ] Product → Archive successful
- [ ] No errors in archive process

**Steps:**

1. In Xcode: Product → Scheme → Edit Scheme
2. Set "Build Configuration" to "Release"
3. Select "Any iOS Device" from device selector
4. Product → Archive
5. Wait for archive to complete

#### Validation

- [ ] Archive validated successfully
- [ ] No warnings or errors
- [ ] App thinning configured
- [ ] Bitcode settings correct

**Steps:**

1. In Organizer window
2. Select your archive
3. Click "Validate App"
4. Follow prompts
5. Wait for validation
6. Review any issues

#### Distribution

- [ ] Archive distributed to App Store Connect
- [ ] Upload completed successfully
- [ ] Build appears in App Store Connect (may take 10-30 minutes)
- [ ] Build processed successfully
- [ ] No build warnings

**Steps:**

1. After validation, click "Distribute App"
2. Select "App Store Connect"
3. Click "Upload"
4. Wait for upload (can take 5-30 minutes)
5. Check App Store Connect for build

### 9. Build Selection in App Store Connect

#### Build Processing

- [ ] Build shows in "Activity" tab
- [ ] Processing status complete (can take 15-60 minutes)
- [ ] No processing errors
- [ ] Build available for selection

#### Version Selection

- [ ] Build selected for version 1.0.0
- [ ] All required metadata complete
- [ ] Screenshots uploaded
- [ ] Ready for submission

### 10. Final Pre-Submission Review

#### One Last Check

- [ ] All required fields filled (look for red warnings)
- [ ] Screenshots look professional
- [ ] Description has no typos
- [ ] URLs all work (click each one)
- [ ] Contact information correct
- [ ] Privacy policy accessible
- [ ] Support page accessible
- [ ] App icon looks good in App Store Connect preview

#### Test on Real Device (Again)

- [ ] Download build from TestFlight (if available)
- [ ] Or test with archived build
- [ ] Verify everything works
- [ ] No last-minute bugs

### 11. Submit for Review

#### Submission

- [ ] Click "Submit for Review"
- [ ] Review submission details
- [ ] Confirm submission
- [ ] Receive confirmation email

#### Post-Submission

- [ ] Status changes to "Waiting for Review"
- [ ] Review typically takes 24-48 hours
- [ ] Monitor email for updates
- [ ] Respond promptly to any reviewer questions

## 📧 During Review Process

### If Approved ✅

- [ ] Status: "Ready for Sale" or "Pending Developer Release"
- [ ] If manual release: Click "Release This Version"
- [ ] App appears in App Store within hours
- [ ] Test download from App Store
- [ ] Share with friends and family
- [ ] Post on social media
- [ ] Submit to app review sites

### If Rejected ❌

- [ ] Read rejection reason carefully
- [ ] Check Resolution Center in App Store Connect
- [ ] Fix issues mentioned
- [ ] Update build if needed
- [ ] Respond to reviewer via Resolution Center
- [ ] Resubmit when ready

### Common Rejection Reasons

1. **Missing permissions explanations** → Add clear usage descriptions
2. **Crash during review** → Test thoroughly on physical device
3. **Incomplete metadata** → Double-check all required fields
4. **Privacy policy missing/incorrect** → Ensure URL is accessible
5. **Screenshots don't match app** → Use actual app screenshots
6. **Guideline violations** → Review App Store Review Guidelines

## 🎉 Post-Launch Checklist

### Week 1

- [ ] Monitor crash reports in App Store Connect
- [ ] Respond to user reviews (within 48 hours)
- [ ] Track downloads and installs
- [ ] Share on social media
- [ ] Ask friends/family to rate and review

### Month 1

- [ ] Collect user feedback
- [ ] Plan version 1.1 features
- [ ] Fix any critical bugs
- [ ] Submit update if needed

### Ongoing

- [ ] Monitor reviews weekly
- [ ] Respond to support emails within 48 hours
- [ ] Plan regular updates (every 2-3 months)
- [ ] Keep up with iOS updates

## 📱 Quick Reference

### Important URLs

- **App Store Connect**: https://appstoreconnect.apple.com
- **Developer Portal**: https://developer.apple.com
- **App Store Review Guidelines**: https://developer.apple.com/app-store/review/guidelines/
- **Human Interface Guidelines**: https://developer.apple.com/design/human-interface-guidelines/

### Timeline Estimates

- Account setup: 1-2 hours
- Metadata preparation: 2-4 hours
- Screenshot creation: 1-3 hours
- Archive & upload: 30-60 minutes
- Build processing: 15-60 minutes
- App review: 24-48 hours (sometimes longer)
- **Total: 3-7 days from start to approval**

### Support Contacts

- **App Store Connect Support**: In-app support chat
- **Developer Program Support**: https://developer.apple.com/contact/

## 🎯 Success Criteria

Before submitting, ensure:
✅ App works flawlessly on physical device  
✅ All permissions properly explained  
✅ Privacy policy is accurate and accessible  
✅ Screenshots are professional quality  
✅ Description is compelling and accurate  
✅ No crashes or major bugs  
✅ Tested on multiple iOS versions  
✅ All metadata complete and spell-checked

---

**Good luck with your submission! 🚀**

_This checklist is for Poker Chip Counter v1.0.0_  
_Last updated: December 24, 2025_
