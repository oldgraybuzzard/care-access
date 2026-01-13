# Testing Child CRUD Functionality

## ✅ Quick Test Checklist

### Test 1: Create a New Child
1. **Navigate to Children Screen**
   - Open the app drawer (hamburger menu)
   - Tap "Children"
   - You should see the children list

2. **Open Add Child Form**
   - Tap the **+** button in the top-right corner
   - You should see "Add New Child" screen

3. **Fill Out Required Fields**
   - First Name: `Test`
   - Last Name: `Child`
   - Date of Birth: Tap the field and select a date (e.g., 5 years ago)
   - Gender: Select `Male` or `Female`

4. **Fill Out Optional Fields** (optional)
   - Nickname: `Testy`
   - Race/Ethnicity: `Hispanic`
   - Preferred Language: `English`
   - Status: `Active`
   - Referral Source: `School`
   - Referral Reason: `Behavioral issues`

5. **Save**
   - Scroll to bottom
   - Tap **Create Child** button
   - You should see a success message
   - You should be returned to the children list
   - The new child should appear in the list

### Test 2: View Child Profile
1. **Open the Child**
   - Tap on the child card you just created
   - You should see the child profile screen

2. **Verify Information**
   - Check that the header shows the correct name and age
   - Browse through the 6 tabs:
     - Overview
     - Medical
     - Education
     - Behavioral
     - Family
     - Goals

### Test 3: Edit the Child
1. **Open Edit Form**
   - While viewing the child profile
   - Tap the **edit icon** (pencil) in the top-right corner
   - You should see "Edit Child" screen
   - All fields should be pre-filled with existing data

2. **Make Changes**
   - Change the nickname to something else (e.g., `Updated Nickname`)
   - Change the status to `Inactive`
   - Add or modify the presenting issues

3. **Save Changes**
   - Tap **Update Child** button
   - You should see a success message
   - You should be returned to the profile
   - The profile should show the updated information

### Test 4: Validation
1. **Test Required Fields**
   - Go to add a new child
   - Leave First Name empty
   - Try to save
   - You should see "First name is required" error

2. **Test Date of Birth**
   - Fill in First Name and Last Name
   - Don't select a date of birth
   - Try to save
   - You should see "Please select date of birth" message

## Expected Behavior

### ✅ Success Indicators
- Green snackbar messages for successful operations
- Automatic navigation back to previous screen
- Lists and profiles refresh automatically
- Form validation prevents invalid submissions

### ❌ Error Handling
- Red snackbar for errors
- Form validation messages appear below fields
- Network errors show appropriate messages

## API Calls to Verify

Check the terminal/console logs for these API calls:

### Creating a Child
```
🚀 POST /children
✅ 201 /children
```

### Updating a Child
```
🚀 PATCH /children/:id
✅ 200 /children/:id
```

### Loading Children List
```
🚀 GET /children
✅ 200 /children
```

### Loading Child Profile
```
🚀 GET /children/:id
✅ 200 /children/:id
```

## Database Verification

You can also verify in the database:

```sql
-- Check all children
SELECT id, "firstName", "lastName", nickname, status, "createdAt", "updatedAt"
FROM children
ORDER BY "createdAt" DESC;

-- Check audit logs
SELECT action, "entityType", "entityId", "userId", "timestamp", changes
FROM audit_logs
WHERE "entityType" = 'Child'
ORDER BY "timestamp" DESC
LIMIT 10;
```

## Known Limitations

### Not Yet Implemented:
- ❌ Photo upload (photoUrl field exists but no UI to upload)
- ❌ Delete child functionality
- ❌ Bulk operations
- ❌ Advanced filtering/sorting

### Working Features:
- ✅ Create child
- ✅ Read/view child (list and detail)
- ✅ Update child
- ✅ Form validation
- ✅ Error handling
- ✅ Auto-refresh after changes
- ✅ Search children by name
- ✅ Comprehensive profile view with 6 tabs

## Troubleshooting

### Issue: "Error saving child"
- Check that the API server is running
- Check network connectivity
- Verify JWT token is valid (try logging out and back in)

### Issue: Form doesn't save
- Make sure all required fields are filled
- Check for validation errors
- Look at console logs for API errors

### Issue: List doesn't refresh
- Pull down to refresh manually
- Navigate away and back
- Check that the API returned success

## Next Steps

After verifying CRUD works:
1. Implement photo upload
2. Add delete functionality
3. Create child intake form
4. Add more advanced filtering
5. Implement bulk operations

