# University ID Maker System (Vue 3)

Project proposal: Central Philippines State University, San Carlos Campus, College of Computer Studies (PFIT 03).

Full documentation (workflow, data model, permissions, user guide, test checklist): see `docs/DOCUMENTATION.md`.

## Run it
```bash
npm install
npm run dev      # open the printed localhost link
npm run build    # production build in dist/
```

## Demo accounts
| Role | Username | Password |
| --- | --- | --- |
| Administrator | admin | Admin@2026 |
| Authorized personnel (ID officer) | idofficer | Officer@2026 |
| Student | student | Student@2026 |

## How it maps to the proposal's objectives
1. Data-entry module: full name, ID number, course or department, profile photo (ID records page).
2. Automated ID generation: standardized front and back card template, live preview while typing.
3. Centralized database: search and filter by name, ID number, course, status; update records.
4. Print-ready cards: Print queue lays out 9 cards per A4 sheet at 54 x 85.6 mm, fronts then mirrored backs for duplex.
5. Authentication and access control: sign-in required; students only see their own application; only admin and ID officers approve or edit; only admin deletes.
6. Status monitoring and reporting: Pending, Approved, Printed, Released, Rejected, with a dashboard and transaction log.

Data is kept in the browser's localStorage, so this is a front-end prototype. A real deployment needs a server and database for secure passwords and shared records.
