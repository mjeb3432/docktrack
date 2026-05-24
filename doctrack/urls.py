from django.shortcuts import render
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static


def frontend_view(request):
    return render(request, 'index.html', {})


urlpatterns = [
    path('', frontend_view, name='frontend'),
    path('api/', include('documents.urls')),
    path('api/', include('tracking.urls')),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
