# Supabase Storage Setup for Profile Images

## Steps to Configure Supabase Storage

### 1. Open your Supabase Dashboard
Go to: https://app.supabase.com

### 2. Select your project
Choose your project: **blpirgrhytbjmapmjfnq.supabase.co**

### 3. Create Storage Bucket

1. Navigate to **Storage** in the left sidebar
2. Click **Create a new bucket**
3. Enter the following details:
   - **Name**: `profiles`
   - **Public bucket**: Enable this option (toggle ON)
   - **File size limit**: Leave default or set to 5MB
   - **Allowed MIME types**: Leave empty (allows all) or specify: `image/jpeg,image/png,image/jpg`

4. Click **Create bucket**

### 4. Configure Bucket Policies (Important!)

To allow users to upload their own profile pictures:

1. Click on the `profiles` bucket you just created
2. Go to **Policies** tab
3. Click **New Policy**

#### Policy 1: Allow Authenticated Users to Upload
- **Policy name**: `Allow authenticated users to upload their avatars`
- **Allowed operation**: INSERT
- **Target roles**: `authenticated`
- **Policy definition**:
```sql
(bucket_id = 'profiles'::text) AND (auth.uid()::text = (storage.foldername(name))[1])
```

#### Policy 2: Allow Public Read Access
- **Policy name**: `Allow public read access`
- **Allowed operation**: SELECT
- **Target roles**: `public`
- **Policy definition**:
```sql
bucket_id = 'profiles'::text
```

#### Policy 3: Allow Users to Update Their Own Files
- **Policy name**: `Allow users to update their own files`
- **Allowed operation**: UPDATE
- **Target roles**: `authenticated`
- **Policy definition**:
```sql
(bucket_id = 'profiles'::text) AND (auth.uid()::text = (storage.foldername(name))[1])
```

#### Policy 4: Allow Users to Delete Their Own Files
- **Policy name**: `Allow users to delete their own files`
- **Allowed operation**: DELETE
- **Target roles**: `authenticated`
- **Policy definition**:
```sql
(bucket_id = 'profiles'::text) AND (auth.uid()::text = (storage.foldername(name))[1])
```

### 5. Test the Setup

1. Run your Flutter app
2. Sign in with your account
3. Go to Profile section
4. Click "Edit Profile"
5. Upload a profile picture
6. Save changes

---

## Folder Structure in Storage

The app will organize files like this:
```
profiles/
├── avatars/
│   ├── profile_<user_id>_<timestamp>.jpg
│   ├── profile_<user_id>_<timestamp>.jpg
│   └── ...
```

---

## Alternative: Quick Setup with SQL

If you prefer to set up policies using SQL, go to **SQL Editor** and run:

```sql
-- Create the profiles bucket (if not created via UI)
INSERT INTO storage.buckets (id, name, public)
VALUES ('profiles', 'profiles', true);

-- Policy: Allow authenticated users to upload
CREATE POLICY "Allow authenticated users to upload their avatars"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'profiles' AND
    auth.uid()::text = (storage.foldername(name))[1]
);

-- Policy: Allow public read access
CREATE POLICY "Allow public read access"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'profiles');

-- Policy: Allow users to update their own files
CREATE POLICY "Allow users to update their own files"
ON storage.objects FOR UPDATE
TO authenticated
USING (
    bucket_id = 'profiles' AND
    auth.uid()::text = (storage.foldername(name))[1]
);

-- Policy: Allow users to delete their own files
CREATE POLICY "Allow users to delete their own files"
ON storage.objects FOR DELETE
TO authenticated
USING (
    bucket_id = 'profiles' AND
    auth.uid()::text = (storage.foldername(name))[1]
);
```

---

## Troubleshooting

### Error: "new row violates row-level security policy"
- Make sure you've enabled all the policies above
- Check that the bucket is marked as public
- Verify the user is authenticated

### Error: "Bucket not found"
- Verify the bucket name is exactly `profiles` (lowercase)
- Check that the bucket was created successfully

### Images not loading
- Check that the bucket is marked as **public**
- Verify the image URL is correct
- Check network connectivity

---

## Important Notes

- The storage bucket is set to **public** so profile images can be viewed by anyone
- Users can only upload/update/delete their own files (enforced by RLS policies)
- File paths include user ID for organization and security
- Images are stored with timestamps to prevent caching issues

---

✅ **Setup Complete!**

Now users can:
- Upload profile pictures ✓
- Update their profile information ✓
- View their profile with real data from Supabase ✓
