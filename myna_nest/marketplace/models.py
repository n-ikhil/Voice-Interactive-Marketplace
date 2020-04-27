from django.db import models
from profiles.models import User
from django.conf import settings

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
    pId=models.ForeignKey(StandardProduct,verbose_name="Product name",on_delete=models.CASCADE)
    owner=models.ForeignKey(User,verbose_name="Owner of the object",on_delete=models.CASCADE)
    location=models.CharField(max_length=30,verbose_name="Location of the product")
    isRentable=models.BooleanField(verbose_name="Avaible for length")

    



class Provider(models.Model):
    title = models.CharField(verbose_name = 'name of the company',max_length=100)
    address = models.TextField(null=True,blank=True)
    description = models.TextField(blank=True,null=True)
    user = models.OneToOneField(settings.AUTH_USER_MODEL,on_delete=models.CASCADE)
    rating = models.DecimalField(max_digits = 5,decimal_places=2,null=True,blank=True)

    def __str__(self):
        return self.title


class Products(models.Model):
  provider = models.ForeignKey(Provider,on_delete=models.CASCADE)
  name = models.CharField(verbose_name='product or service name',max_length=100)
  quantity = models.CharField(verbose_name='product quantity',max_length=1000,null=True,blank=True)
  location=models.CharField(max_length=30,verbose_name="Location of the product")
  mode = models.CharField(verbose_name='mode',max_length=10)
  # images = models.ImageField()

  def __str__(self):
      return self.name  + " | " + self.mode



class Seeker(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL,on_delete=models.CASCADE)
    marked = models.ManyToManyField(Products,blank=True)

    def __str__(self):
        return self.user.email + " | " + self.user.phno