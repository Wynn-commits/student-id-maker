# El Pueblo Dormitory - Admin Rooms & Details System

## Overview
Complete admin room management system with add/edit functionality, room availability tracking, and detailed room information display.

## Features
✅ **View All Rooms** - Separated by Men's and Women's rooms
✅ **Add New Rooms** - Create new rooms with full details
✅ **Edit Rooms** - Update room information, status, and pricing
✅ **Room Details Page** - View comprehensive room information
✅ **Occupancy Tracking** - See current occupants and availability
✅ **Visual Status Indicators** - Unavailable rooms shown with overlay
✅ **Responsive Design** - Works on all devices
✅ **Database Integration** - Full CRUD operations
✅ **Your Original Design** - 100% preserved

## File Structure
```
admin_rooms_system/
├── Admin-rooms/
│   └── index.php              # Main rooms listing page
├── Admin-details/
│   └── index.php              # Room details page
├── php/
│   ├── add_room.php           # Add new room handler
│   ├── edit_room.php          # Update room handler
│   └── get_room.php           # Fetch room data (AJAX)
├── css/
│   └── style.css              # All styles combined
├── js/
│   └── script.js              # Modal & interactions
└── db_config.php              # Database configuration
```

## Installation Instructions

### 1. Database Setup
The database tables are already created from `elpueblo_database.sql`. The `rooms` table is ready to use.

### 2. File Setup
1. Copy the entire `admin_rooms_system` folder to your AMPPS htdocs directory:
   - Windows: `C:\Program Files\Ampps\www\`
   - Mac: `/Applications/AMPPS/www/`

2. Make sure your folder structure matches:
   ```
   htdocs/
   └── Elpueblo_Project/           # Your main project folder
       ├── Admin-rooms/            # This system
       ├── Admin-details/          # This system
       ├── Admin-reservation/      # Your reservation system
       ├── Images/                 # Your images
       ├── db_config.php           # Root config file
       └── ...other folders
   ```

### 3. Database Configuration
The `db_config.php` is already configured:
- Host: localhost
- Username: root
- Password: mysql
- Database: elpueblo_dorm

### 4. Required Images
Make sure these images exist in your `../Images/` folder:
- `left-arrow-1.png`
- `elpueblo-removebg-preview1.png`
- `backgrounddorm1.jpg`
- `chekcmark-icon30.png`
- `average-price0-icon30.png`
- `bunk-bed-icon30.png`
- `smart-shelf30.png`
- `Wi-Fi-icon30.png`
- `vacuum-cleaner-icon30.png`
- `bureau-icon-30.png`
- `dishwasher-icon30.png`
- `vertical-line100.png`
- `Coffee-High-Definition-Desktop-Wallpaper.jpg`

### 5. Access the System
Open your browser and go to:
- **Room Listing**: `http://localhost/Elpueblo_Project/Admin-rooms/index.php`
- **Room Details**: Click "More Details" on any room card

## Features Explained

### Admin Rooms Page (index.php)

#### View Rooms
- Displays all rooms separated by gender (Men's/Women's)
- Shows room number, capacity, available slots, and price
- Visual indicators for unavailable rooms (occupied/maintenance)
- Rooms with overlay effect when not available

#### Add Room Button
- Click "+ Add Room" button for Men's or Women's section
- Modal popup appears with form
- Fields:
  - Room Number (required)
  - Capacity (number of beds)
  - Price per Month
  - Floor
  - Status (Available/Occupied/Maintenance)
  - Description (optional)
- Room type automatically set based on which section you clicked

#### Edit Room Button (✏️)
- Small edit button on top-right of each room card
- Opens modal with current room data
- Can update all room information
- Cannot set capacity lower than current occupancy (safety check)
- Updates room status and availability

### Room Details Page (index.php)

#### Room Information
- Image gallery with thumbnail navigation
- Click thumbnails to change main image
- Comprehensive room details:
  - Room number and type
  - Floor location
  - Bed capacity
  - Available slots
  - Monthly price
  - Status (Available/Occupied/Maintenance)
  - Description
  - Facilities icons

#### Current Occupants Section
- Shows who is currently staying in the room
- Displays:
  - Guest name
  - Email
  - Phone number
  - Check-in date
  - Booking status (Confirmed/Pending)
- Only appears if room has occupants

#### Room Summary Panel
- Right sidebar with quick overview
- Pricing details
- Room specifications
- Quick action button to view all reservations

## How It Works

### Adding a Room
1. Click "+ Add Room" button (Men's or Women's section)
2. Fill in the form:
   - Room number (e.g., "101", "202")
   - Capacity (how many beds)
   - Monthly price
   - Floor number
   - Status
   - Description (optional)
