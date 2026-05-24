from django.urls import path
from . import views

urlpatterns = [
    path('', views.DocumentListCreateView.as_view(), name='document-list-create'),
    path('<uuid:pk>/', views.DocumentDetailView.as_view(), name='document-detail'),
    path('share/<uuid:document_id>/', views.document_share_view, name='document-share'),
    path('share/<uuid:document_id>/verify-password/', views.verify_document_password, name='verify-password'),
    path('download/<uuid:document_id>/', views.document_download, name='document-download'),
]
