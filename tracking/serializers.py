from rest_framework import serializers
from .models import ViewEvent


class ViewEventSerializer(serializers.ModelSerializer):
    class Meta:
        model = ViewEvent
        fields = ['id', 'document', 'ip_address', 'user_agent', 'viewed_at', 'time_spent_seconds']
        read_only_fields = ['id', 'viewed_at']
