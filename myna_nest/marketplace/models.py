from django.db import models
from profiles.models import User

# Create your models here.
languages=[("english","english"),("hindi","hindi"),("kannada","kannada"),("telugu","telugu"),("tamil","tamil"),("bengali","bengali")]

class Category(models.Model):
    name=models.CharField(max_length=30,verbose_name="Product Category",unique=True)

class StandardProductName(models.Model):
    # productId=models.ForeignKey(StandardProduct)
    language=models.CharField(max_length=30,choices=languages)
    name=models.CharField(max_length=40)


class StandardProduct(models.Model):
    name=models.CharField(max_length=30,verbose_name="Product name",unique=True)
    altNames=models.ManyToManyField(StandardProductName)
    category=models.ManyToManyField(Category)

class Product(models.Model):
    owner=models.ForeignKey(User,verbose_name="Owner of the object",on_delete=models.CASCADE)
    location=models.CharField(max_length=30,verbose_name="Location of the product")
    isRentable=models.BooleanField(verbose_name="Avaible for length")
    

