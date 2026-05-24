from django.contrib import admin
from tracking.models import ViewEvent


class ViewEventAdmin(admin.ModelAdmin):
    list_display = ['document', 'ip_address', 'viewed_at', 'time_spent_seconds', 'is_bot']
    list_filter = ['viewed_at', 'is_bot']
    search_fields = ['document__title', 'ip_address']
    readonly_fields = ['viewed_at']


admin.site.register(ViewEvent, ViewEventAdmin)
