from django.contrib import admin
from . import models
# Register your models here.
admin.site.register(models.Category)
admin.site.register(models.Product)
admin.site.register(models.StandardProduct)
admin.site.register(models.StandardProductName)

admin.site.register(models.Seeker)
admin.site.register(models.Provider)
admin.site.register(models.Products)
# admin.site.register(models.Category)