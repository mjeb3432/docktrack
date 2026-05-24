from rest_framework import serializers
from .models import Document
import hashlib


class DocumentSerializer(serializers.ModelSerializer):
    user = serializers.ReadOnlyField(source='user.username')
    download_url = serializers.SerializerMethodField()
    shared_url = serializers.SerializerMethodField()
    password_hash = serializers.CharField(write_only=True, required=False, style={'input_type': 'password'})

    class Meta:
        model = Document
        fields = [
            'id', 'title', 'file', 'file_type', 'file_size',
            'user', 'uploaded_at', 'view_count', 'download_count',
            'password_protected', 'password_hash', 'expires_at', 'download_url', 'shared_url'
        ]
        read_only_fields = ['id', 'user', 'uploaded_at', 'view_count', 'download_count']

    def get_download_url(self, obj):
        return f"/api/documents/{obj.id}/download/"

    def get_shared_url(self, obj):
        return f"/share/{obj.id}/"

    def create(self, validated_data):
        password_hash = validated_data.pop('password_hash', None)
        document = Document.objects.create(**validated_data)
        
        if password_hash:
            document.password_hash = hashlib.sha256(password_hash.encode()).hexdigest()
            document.save()
        
        return document


class DocumentListSerializer(serializers.ModelSerializer):
    shared_url = serializers.SerializerMethodField()
    file_type_icon = serializers.SerializerMethodField()

    class Meta:
        model = Document
        fields = ['id', 'title', 'file_type', 'file_size', 'uploaded_at', 'view_count', 'shared_url', 'file_type_icon']
        read_only_fields = ['id', 'uploaded_at', 'view_count']

    def get_shared_url(self, obj):
        return f"/share/{obj.id}/"

    def get_file_type_icon(self, obj):
        icons = {
            'pdf': '📄',
            'doc': '📝',
            'docx': '📝',
            'txt': '📄',
            'xls': '📊',
            'xlsx': '📊',
            'jpg': '🖼️',
            'png': '🖼️',
        }
        return icons.get(obj.file_type, '📄')
