from django.db import models
from django.conf import settings
from django.core.exceptions import ObjectDoesNotExist
from django.contrib.auth.models import AbstractUser

# Create your models here.



class User(AbstractUser):
	email = models.EmailField(verbose_name='email',max_length=255,unique=True)
	phno = models.CharField(verbose_name='phone number',max_length=12)
	username = models.CharField(verbose_name='username',max_length=100,null = True,blank=True)
	REQUIRED_FIELDS = ['username']

	USERNAME_FIELD = 'email'


	def get_username(self):
		return self.email


# class Seeker(models.Model):
# 	user = models.OneToOneField(settings.AUTH_USER_MODEL,on_delete=models.CASCADE)
# 	#email = models.CharField(max_length=255)
# 	phno = models.CharField(max_length=10)
# 	address = models.TextField(null=True,blank=True)


# 	def __str__(self):
# 		return self.user.email + " | " + self.phno

# class Provider(models.Model):
# 	title = models.CharField(verbose_name = 'name of the company',max_length=100)
# 	services = models.TextField()
# 	user = models.OneToOneField(settings.AUTH_USER_MODEL,on_delete=models.CASCADE)
# 	#email = models.CharField(max_length=255)
# 	phno = models.CharField(max_length=10)
# 	address = models.TextField()
# 	rating = models.DecimalField(max_digits = 5,decimal_places=2,null=True,blank=True)

# 	def __str__(self):
# 		return self.title