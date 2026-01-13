# Child Management Guide

## Overview
The FCF app now has full CRUD (Create, Read, Update, Delete) functionality for managing children profiles.

## Features Implemented

### ✅ 1. View Children List (UPDATED)
- Navigate to **Children** from the drawer menu
- Search children by name or nickname
- View child cards with photo, name, age, gender, and status
- Tap any child card to view their full profile

### ✅ 2. Add New Child (UPDATED - 2 Options)

**Option A: Quick Add (Simple Form)**
1. Go to the Children list screen
2. Tap the **+** button in the top-right corner
3. Select **"Quick Add Child"**
4. Fill out the basic child information form:
   - **Basic Information** (required):
     - First Name *
     - Last Name *
     - Date of Birth *
     - Gender *
   - **Optional Information**:
     - Middle Name
     - Nickname
     - Race/Ethnicity
     - Preferred Language
   - **Status Information**:
     - Status (Active/Inactive/Discharged)
     - Custody Status
     - Legal Status
   - **Referral Information**:
     - Referral Source
     - Referral Reason
     - Presenting Issues
5. Tap **Create Child** to save
6. The list will automatically refresh with the new child

**Option B: Full Intake Form (Comprehensive 6-Step Wizard)** 🆕
1. Go to the Children list screen
2. Tap the **+** button in the top-right corner
3. Select **"Full Intake Form"**
4. Complete all 6 steps:
   - Step 1: Basic Information (required)
   - Step 2: Referral Information
   - Step 3: Status & Legal
   - Step 4: Medical Information
   - Step 5: Behavioral & Trauma
   - Step 6: Personal Information
5. Tap **Submit** on the final step
6. The child is created with comprehensive information

**See [DELETE_AND_INTAKE_GUIDE.md](DELETE_AND_INTAKE_GUIDE.md) for detailed intake form documentation.**

### ✅ 3. Edit Existing Child
**How to edit a child:**
1. Open a child's profile
2. Tap the **edit icon** (pencil) in the top-right corner
3. Update any fields you want to change
4. Tap **Update Child** to save
5. The profile will automatically refresh with updated information

### ✅ 4. View Child Profile
**Comprehensive profile with 6 tabs:**
- **Overview**: Quick stats, interests, strengths, coping mechanisms
- **Medical**: Medications, allergies, conditions, mental health diagnoses
- **Education**: School records, grades, attendance, behavior
- **Behavioral**: Trauma history, attachment style, triggers
- **Family**: Family information and contact details
- **Goals**: Active goals and progress tracking

### ✅ 5. Delete Child 🆕
**How to delete a child:**
1. Open a child's profile
2. Tap the **menu icon** (⋮) in the top-right corner
3. Select **"Delete Child"** (shown in red)
4. Review the confirmation dialog
5. Tap **Delete** to confirm or **Cancel** to abort
6. The child is marked as deleted (soft delete)
7. Deleted children are hidden from the list

**Note**: This is a soft delete - the child's status is set to "Deleted" but the record is preserved in the database for audit purposes.

**See [DELETE_AND_INTAKE_GUIDE.md](DELETE_AND_INTAKE_GUIDE.md) for detailed delete documentation.**

## Backend API Endpoints

All endpoints are already implemented and working:

```
POST   /api/children              - Create new child
GET    /api/children              - List all children (with filters)
GET    /api/children/:id          - Get child details
PATCH  /api/children/:id          - Update child
DELETE /api/children/:id          - Delete child (soft delete) 🆕
```

### API Features:
- ✅ Full validation with DTOs
- ✅ Audit logging for all operations
- ✅ JWT authentication required
- ✅ Comprehensive error handling

## What's NOT Yet Implemented (Updated)

### ⚠️ Photo Upload
**Status**: Not implemented yet (ONLY REMAINING FEATURE)

**What's needed:**
1. **Backend**:
   - File upload endpoint (e.g., `POST /api/children/:id/photo`)
   - Integration with cloud storage (AWS S3, Cloudinary, etc.)
   - Image processing/resizing
   - Update child's `photoUrl` field

2. **Flutter**:
   - Add `image_picker` package to `pubspec.yaml`
   - Create photo picker UI in the form
   - Upload photo to backend
   - Display uploaded photo in profile

**Recommended approach:**
```dart
// Add to pubspec.yaml
dependencies:
  image_picker: ^1.0.0

// In child_form_screen.dart
import 'package:image_picker/image_picker.dart';

Future<void> _pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    // Upload to backend
    // Update photoUrl
  }
}
```

### ✅ Child Intake Form
**Status**: ✅ IMPLEMENTED!

A comprehensive 6-step wizard for complete child onboarding:
- Step 1: Basic Information
- Step 2: Referral Information
- Step 3: Status & Legal
- Step 4: Medical Information
- Step 5: Behavioral & Trauma
- Step 6: Personal Information

**See [DELETE_AND_INTAKE_GUIDE.md](DELETE_AND_INTAKE_GUIDE.md) for complete documentation.**

### ✅ Delete Child
**Status**: ✅ IMPLEMENTED!

Soft delete functionality with:
- Backend endpoint: `DELETE /api/children/:id`
- Soft delete (sets status to 'Deleted')
- Confirmation dialog in Flutter
- Audit logging
- Automatic filtering of deleted children

**See [DELETE_AND_INTAKE_GUIDE.md](DELETE_AND_INTAKE_GUIDE.md) for complete documentation.**

## Data Model

The Child model includes these fields:

**Basic Info**: firstName, middleName, lastName, nickname, dateOfBirth, gender, raceEthnicity, preferredLanguage

**Identifiers**: ssn, medicaidId, schoolId, photoUrl

**Status**: status, custodyStatus, legalStatus

**Referral**: referralSource, referralReason, presentingIssues

**Medical**: medications[], allergies[], medicalConditions[], mentalHealthDx[]

**Behavioral**: traumaHistory, attachmentStyle, triggers[], copingMechanisms[]

**Personal**: interests[], strengths[], likes[], dislikes[], fears[]

**Relations**: familyId, clientId

## Testing

**To test the functionality:**

1. **Create a child**:
   ```
   - Go to Children screen
   - Tap + button
   - Fill in: First Name, Last Name, DOB, Gender
   - Tap Create Child
   ```

2. **Edit a child**:
   ```
   - Open any child profile
   - Tap edit icon
   - Change any field
   - Tap Update Child
   ```

3. **Verify**:
   - Check that the list refreshes
   - Check that the profile updates
   - Check audit logs in the database

## Next Steps

**Priority 1 - Photo Upload**:
- Implement backend file upload
- Add image picker to Flutter form
- Test photo upload and display

**Priority 2 - Child Intake**:
- Design intake workflow
- Create multi-step form
- Integrate with assessments

**Priority 3 - Advanced Features**:
- Bulk import children
- Export child data
- Print child profile
- Share child information securely

