from django.db import models
from profiles.models import User


# Create your models here.
class Thread(models.Model):
    member1=models.ForeignKey(User) # alphabetically smaller number/id
    member2=models.ForeignKey(User) # alphabetically larger number/id

class Message(models.Model):
    thread=models.ForeignKey(Thread)
    sender=models.ForeignKey(User)
    reciever=models.ForeignKey(User)
    timeStamp=models.DateTimeField(auto_now_add=True)
    
