from rest_framework import serializers
from .models import Message,Thread

class MessagesSerializer(serializers.ListSerializer):
    class Meta:
        model=Message
        fields='_all_'

class ThreadsSerializer(serializers.ListSerializer):
    class Meta:
        model= Thread
        fields='__all__'
        
