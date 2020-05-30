from django.db import models
from django.conf import settings
from django.core.exceptions import ObjectDoesNotExist
from django.contrib.auth.models import AbstractUser
# Create your models here.



class User(AbstractUser):
	email = models.EmailField(verbose_name='email',max_length=255,unique=True)
	phno = models.CharField(verbose_name='phone number',max_length=12)
	username = models.CharField(verbose_name='username',max_length=100,null = True,blank=True)
	language=models.CharField(verbose_name='language',max_length=30,null=True,blank=True)
	address = models.TextField()
	REQUIRED_FIELDS = ['username']

	USERNAME_FIELD = 'email'


	def get_username(self):
		return self.email




# class Provider(models.Model):
# 	title = models.CharField(verbose_name = 'name of the company',max_length=100)
# 	address = models.TextField(null=True,blank=True)
# 	description = models.TextField(blank=True,null=True)
# 	user = models.OneToOneField(settings.AUTH_USER_MODEL,on_delete=models.CASCADE)
# 	rating = models.DecimalField(max_digits = 5,decimal_places=2,null=True,blank=True)

# 	def __str__(self):
# 		return self.title


# class Products(models.Model):
# 	provider = models.ForeignKey(Provider,on_delete=models.CASCADE)
# 	name = models.CharField(verbose_name='product or service name',max_length=100)
# 	quantity = models.CharField(verbose_name='product quantity',max_length=1000,null=True,blank=True)
# 	location = models.TextField()
# 	mode = models.CharField(verbose_name='mode',max_length=10)
# 	# images = models.ImageField()

# 	def __str__(self):
# 		return self.name  + " | " + self.mode



# class Seeker(models.Model):
# 	user = models.OneToOneField(settings.AUTH_USER_MODEL,on_delete=models.CASCADE)
# 	marked = models.ManyToManyField(Products,blank=True)

# 	def __str__(self):
# 		return self.user.email + " | " + self.user.phno