3. Click "Add Room"
4. Room appears in the appropriate section
5. Success message shows at top-right

### Editing a Room
1. Click the ✏️ edit button on any room card
2. Modal opens with current room data
3. Modify any fields you want to update
4. Click "Update Room"
5. Changes are saved to database
6. Success message shows at top-right

### Room Status Management
You can set room status to:
- **Available**: Room is ready for booking
- **Occupied**: Room is currently occupied
- **Maintenance**: Room is under maintenance

Occupied and Maintenance rooms show with an overlay effect and reduced opacity.

### Viewing Room Details
1. Click "More Details" button on any room card
2. See comprehensive information
3. View image gallery
4. See current occupants (if any)
5. View pricing and specifications

## Database Schema

### Rooms Table Fields
- `room_id` - Primary key
- `room_number` - Unique room identifier
- `room_type` - 'male' or 'female'
- `capacity` - Total number of beds
- `current_occupancy` - Currently occupied beds
- `price_per_month` - Monthly rental price
- `status` - 'available', 'occupied', or 'maintenance'
- `floor` - Floor number
- `description` - Room description (optional)

### Automatic Calculations
- **Available Slots** = Capacity - Current Occupancy
- **Occupancy** updates automatically when bookings are made
- **Status** reflects current state

## Security Features
- SQL injection prevention (prepared statements)
- Input sanitization
- Duplicate room number check
- Capacity validation (can't be less than occupancy)
- Session-based messaging

## Important Notes

### Room Availability Logic
- A room is considered "Available" when:
  - Status is 'available'
  - AND available_slots > 0
- Unavailable rooms show with gray overlay
- Opacity reduced to 0.7 for visual feedback

### Occupancy Management
- Current occupancy is tracked in database
- Updates automatically when reservations are made
- Cannot set capacity lower than current occupancy
- Prevents data inconsistency

### File Paths
All file paths use `../` to navigate:
- `../Images/` for all images
- `../php/` for backend scripts
- `../css/` for stylesheets
- `../js/` for JavaScript
- `../Admin-reservation/` for reservation link

## Customization

### Change Colors
Edit `css/style.css`:
- Orange: `#ff4e00`
- Yellow: `#ec9f05`
- Green: `#22c55e`
- Blue: `#2563eb`
- Red: `#ef4444`

### Add More Room Fields
1. Update database schema
2. Add form fields in modals
3. Update PHP handlers (add_room.php, edit_room.php)
4. Update display in room details

### Change Image Gallery
Edit room details page:
- Add more thumbnail images
- Change image sources
- Customize transition effects

## Troubleshooting

**Problem**: Rooms not showing
**Solution**: Check database has rooms table and data

**Problem**: Edit button not working
**Solution**: Check browser console for JavaScript errors

**Problem**: Can't add room
**Solution**: Check room number doesn't already exist

**Problem**: Images not showing
**Solution**: Verify Images folder exists at `../Images/`

**Problem**: Modal not opening
**Solution**: Ensure overlay div exists and JavaScript is loaded

**Problem**: "Room number already exists" error
**Solution**: Choose a different room number (must be unique)

## Integration with Reservation System

The room system integrates with your reservation system:
- Occupancy updates when reservations are made
- Room status affects availability
- Current occupants shown in room details
- Link to view all reservations

## Sample Data

The database includes sample rooms:
- Room 101-103 (Male, Floor 1)
- Room 201-203 (Female, Floor 2)
- Room 204 (Male, Floor 2, Occupied)
- Room 305 (Male, Floor 3)

You can add more rooms using the "+ Add Room" button.

## Features Showcase

### Visual Status System
- ✅ Green checkmark for availability
- 💰 Price display
- 🛏️ Bed count
- 📍 Floor indicator
- 🔧 Maintenance status
- 🚫 Occupied overlay

### Modal System
- Smooth animations
- Click outside to close
- Form validation
- Real-time data loading
- Success/error messages

### Responsive Design
- Desktop: 4 columns
- Tablet: 3 columns
- Mobile: 2 columns
- Small screens: 1 column

## Next Steps

1. ✅ Import database
2. ✅ Copy files to htdocs
3. ✅ Add images
4. ✅ Test add room
5. ✅ Test edit room
6. ✅ Test room details
7. 🎯 Integrate with dashboard
8. 🎯 Add room images upload
9. 🎯 Add room amenities management

## Support

Check inline code comments in each file for detailed documentation.

---

🎉 **Your admin rooms system is ready!**

Design is exactly as you specified, with full database functionality, add/edit features, and comprehensive room management!

All files use `../` paths and are separated into clean PHP, CSS, and JS files as requested.
