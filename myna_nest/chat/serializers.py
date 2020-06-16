from rest_framework import serializers
from .models import Message,MessageThread

class MessagesSerializer(serializers.ListSerializer):
    class Meta:
        model=Message
        fields='_all_'

class ThreadsSerializer(serializers.ListSerializer):
    class Meta:
        model= MessageThread
        fields='__all__'

