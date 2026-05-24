# DocTrack - Free Document Tracking

A free alternative to DocSend for document tracking and analytics.

## Features

- ✅ Document upload and management
- ✅ Secure sharing with password protection
- ✅ Document expiry dates
- ✅ View tracking (views, unique IPs, time spent)
- ✅ Analytics dashboard with charts
- ✅ Download tracking
- ✅ Platform detection (Desktop/Mobile/Tablet/Bot)

## Tech Stack

- **Backend**: Django + Django REST Framework
- **Frontend**: HTML + Tailwind CSS + Chart.js
- **Database**: SQLite (production-ready with PostgreSQL option)

## Setup

```bash
# Install dependencies
pip install django djangorestframework Pillow django-ipware

# Run migrations
python manage.py migrate

# Create admin user (optional)
python manage.py createsuperuser

# Start server
python manage.py runserver
```

## Usage

1. Open http://localhost:8000
2. Click "Upload Document" to add files
3. Share documents via the generated link
4. Track views in the analytics dashboard

## Deployment

### On Render (Free Tier)

1. Create a `requirements.txt`:
```bash
pip freeze > requirements.txt
```

2. Push to GitHub and connect to Render

3. Add environment variables:
   - `DJANGO_SETTINGS_MODULE=doctrack.settings`
   - `SECRET_KEY=<your-secret-key>`

## File Structure

```
OpenCode/
├── manage.py
├── doctrack/
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── documents/
│   ├── models.py
│   ├── views.py
│   ├── serializers.py
│   ├── admin.py
│   └── urls.py
├── tracking/
│   ├── models.py
│   ├── views.py
│   ├── serializers.py
│   └── urls.py
├── templates/
│   └── index.html
└── media/
    └── documents/ (uploaded files)
```

## API Endpoints

### Documents
- `POST /api/` - Upload document
- `GET /api/` - List user documents
- `GET /api/{id}/` - Document details
- `DELETE /api/{id}/` - Delete document

### Sharing & Tracking
- `GET /share/{id}/` - View document (public)
- `POST /share/{id}/verify-password/` - Verify password
- `GET /download/{id}/` - Download document
- `POST /api/events/view/{id}/` - Record view event
- `GET /api/analytics/{id}/` - View analytics

## Future Enhancements

- [ ] Email notifications
- [ ] Document watermarking
- [ ] Heatmaps for document pages
- [ ] Viewer identity verification
- [ ] API rate limiting
- [ ] Multi-file support (ZIP uploads)
- [ ] Viewer comments

## License

MIT License - Free to use and modify
