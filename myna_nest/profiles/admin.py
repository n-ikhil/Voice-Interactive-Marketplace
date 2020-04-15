from django.contrib import admin
from .models import Seeker,Provider,User
# Register your models here.


admin.site.register(Seeker)
admin.site.register(Provider)
admin.site.register(User)