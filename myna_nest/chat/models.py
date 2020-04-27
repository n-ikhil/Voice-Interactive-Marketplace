from django.db import models
from profiles.models import User


# Create your models here.
class MessageThread(models.Model):
    member1=models.ForeignKey(User,on_delete=models.CASCADE,related_name="participant1") # alphabetically smaller number/id
    member2=models.ForeignKey(User,on_delete=models.CASCADE,related_name="participant2") # alphabetically larger number/id

class Message(models.Model):
    thread=models.ForeignKey(MessageThread,on_delete=models.CASCADE)
    sender=models.ForeignKey(User,on_delete=models.CASCADE,related_name="messageSender")
    reciever=models.ForeignKey(User,on_delete=models.CASCADE,related_name="messageReciever")
    timeStamp=models.DateTimeField(auto_now_add=True)
    
