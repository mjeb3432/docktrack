from django.urls import path
from . import views

urlpatterns = [
    path('events/view/<uuid:document_id>/', views.record_view_event, name='record-view-event'),
    path('analytics/<uuid:document_id>/', views.document_analytics, name='document-analytics'),
    path('events/update-time/<uuid:document_id>/', views.update_view_time, name='update-view-time'),
]
