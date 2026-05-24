from django.contrib import admin
from .models import Document


class DocumentAdmin(admin.ModelAdmin):
    list_display = ['title', 'user', 'file_type', 'file_size', 'view_count', 'download_count', 'uploaded_at', 'expires_at']
    list_filter = ['uploaded_at', 'expires_at', 'password_protected']
    search_fields = ['title', 'user__username']
    readonly_fields = ['view_count', 'download_count', 'uploaded_at']
    
    def user(self, obj):
        return obj.user.username
    user.admin_order_field = 'user'


admin.site.register(Document, DocumentAdmin)
