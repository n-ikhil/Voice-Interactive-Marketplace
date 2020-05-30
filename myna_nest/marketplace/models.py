from django.db import models
from profiles.models import User
from django.conf import settings

# Create your models here.
languages=[("english","english"),("hindi","hindi"),("kannada","kannada"),("telugu","telugu"),("tamil","tamil"),("bengali","bengali")]

class Category(models.Model):
    name=models.CharField(max_length=30,verbose_name="Product Category",unique=True)

    def __str__(self):
      return self.name

class StandardProductName(models.Model):
    # productId=models.ForeignKey(StandardProduct)
    language=models.CharField(max_length=30,choices=languages)
    name=models.CharField(max_length=40)

    def __str__(self):
      return self.name


class StandardProduct(models.Model):
    name=models.CharField(max_length=30,verbose_name="Product name",unique=True)
    altNames=models.ManyToManyField(StandardProductName)
    category=models.ManyToManyField(Category)

    def __str__(self):
      return self.name


class Product(models.Model):
    pId=models.ForeignKey(StandardProduct,verbose_name="Product name",on_delete=models.CASCADE)
    owner=models.ForeignKey(User,verbose_name="Owner of the object",on_delete=models.CASCADE)
    location=models.CharField(max_length=30,verbose_name="Location of the product")
    quantity = models.CharField(verbose_name='product quantity',max_length=1000,null=True,blank=True)
    #isRentable=models.BooleanField(verbose_name="Avaible for length")
    mode = models.CharField(verbose_name='mode',max_length=10,choices=[('sell','SELL'),('rent','RENT'),('service','SERVICE')])
    #savedProducts = models.ManyToManyField(settings.AUTH_USER_MODEL,verbose_name='saved products');
    


