from django.shortcuts import render
from rest_framework import generics
from .serializers import MessagesSerializer,ThreadsSerializer
from .models import Message,MessageThread
from django.contrib.auth.models import User
# from django.db.models import Q
from rest_framework.authtoken.models import Token
    
    


# Create your views here.


def tokentoUserId(token):# helper function
    user = Token.objects.get(key=token).user
    return user.id

def userNameToUserId(name):# helper function
    user=User.objects.get(username=name)
    return user.id


class ChatThread(generics.ListAPIView):
    seriliazer_class=MessagesSerializer
    model=Message
    def get_queryset(self):
        requester=tokentoUserId(self.request.META.get('HTTP_AUTHORIZATION') )
        otherPerson= self.kwargs["username"]
        
        if requester > otherPerson:
            requester,person=person,requester

        return Message.objects.get(member1=requester,member2=otherPerson)

class ThreadHistory(generics.ListAPIView):
    serialzer_class=ThreadsSerializer
    model=MessageThread

    def get_queryset(self):
        requester=tokentoUserId(self.request.META.get('HTTP_AUTHORIZATION') )
        return MessageThread.objects.filter(member1=requester) | User.objects.filter(member2=requester)

