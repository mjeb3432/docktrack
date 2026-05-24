from django.shortcuts import get_object_or_404
from django.http import HttpResponse
from rest_framework import status, generics, permissions
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from django.utils import timezone
import hashlib
import uuid

from .models import Document
from .serializers import DocumentSerializer, DocumentListSerializer


class IsOwner(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        return obj.user == request.user


class DocumentListCreateView(generics.ListCreateAPIView):
    serializer_class = DocumentListSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Document.objects.filter(user=self.request.user).order_by('-uploaded_at')

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class DocumentDetailView(generics.RetrieveDestroyAPIView):
    serializer_class = DocumentSerializer
    permission_classes = [permissions.IsAuthenticated, IsOwner]

    def get_queryset(self):
        return Document.objects.filter(user=self.request.user)


@api_view(['GET'])
@permission_classes([AllowAny])
def document_share_view(request, document_id):
    document = get_object_or_404(Document, id=document_id)
    
    if document.expires_at and timezone.now() > document.expires_at:
        return Response({'error': 'This document has expired'}, status=status.HTTP_404_NOT_FOUND)
    
    document.view_count += 1
    document.save()
    
    serializer = DocumentSerializer(document)
    return Response(serializer.data)


@api_view(['POST'])
@permission_classes([AllowAny])
def verify_document_password(request, document_id):
    document = get_object_or_404(Document, id=document_id)
    
    if not document.password_protected:
        return Response({'error': 'Document is not password protected'}, status=status.HTTP_400_BAD_REQUEST)
    
    input_hash = hashlib.sha256(request.data.get('password', '').encode()).hexdigest()
    
    if input_hash == document.password_hash:
        document.view_count += 1
        document.save()
        return Response({'verified': True, 'document_id': str(document.id)})
    
    return Response({'verified': False}, status=status.HTTP_401_UNAUTHORIZED)


@api_view(['GET'])
@permission_classes([AllowAny])
def document_download(request, document_id):
    document = get_object_or_404(Document, id=document_id)
    
    if document.expires_at and timezone.now() > document.expires_at:
        return Response({'error': 'This document has expired'}, status=status.HTTP_404_NOT_FOUND)
    
    document.download_count += 1
    document.save()
    
    response = HttpResponse(document.file, content_type=document.file.content_type)
    response['Content-Disposition'] = f'attachment; filename="{document.title}.{document.file_type}"'
    return response
