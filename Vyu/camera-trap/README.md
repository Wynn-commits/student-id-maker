# Camera Trap Monitoring System
Monitoring dashboard for camera-trap sightings and individual monkey recognition. Built with Vue 3, Vue Router, and Vite.

    npm install
    npm run dev      # development
    npm run build    # production build in dist/ (hash routing, works on any static host)

Pages: Sign in, Dashboard, Monkey Profiles, Sighting Review, Camera Traps, and Users. The app opens directly
to the monitoring system; unauthenticated visitors are sent to sign in.

Dashboard values are sample data in `src/data.js`. A live Node.js/Express + MySQL back end and Python
recognition service are not included in this front end.
