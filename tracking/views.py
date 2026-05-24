from django.shortcuts import get_object_or_404
from rest_framework import status, permissions
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from django.utils import timezone
from ipware import get_client_ip
import platform
import re

from .models import ViewEvent
from documents.models import Document


class IsOwner(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        return obj.document.user == request.user


@api_view(['POST'])
@permission_classes([AllowAny])
def record_view_event(request, document_id):
    document = get_object_or_404(Document, id=document_id)
    
    if document.expires_at and timezone.now() > document.expires_at:
        return Response({'error': 'This document has expired'}, status=status.HTTP_404_NOT_FOUND)
    
    ip, is_routable = get_client_ip(request)
    user_agent = request.headers.get('User-Agent', '')
    
    is_bot = False
    bot_patterns = ['bot', 'crawler', 'spider', 'scraper']
    for pattern in bot_patterns:
        if pattern.lower() in user_agent.lower():
            is_bot = True
            break
    
    view_event = ViewEvent.objects.create(
        document=document,
        ip_address=ip,
        user_agent=user_agent,
        referer=request.headers.get('Referer', ''),
        is_bot=is_bot
    )
    
    document.view_count += 1
    document.save()
    
    return Response({
        'success': True,
        'event_id': view_event.id,
        'view_count': document.view_count
    })


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def document_analytics(request, document_id):
    document = get_object_or_404(Document, id=document_id, user=request.user)
    
    views = document.view_events.all().order_by('-viewed_at')
    
    total_views = views.count()
    unique_ips = views.values('ip_address').distinct().count()
    
    non_bot_views = views.filter(is_bot=False)
    avg_time_spent = 0
    if non_bot_views.exists():
        total_time = sum(v.time_spent_seconds for v in non_bot_views)
        avg_time_spent = total_time // non_bot_views.count()
    
    daily_views = []
    for view in non_bot_views:
        date = view.viewed_at.date()
        existing = next((d for d in daily_views if d['date'] == date), None)
        if existing:
            existing['count'] += 1
        else:
            daily_views.append({'date': date, 'count': 1})
    
    platform_counts = {'Desktop': 0, 'Mobile': 0, 'Tablet': 0, 'Bot': 0}
    for view in non_bot_views:
        ua = view.user_agent.lower()
        if view.is_bot:
            platform_counts['Bot'] += 1
        elif 'mobile' in ua or 'android' in ua or 'iphone' in ua:
            platform_counts['Mobile'] += 1
        elif 'ipad' in ua or 'tablet' in ua:
            platform_counts['Tablet'] += 1
        else:
            platform_counts['Desktop'] += 1
    
    return Response({
        'total_views': total_views,
        'unique_ips': unique_ips,
        'avg_time_spent_seconds': avg_time_spent,
        'platform_breakdown': platform_counts,
        'daily_views': daily_views[:30]
    })


@api_view(['POST'])
@permission_classes([AllowAny])
def update_view_time(request, document_id):
    document = get_object_or_404(Document, id=document_id)
    
    event_id = request.data.get('event_id')
    time_spent = request.data.get('time_spent', 0)
    
    if event_id:
        try:
            event = ViewEvent.objects.get(id=event_id, document=document)
            event.time_spent_seconds = time_spent
            event.save()
        except ViewEvent.DoesNotExist:
            pass
    
    return Response({'success': True})
