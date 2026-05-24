from django.db import models
from documents.models import Document
import json


class ViewEvent(models.Model):
    document = models.ForeignKey(Document, on_delete=models.CASCADE, related_name='view_events')
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    user_agent = models.TextField(blank=True)
    referer = models.CharField(max_length=255, blank=True)
    viewed_at = models.DateTimeField(auto_now_add=True)
    pages_viewed = models.JSONField(default=list)
    time_spent_seconds = models.PositiveIntegerField(default=0)
    is_bot = models.BooleanField(default=False)

    class Meta:
        ordering = ['-viewed_at']

    def __str__(self):
        return f"{self.document.title} - {self.ip_address or 'Unknown'}"
