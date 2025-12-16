# Supabase Setup Guide

## Redirect URLs Configuration

To enable password reset and email verification functionality, you need to add the following Redirect URLs in your Supabase project dashboard.

### Steps to Add Redirect URLs:

1. Go to your Supabase Dashboard: https://app.supabase.com
2. Select your project
3. Navigate to **Authentication** → **URL Configuration**
4. In the **Redirect URLs** section, add the following URLs:

### Required Redirect URLs:

#### For Local Development:
```
http://localhost:3000/auth/callback
```

#### For Mobile App (Deep Links):
```
io.supabase.ecommerce://reset-password
io.supabase.ecommerce://login-callback
io.supabase.ecommerce://signup-callback
```

#### For Production (when you deploy):
```
https://your-domain.com/auth/callback
```

### Site URL Configuration:

Also set the **Site URL** in the same section to:
- For development: `http://localhost:3000`
- For production: `https://your-domain.com`

### Additional Configuration:

1. **Enable Email Auth Provider:**
   - Go to **Authentication** → **Providers**
   - Make sure **Email** is enabled

2. **Email Templates:**
   - Go to **Authentication** → **Email Templates**
   - Customize the **Reset Password** email template if needed
   - The template will use the redirect URL: `io.supabase.ecommerce://reset-password`

3. **Auth Settings:**
   - Go to **Authentication** → **Settings**
   - Enable **Enable email confirmations** if you want users to verify their email
   - Set **Mailer Templates** for better email appearance

## Testing Password Reset:

1. Run the app: `flutter run`
2. Go to the "Forgot Password" screen
3. Enter your email
4. Click "Send reset link"
5. Check your email for the reset link
6. The link will redirect to the app using the deep link

## Deep Links Setup (Android):

The deep link scheme is already configured in the app:
- Scheme: `io.supabase.ecommerce`
- Host: varies (reset-password, login-callback, etc.)

## Deep Links Setup (iOS):

For iOS, you may need to add URL schemes in `ios/Runner/Info.plist` if not already added.

## Notes:

- Make sure all redirect URLs are added to avoid authentication errors
- The redirect URLs must match exactly (including http/https, trailing slashes, etc.)
- For mobile apps, deep links are recommended over web URLs
